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

    NFCTagScanView() { scanningMode in
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

#Preview {
  NavigationStack {
    NFCTagReaderView()
  }
}
