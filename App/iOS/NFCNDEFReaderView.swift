//
//  NFCNDEFReaderView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/18.
//

import SwiftUI
import NFCTagIO

struct NFCNDEFReaderView: View {

  @Bindable private var reader = NFCNDEFReader()
  @State private var isSingleScan = true
  @State private var scanError: LocalizedErrorModel?

  var body: some View {
    List {
      Section {
        ForEach(reader.messages, id: \.self) {
          Text($0.description)
        }
      } header: {
        if reader.messages.isEmpty {
          EmptyView()
        } else {
          RightButtonHeader(title: "NFCNDEFMessage", buttonTitle: "Clear") {
            reader.clearMessages()
          }
        }
      }

      if let error = reader.error {
        Section {
          LabeledContent("localizedDescription", value: error.localizedDescription)
          LabeledContent("errorCode", value: error.errorCode.description)
        } header: {
          RightButtonHeader(title: "NFCReaderError", buttonTitle: "Clear") {
            reader.clearErrors()
          }
        }
      }

      if let error = reader.unknownError {
        Section {
          LabeledContent("localizedDescription", value: error.localizedDescription)
        } header: {
          RightButtonHeader(title: "UnknownError", buttonTitle: "Clear") {
            reader.clearErrors()
          }
        }
      }
    }
    .overlay {
      if reader.messages.isEmpty, !reader.hasError {
        ContentUnavailableView {
          if reader.isScanning {
            ProgressView()
          } else {
            Label("No Messages", systemImage: "tray.fill")
          }
        } description: {
          if reader.isScanning {
            Text("Scanning...")
          } else {
            Text("Please start by pressing the SCAN button below.")
          }
        }
      }
    }
    .navigationTitle("NDEF Reader")

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
            "abc",
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

#Preview {
  NavigationStack {
    NFCNDEFReaderView()
  }
}
