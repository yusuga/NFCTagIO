//
//  NFCNDEFMessage+NFCTagUI.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/20.
//

import CoreNFC

extension NFCNDEFMessage {

  var formattedLength: String {
    ByteCountFormatter.default
      .string(fromByteCount: Int64(length))
  }
}
