//
//  NFCTypeNameFormat+NFCTagIO.swift
//
//
//  Created by yusuga on 2023/08/20.
//

import CoreNFC

extension NFCTypeNameFormat: CustomStringConvertible {

  public var description: String {
    switch self {
    case .empty:
      "empty"
    case .nfcWellKnown:
      "nfcWellKnown"
    case .media:
      "media"
    case .absoluteURI:
      "absoluteURI"
    case .nfcExternal:
      "nfcExternal"
    case .unknown:
      "unknown"
    case .unchanged:
      "unchanged"
    @unknown default:
      "undefined"
    }
  }
}
