//
//  NFCTagScanView.swift
//
//
//  Created by yusuga on 2023/09/09.
//

import SwiftUI
import CoreNFC
import NFCTagIO

public struct NFCTagScanView: View {

  public enum Mode: String, Hashable, CaseIterable {
    case read
    case write
  }

  @State private var selectedMode: Mode
  @State private var writeRecordType: WellKnownNDEFRecordType
  @State private var writePayload: String
  private let scanAction: (NFCTagReader.ScanningMode) -> Void

  public init(
    selectedMode: Mode = .read,
    writeRecordType: WellKnownNDEFRecordType = .T,
    writePayload: String = "",
    scanAction: @escaping (NFCTagReader.ScanningMode) -> Void
  ) {
    self.selectedMode = selectedMode
    self.writeRecordType = writeRecordType
    self.writePayload = writePayload
    self.scanAction = scanAction
  }

  public var body: some View {
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

#Preview(traits: .sizeThatFitsLayout) {
  NFCTagScanView() { _ in }
}
