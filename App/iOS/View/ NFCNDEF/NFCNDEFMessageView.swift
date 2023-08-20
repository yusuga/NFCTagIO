//
//  NFCNDEFMessageView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import SwiftUI
import CoreNFC

struct NFCNDEFMessageView: View {

  let message: NFCNDEFMessage
  @State private var selectedContent: RecordContent?

  var body: some View {
    List {
      Section("NFCNDEFMessage") {
        LabeledContent("length", value: message.formattedLength)
      }

      ForEach(Array(message.records.enumerated()), id: \.element) { index, record in
        Section("NFCNDEFPayload: \(index + 1)") {
          RecordContentView(
            title: "typeNameFormat",
            contents: [
              .init(title: "rawValue", value: record.typeNameFormat.rawValue.description),
              .init(title: "description", value: record.typeNameFormat.description),
            ],
            selectedContent: $selectedContent
          )

          RecordContentView(
            title: "type",
            contents: RecordContent.dataContents(from: record.type)
            + [
              (try? record.wellKnownNDEFRecordType())
                .flatMap { .init(title: "description", value: $0.description, isSelectable: true) }
            ]
              .compactMap { $0 },
            selectedContent: $selectedContent
          )

          RecordContentView(
            title: "identifier",
            contents: RecordContent.dataContents(from: record.identifier),
            selectedContent: $selectedContent
          )

          RecordContentView(
            title: "payload",
            contents: RecordContent.dataContents(from: record.payload),
            selectedContent: $selectedContent
          )

          if let uri = record.wellKnownTypeURIPayload()?.absoluteString {
            RecordContentView(
              title: "wellKnownTypeURIPayload",
              contents: [
                .init(title: "URI", value: uri, isSelectable: true)
              ],
              selectedContent: $selectedContent
            )
          }

          let textPayload = record.wellKnownTypeTextPayload()
          if textPayload.0 != nil || textPayload.1 != nil {
            RecordContentView(
              title: "wellKnownTypeTextPayload",
              contents: [
                textPayload.0
                  .flatMap { RecordContent(title: "text", value: $0, isSelectable: true) },
                textPayload.1
                  .flatMap { RecordContent(title: "locale", value: $0.description) },
              ]
                .compactMap { $0 },
              selectedContent: $selectedContent
            )
          }
        }
      }
    }
    .sheet(item: $selectedContent) { content in
      NavigationStack {
        TextDisplayView(content: content)
          .navigationTitle(content.title)
          .navigationBarTitleDisplayMode(.inline)
      }
      .presentationDetents([.medium, .large])
    }
    .navigationTitle("NFCNDEFMessage")
  }
}

private struct RecordContent: Identifiable {

  let title: String
  let value: String?
  var isSelectable = false

  var id: String { title }

  static func dataContents(from data: Data) -> [Self] {
    [
      .init(title: "bytes", value: byteString(from: data)),
      .init(title: "utf8", value: String(data: data, encoding: .utf8), isSelectable: true),
      .init(title: "hex", value: data.hexString, isSelectable: true),
    ]
  }

  static func byteString(from data: Data) -> String {
    ByteCountFormatter.default.string(fromByteCount: Int64(data.count))
  }
}

private struct RecordContentView: View {

  let title: String
  let contents: [RecordContent]
  @Binding var selectedContent: RecordContent?

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)

      GroupBox {
        ForEach(contents) { content in
          if let value = content.value, !value.isEmpty {
            LabeledContent(content.title) {
              if content.isSelectable {
                Button(
                  action: {
                    selectedContent = content
                  },
                  label: {
                    Text(value)
                  }
                )
              } else {
                Text(value)
              }
            }
            .lineLimit(1)
            .truncationMode(.tail)
          }
        }
      }
    }
  }
}

private struct TextDisplayView: View {

  let content: RecordContent
  @Environment(\.dismiss) var dismiss

  var body: some View {
    ScrollView {
      Text(content.value ?? "")
        .textSelection(.enabled)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()

      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Close") {
          dismiss()
        }
      }
    }
  }
}

#Preview {
  NFCNDEFMessageView(
    message: .init(
      records: [
        .wellKnownTypeURIPayload(url: URL(string: "https://apple.com")!)!,
        .wellKnownTypeURIPayload(url: URL(string: "http://google.com")!)!,
        .wellKnownTypeTextPayload(
          string: "The quick brown fox jumps over the lazy dog",
          locale: .current
        )!,
        .wellKnownTypeTextPayload(
          string: Array(repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", count: 10).joined(separator: " "),
          locale: .current
        )!,
      ]
    )
  )
}
