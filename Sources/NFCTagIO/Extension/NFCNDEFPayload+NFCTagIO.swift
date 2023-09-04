//
//  NFCNDEFPayload+NFCTagIO.swift
//  
//
//  Created by yusuga on 2023/09/04.
//

import CoreNFC

public extension NFCNDEFPayload {

  func wellKnownNDEFRecordType() throws -> WellKnownNDEFRecordType {
    try .init(data: type)
  }
}
