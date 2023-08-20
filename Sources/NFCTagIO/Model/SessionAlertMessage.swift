//
//  SessionAlertMessage.swift
//
//
//  Created by yusuga on 2023/08/20.
//

import Foundation

public struct SessionAlertMessage {

  let scanning: String?
  let success: String?
  let failure: String?
}

public extension SessionAlertMessage {

  static var `default`: Self {
    .init(
      scanning: "Please bring the device close to the tag.",
      success: "Tag read successfully!",
      failure: "Failed to read tag. Please try again."
    )
  }
}
