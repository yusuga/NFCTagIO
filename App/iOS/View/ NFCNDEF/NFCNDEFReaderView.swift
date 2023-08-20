//
//  NFCNDEFReaderView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/18.
//

import SwiftUI
import CoreNFC
import NFCTagIO

struct NFCNDEFReaderView: View {

  @Bindable private var reader = NFCNDEFReader()
  @State private var isSingleScan = true
  @State private var scanError: LocalizedErrorModel?

  var body: some View {
    List {
      Section {
        ForEach(reader.messages, id: \.self) { message in
          NavigationLink {
            NFCNDEFMessageView(message: message)
          } label: {
            LabeledContent("Message", value: message.formattedLength)
          }
        }
      } header: {
        if reader.messages.isEmpty {
          EmptyView()
        } else {
          Text("NFCNDEFMessage")
        }
      }

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
      if !reader.hasContents {
        NFCReaderEmptyView(isScanning: reader.isScanning)
      }
    }
    .navigationTitle("NFCNDEFReader")
    .toolbar {
      if reader.hasContents {
        ToolbarItem(placement: .destructiveAction) {
          Button("Clear") {
            reader.clear()
          }
          .tint(.red)
        }
      }
    }

    ScanView(isSingleScan: $isSingleScan) {
      do {
        try reader.beginScanning(
          alertMessage: .default,
          invalidateAfterFirstRead: isSingleScan
        )
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

  @Binding var isSingleScan: Bool
  let scanAction: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      HStack {
        VStack(spacing: 2) {
          Toggle(
            "",
            systemImage: isSingleScan ? "repeat.1" : "repeat",
            isOn: $isSingleScan
          )
          .font(.title2)
          .labelStyle(.iconOnly)
          .toggleStyle(.button)

          Text(isSingleScan ? "Single Scan" : "Multi Scan")
            .font(.caption2)
            .foregroundStyle(.link)
        }
        .frame(minWidth: 80)

        Divider()

        Button(
          action: scanAction,
          label: {
            Label("SCAN", systemImage: "wave.3.forward.circle")
              .font(.largeTitle)
              .frame(maxWidth: .infinity)
          }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 60)
    .padding()
  }
}

private extension NFCNDEFReader {

  var hasContents: Bool {
    !messages.isEmpty || error != nil
  }
}

#Preview {
  NavigationStack {
    NFCNDEFReaderView()
  }
}
