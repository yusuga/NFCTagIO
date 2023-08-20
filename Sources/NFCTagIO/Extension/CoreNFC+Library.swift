//
//  CoreNFC+Library.swift
//
//
//  Created by yusuga on 2023/08/20.
//

import CoreNFC

public extension NFCNDEFPayload {

  func wellKnownNDEFRecordType() throws -> WellKnownNDEFRecordType {
    try .init(data: type)
  }
}

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
      "unknown default"
    }
  }
}
