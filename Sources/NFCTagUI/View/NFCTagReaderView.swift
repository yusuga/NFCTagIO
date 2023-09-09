//
//  NFCTagReaderView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import SwiftUI
import CoreNFC
import NFCTagIO

public struct NFCTagReaderView: View {

  @Bindable private var reader = NFCTagReader()
  @State private var scanError: LocalizedErrorModel?
  
  public init() { }

  public var body: some View {
    List {
      if let error = reader.error {
        Section("NFCReaderError") {
          LabeledContent("localizedDescription", value: error.localizedDescription)
          if let error = error as? NFCReaderError {
            LabeledContent("errorCode", value:  error.errorCode.description)
          }
        }
      }
    }
    .animation(.default, value: UUID())
    .overlay {
      if reader.error == nil {
        NFCReaderEmptyView(isScanning: reader.isScanning)
      }
    }
    .navigationTitle("NFCTagReader")
    .toolbar {
      if reader.error != nil {
        ToolbarItem(placement: .destructiveAction) {
          Button("Clear") {
            reader.error = nil
          }
          .tint(.red)
        }
      }
    }
    .navigationDestination(item: $reader.scannedMessage) {
      NFCNDEFMessageView(message: $0)
    }

    ScanView() { scanningMode in
      do {
        try reader.beginScanning(
          mode: scanningMode,
          alertMessage: .default) {
            guard let error = ($0 as? NFCReaderError) else {
              return .restartPolling
            }
            switch error.code {
            case .ndefReaderSessionErrorZeroLengthMessage:
              return .invalidate(errorMessage: error.localizedDescription)
            default:
              return .restartPolling
            }
          }
      } catch {
        scanError = .init(error: error)
      }
    }
    .alert(isPresented: .constant(scanError != nil), error: scanError) {
      Button("OK") {
        scanError = nil
      }
    }
  }
}

private struct ScanView: View {
  
  enum Mode: String, Hashable, CaseIterable {
    case read
    case write
  }

  @State var selectedMode: Mode = .read
  @State var writeRecordType: WellKnownNDEFRecordType = .T
  @State var writePayload: String = ""
  
  let scanAction: (NFCTagReader.ScanningMode) -> Void

  var body: some View {
    VStack(spacing: 16) {
      Picker(
        "",
        selection: $selectedMode,
        content: {
          ForEach(Mode.allCases, id: \.self) {
            Text($0.rawValue)
          }
        }
      )
      .pickerStyle(.segmented)
      
      if case .write = selectedMode {
        VStack(alignment: .leading) {
          LabeledContent("RecordType") {
            Picker(
              "",
              selection: $writeRecordType,
              content: {
                ForEach([WellKnownNDEFRecordType.T, .U], id: \.self) {
                  Text($0.description)
                }
              }
            )
          }
          
          GroupBox("Payload") {
            TextEditor(text: $writePayload)
              .clipShape(.rect(cornerRadius: 4, style: .continuous))
              .frame(height: 100)
          }
        }
      }

      Button(
        action: {
          switch selectedMode {
          case .read:
            scanAction(.read)
          case .write:
            guard let payload = payload else { return }
            scanAction(.write(.init(records: [payload])))
          }
        },
        label: {
          Label("SCAN", systemImage: "wave.3.forward.circle")
            .font(.largeTitle)
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.capsule)
      .disabled(!isScannable)
    }
    .padding()
  }
  
  private var isScannable: Bool {
    switch selectedMode {
    case .read:
      true
    case .write:
      !writePayload.isEmpty
    }
  }

  private var payload: NFCNDEFPayload? {
    switch writeRecordType {
    case .T:
      NFCNDEFPayload.wellKnownTypeTextPayload(
        string: writePayload,
        locale: Locale(identifier: "en")
      )
    case .U:
      NFCNDEFPayload.wellKnownTypeURIPayload(
        string: writePayload
      )
    default:
      nil
    }
  }
}

#Preview {
  NavigationStack {
    NFCTagReaderView()
  }
}
