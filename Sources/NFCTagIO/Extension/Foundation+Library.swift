//
//  Foundation+Library.swift
//  
//
//  Created by yusuga on 2023/08/20.
//

import Foundation

public extension Data {

  /// - SeeAlso: https://stackoverflow.com/a/40089462
  var hexString: String {
    map { String(format: "%02hhx", $0) }
      .joined()
  }
}
