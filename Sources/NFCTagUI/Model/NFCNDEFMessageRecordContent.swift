//
//  NFCNDEFMessageRecordContent.swift
//
//
//  Created by yusuga on 2023/09/09.
//

import Foundation

public struct NFCNDEFMessageRecordContent {

  public let title: String
  public let value: String?
  public var isSelectable = false

  public static func dataContents(from data: Data) -> [Self] {
    [
      .init(title: "bytes", value: ByteCountFormatter.default.string(fromByteCount: Int64(data.count))),
      .init(title: "utf8", value: String(data: data, encoding: .utf8), isSelectable: true),
      .init(title: "hex", value: data.hexString, isSelectable: true),
    ]
  }
}

extension NFCNDEFMessageRecordContent: Identifiable {

  public var id: String { title }
}
