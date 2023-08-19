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
      NavigationStack {
        NFCNDEFReaderView()
      }
    }
  }
}
