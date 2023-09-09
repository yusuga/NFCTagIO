//
//  NFCNDEFTextDisplayView.swift
//
//
//  Created by yusuga on 2023/09/09.
//

import SwiftUI

public struct NFCNDEFTextDisplayView: View {

  private let text: String
  @Environment(\.dismiss) private var dismiss

  public init(text: String) {
    self.text = text
  }

  public var body: some View {
    ScrollView {
      Text(text)
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

private struct ContentView: View {

  @State var selectedText: String?

  var body: some View {
    List {
      Button("Short text") {
        selectedText = "Short text."
      }
      Button("Long text") {
        selectedText = Array(repeating: "Long text", count: 300).joined(separator: " ")
      }
    }
    .sheet(
      isPresented: .constant(selectedText != nil),
      onDismiss: {
        selectedText = nil
      },
      content: {
        NFCNDEFTextDisplayView(text: selectedText ?? "")
      }
    )
  }
}

#Preview {
  ContentView()
}
