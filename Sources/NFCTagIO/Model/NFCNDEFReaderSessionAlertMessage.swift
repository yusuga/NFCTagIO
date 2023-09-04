//
//  NFCNDEFReaderSessionAlertMessage.swift
//
//
//  Created by yusuga on 2023/08/20.
//

import Foundation

public struct NFCNDEFReaderSessionAlertMessage {

  let scanning: String?
  let success: String?
  let failure: String?
}

public extension NFCNDEFReaderSessionAlertMessage {

  static var `default`: Self {
    .init(
      scanning: "Please bring the device close to the tag.",
      success: "Tag read successfully!",
      failure: "Failed to read tag. Please try again."
    )
  }
}
