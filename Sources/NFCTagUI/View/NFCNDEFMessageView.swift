//
//  NFCNDEFMessageView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import SwiftUI
import CoreNFC

public struct NFCNDEFMessageView: View {

  private let message: NFCNDEFMessage
  @State private var selectedContent: NFCNDEFMessageRecordContent?

  public init(
    message: NFCNDEFMessage
  ) {
    self.message = message
  }

  public var body: some View {
    List {
      Section("NFCNDEFMessage") {
        LabeledContent("length", value: message.formattedLength)
      }

      ForEach(Array(message.records.enumerated()), id: \.element) { index, record in
        Section("NFCNDEFPayload: \(index + 1)") {
          NFCNDEFMessageRecordContentView(
            title: "typeNameFormat",
            contents: [
              .init(title: "rawValue", value: record.typeNameFormat.rawValue.description),
              .init(title: "description", value: record.typeNameFormat.description),
            ],
            selectedContent: $selectedContent
          )

          NFCNDEFMessageRecordContentView(
            title: "type",
            contents: NFCNDEFMessageRecordContent.dataContents(from: record.type)
            + [
              (try? record.wellKnownNDEFRecordType())
                .flatMap { .init(title: "description", value: $0.description, isSelectable: true) }
            ]
              .compactMap { $0 },
            selectedContent: $selectedContent
          )

          NFCNDEFMessageRecordContentView(
            title: "identifier",
            contents: NFCNDEFMessageRecordContent.dataContents(from: record.identifier),
            selectedContent: $selectedContent
          )

          NFCNDEFMessageRecordContentView(
            title: "payload",
            contents: NFCNDEFMessageRecordContent.dataContents(from: record.payload),
            selectedContent: $selectedContent
          )

          if let uri = record.wellKnownTypeURIPayload()?.absoluteString {
            NFCNDEFMessageRecordContentView(
              title: "wellKnownTypeURIPayload",
              contents: [
                .init(title: "URI", value: uri, isSelectable: true)
              ],
              selectedContent: $selectedContent
            )
          }

          let textPayload = record.wellKnownTypeTextPayload()
          if textPayload.0 != nil || textPayload.1 != nil {
            NFCNDEFMessageRecordContentView(
              title: "wellKnownTypeTextPayload",
              contents: [
                textPayload.0
                  .flatMap { NFCNDEFMessageRecordContent(title: "text", value: $0, isSelectable: true) },
                textPayload.1
                  .flatMap { NFCNDEFMessageRecordContent(title: "locale", value: $0.description) },
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
        NFCNDEFTextDisplayView(text: content.value ?? "")
          .navigationTitle(content.title)
          .navigationBarTitleDisplayMode(.inline)
      }
      .presentationDetents([.medium, .large])
    }
    .navigationTitle("NFCNDEFMessage")
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
