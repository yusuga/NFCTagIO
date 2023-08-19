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
  @State private var isOneTimeRead = true

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
    .navigationTitle("Reader")

    ScanView(isOneTimeRead: $isOneTimeRead) {
      reader.beginScanning()
    }
  }
}

private struct ScanView: View {

  @Binding var isOneTimeRead: Bool
  let scanAction: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      HStack {
        VStack(spacing: 2) {
          Toggle(
            "OneTimeRead",
            systemImage: isOneTimeRead ? "repeat.1" : "repeat",
            isOn: $isOneTimeRead
          )

          .font(.title2)
          .labelStyle(.iconOnly)
          .toggleStyle(.button)

          Text("OneTimeRead")
            .font(.caption2)
        }
        .foregroundStyle(isOneTimeRead ? .blue : .gray)

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
