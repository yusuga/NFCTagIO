//
//  NFCTagIOApp.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/18.
//

import SwiftUI
import NFCTagUI

@main
struct NFCTagIOApp: App {

  var body: some Scene {
    WindowGroup {
      TabView {
        NavigationStack {
          NFCTagReaderView()
        }
        .tabItem {
          Label("NFCTag", systemImage: "sensor.tag.radiowaves.forward.fill")
        }

        NavigationStack {
          NFCNDEFReaderView(isSingleScan: true)
        }
        .tabItem {
          Label("NDEF", systemImage: "tag")
        }
      }
    }
  }
}
