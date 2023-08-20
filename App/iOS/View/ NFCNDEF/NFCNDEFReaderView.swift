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
          LabeledContent("errorCode", value: error.errorCode.description)
        }
      }

      if let error = reader.unknownError {
        Section("UnknownError") {
          LabeledContent("localizedDescription", value: error.localizedDescription)
        }
      }
    }
    .animation(.default, value: UUID())
    .overlay {
      if !reader.hasContents {
        ContentEmptyView(isScanning: reader.isScanning)
      }
    }
    .navigationTitle("NDEF Reader")
    .toolbar {
      if reader.hasContents {
        ToolbarItem(placement: .destructiveAction) {
          Button("Clear") { reader.clear() }
            .tint(.red)
        }
      }
    }

    ScanView(isSingleScan: $isSingleScan) {
      do {
        try reader.beginScanning(
          alertMessage: "Please bring the device close to the tag",
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

private struct ContentEmptyView: View {

  let isScanning: Bool

  var body: some View {
    ContentUnavailableView {
      if isScanning {
        ProgressView()
      } else {
        Label("No Messages", systemImage: "tray.fill")
      }
    } description: {
      if isScanning {
        Text("Scanning...")
      } else {
        Text("Please start by pressing the SCAN button below.")
      }
    }
  }
}

private extension NFCNDEFReader {

  var hasContents: Bool {
    !messages.isEmpty || hasError
  }
}

#Preview {
  NavigationStack {
    NFCNDEFReaderView()
  }
}
