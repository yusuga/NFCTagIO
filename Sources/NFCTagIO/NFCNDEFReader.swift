//
//  NFCNDEFReader.swift
//
//
//  Created by yusuga on 2023/08/18.
//

import CoreNFC
import Observation

@Observable
open class NFCNDEFReader: NSObject {

  public private(set) var isScanning = false
  public private(set) var messages = [NFCNDEFMessage]()
  public private(set) var error: NFCReaderError?
  public private(set) var unknownError: Error?

  @ObservationIgnored private var session: NFCNDEFReaderSession?
}

public extension NFCNDEFReader {

  func beginScanning(
    alertMessage: String? = nil,
    queue: dispatch_queue_t? = nil,
    invalidateAfterFirstRead: Bool = true
  ) throws {
    clearErrors()

    guard NFCNDEFReaderSession.readingAvailable else {
      throw NFCTagIOError.nfcTagReadingNotSupported
    }

    let session = NFCNDEFReaderSession(
      delegate: self,
      queue: queue,
      invalidateAfterFirstRead: invalidateAfterFirstRead
    )
    if let alertMessage {
      session.alertMessage = alertMessage
    }

    guard !session.isReady else {
      throw NFCTagIOError.nfcReaderSessionAlreadyStarted
    }

    session.begin()

    self.session = session
    self.isScanning = true
  }

  func clearMessages() {
    messages.removeAll()
  }

  var hasError: Bool {
    error != nil || unknownError != nil
  }

  func clearErrors() {
    error = nil
    unknownError = nil
  }
}

extension NFCNDEFReader: NFCNDEFReaderSessionDelegate {

  public func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    logger.trace(#function)
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    logger.trace("\(#function), \(messages.description)")

    self.messages.insert(contentsOf: messages, at: 0)
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    logger.trace("\(#function), \(error)")

    isScanning = false

    switch error {
    case let error as NFCReaderError:
      self.error = error
    default:
      self.unknownError = error
    }
  }
}
