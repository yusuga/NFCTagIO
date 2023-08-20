//
//  ByteCountFormatter+App.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/20.
//

import Foundation

extension ByteCountFormatter {

  static var `default`: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = .useBytes
    formatter.countStyle = .file
    return formatter
  }()
}
