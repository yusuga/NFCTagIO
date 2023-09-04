//
//  LocalizedErrorModel.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import Foundation

public struct LocalizedErrorModel {

  public let underlyingError: LocalizedError

  public init(error: Error) {
    underlyingError = (error as? LocalizedError)
    ?? InternalLocalizedErrorModel(underlyingError: error)
  }
}

extension LocalizedErrorModel: LocalizedError {

  public var errorDescription: String? {
    underlyingError.errorDescription
  }

  public var failureReason: String? {
    underlyingError.failureReason
  }

  public var recoverySuggestion: String? {
    underlyingError.recoverySuggestion
  }

  public var helpAnchor: String? {
    underlyingError.helpAnchor
  }
}

private extension LocalizedErrorModel {

  struct InternalLocalizedErrorModel: LocalizedError {
    let underlyingError: Error
  }
}
