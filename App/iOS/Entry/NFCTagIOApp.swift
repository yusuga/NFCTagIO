//
//  NFCTagIOApp.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/18.
//

import SwiftUI

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
          NFCNDEFReaderView()
        }
        .tabItem {
          Label("NDEF", systemImage: "tag")
        }
      }
    }
  }
}
