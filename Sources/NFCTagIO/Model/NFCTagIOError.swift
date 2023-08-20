//
//  NFCTagIOError.swift
//
//
//  Created by yusuga on 2023/08/19.
//

import Foundation

public enum NFCTagIOError {

  case nfcTagReadingNotSupported
  case nfcReaderSessionAlreadyStarted
  case nfcTagsEmpty
  case unknownNFCNDEFStatus(rawValue: UInt)
}

extension NFCTagIOError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .nfcTagReadingNotSupported:
      "This device doesn't support reading NFC tags."
    case .nfcReaderSessionAlreadyStarted:
      "NFC scanning has already started."
    case .nfcTagsEmpty:
      "No NFC tags were detected."
    case let .unknownNFCNDEFStatus(rawValue):
      "An unknown NFC NDEF status occurred with raw value: \(rawValue)."
    }
  }
}
