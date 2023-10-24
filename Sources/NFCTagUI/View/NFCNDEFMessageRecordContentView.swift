//
//  NFCNDEFMessageRecordContentView.swift
//
//
//  Created by yusuga on 2023/09/09.
//

import SwiftUI

public struct NFCNDEFMessageRecordContentView: View {

  private let title: String
  private let contents: [NFCNDEFMessageRecordContent]
  @Binding private var selectedContent: NFCNDEFMessageRecordContent?

  public init(
    title: String,
    contents: [NFCNDEFMessageRecordContent],
    selectedContent: Binding<NFCNDEFMessageRecordContent?>
  ) {
    self.title = title
    self.contents = contents
    _selectedContent = selectedContent
  }

  public var body: some View {
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

private struct ContentView: View {

  @State var selectedContent: NFCNDEFMessageRecordContent?

  var body: some View {
    List {
      Section {
        NFCNDEFMessageRecordContentView(
          title: "TITLE 1",
          contents: [
            .init(
              title: "Sub 1",
              value: "Value 1",
              isSelectable: true
            ),
            .init(
              title: "Sub 2",
              value: "Value 2",
              isSelectable: true
            ),
            .init(
              title: "Sub 3",
              value: "isSelectable: false",
              isSelectable: false
            ),
          ],
          selectedContent: $selectedContent
        )
      }

      Section {
        LabeledContent("selectfedContent", value: selectedContent?.value ?? "nil")
      }
    }
  }
}

#Preview {
  ContentView()
}
