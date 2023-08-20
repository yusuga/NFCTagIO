//
//  File.swift
//  
//
//  Created by yusuga on 2023/08/20.
//

import Foundation

public enum WellKnownNDEFRecordTypeError {

  case invalidDataEncoding
  case unknownRecordType
}

extension WellKnownNDEFRecordTypeError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .invalidDataEncoding:
      "The provided data is in an unsupported format."
    case .unknownRecordType:
      "The provided data does not match any known NDEF record type."
    }
  }
}
