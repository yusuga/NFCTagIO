//
//  NFCNDEFReaderView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/18.
//

import SwiftUI
import CoreNFC
import NFCTagIO

public struct NFCNDEFReaderView: View {

  @Bindable private var reader = NFCNDEFReader()
  @State private var isSingleScan = true
  @State private var scanError: LocalizedErrorModel?
  
  public init(
    isSingleScan: Bool
  ) {
    self.isSingleScan = isSingleScan
  }

  public var body: some View {
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

    NFCNDEFScanView(isSingleScan: $isSingleScan) {
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

private extension NFCNDEFReader {

  var hasContents: Bool {
    !messages.isEmpty || error != nil
  }
}

#Preview {
  NavigationStack {
    NFCNDEFReaderView(isSingleScan: true)
  }
}
