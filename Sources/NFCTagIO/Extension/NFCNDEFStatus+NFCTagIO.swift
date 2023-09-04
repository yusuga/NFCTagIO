//
//  NFCNDEFStatus+NFCTagIO.swift
//
//
//  Created by yusuga on 2023/09/04.
//

import Foundation
import CoreNFC

extension NFCNDEFStatus: CustomStringConvertible {

  public var description: String {
    switch self {
    case .notSupported:
      "notSupported"
    case .readWrite:
      "readWrite"
    case .readOnly:
      "readOnly"
    @unknown default:
      "undefined"
    }
  }
}
