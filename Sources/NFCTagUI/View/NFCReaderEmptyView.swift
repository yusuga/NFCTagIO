//
//  NFCReaderEmptyView.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/21.
//

import SwiftUI

public struct NFCReaderEmptyView: View {

  public let isScanning: Bool
  
  public init(isScanning: Bool) {
    self.isScanning = isScanning
  }

  public var body: some View {
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

private struct ContentView: View {

  @State var isScanning = false

  var body: some View {
    NavigationStack {
      List {
        EmptyView()
      }
      .overlay {
        NFCReaderEmptyView(isScanning: isScanning)
      }
      .toolbar {
        ToolbarItem(placement: .automatic) {
          Toggle(isOn: $isScanning) {
            Text("isScanning")
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
