//
//  NFCNDEFScanView.swift
//  
//
//  Created by yusuga on 2023/09/09.
//

import SwiftUI

public struct NFCNDEFScanView: View {

  @Binding private var isSingleScan: Bool
  private let scanAction: () -> Void

  public init(isSingleScan: Binding<Bool>, scanAction: @escaping () -> Void) {
    _isSingleScan = isSingleScan
    self.scanAction = scanAction
  }

  public var body: some View {
    VStack(spacing: 16) {
      HStack {
        VStack(spacing: 2) {
          Toggle(
            "",
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

private struct ContentView: View {

  @State var isSingleScan = true

  var body: some View {
    NFCNDEFScanView(
      isSingleScan: $isSingleScan,
      scanAction: {}
    )
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  ContentView()
}
