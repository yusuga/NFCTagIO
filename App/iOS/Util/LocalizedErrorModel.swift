//
//  LocalizedErrorModel.swift
//  NFCTagIOApp
//
//  Created by yusuga on 2023/08/19.
//

import Foundation

struct LocalizedErrorModel {

  let underlyingError: LocalizedError

  init(error: Error) {
    underlyingError = (error as? LocalizedError)
    ?? InternalLocalizedErrorModel(underlyingError: error)
  }
}

extension LocalizedErrorModel: LocalizedError {

  var errorDescription: String? {
    underlyingError.errorDescription
  }

  var failureReason: String? {
    underlyingError.failureReason
  }

  var recoverySuggestion: String? {
    underlyingError.recoverySuggestion
  }

  var helpAnchor: String? {
    underlyingError.helpAnchor
  }
}

private extension LocalizedErrorModel {

  struct InternalLocalizedErrorModel: LocalizedError {
    let underlyingError: Error
  }
}
