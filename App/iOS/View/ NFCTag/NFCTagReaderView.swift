//
//  NFCTagReaderView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import SwiftUI
import CoreNFC

import CoreNFC
import NFCTagIO

struct NFCTagReaderView: View {

  @Bindable private var reader = NFCTagReader()
  @State private var isSingleScan = true
  @State private var scanError: LocalizedErrorModel?

  var body: some View {
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
        ContentEmptyView(isScanning: reader.isScanning)
      }
    }
    .navigationTitle("NFCTag Reader")
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

    ScanView() {
      do {
        try reader.beginScanning(
          alertMessage: .default
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

  let scanAction: () -> Void

  var body: some View {
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
        Label("Let's Scan!", systemImage: "wave.3.forward.circle")
      }
    } description: {
      if isScanning {
        Text("Scanning...")
      } else {
        Text("Please start by pressing the SCAN button below.")
      }
    }
    .background(Color(.systemGroupedBackground))
  }
}

#Preview {
  NavigationStack {
    NFCTagReaderView()
  }
}
