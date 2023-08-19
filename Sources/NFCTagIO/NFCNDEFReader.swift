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

  public private(set) var messages = [NFCNDEFMessage]()
  public private(set) var error: NFCReaderError?
  public private(set) var unknownError: Error?

  @ObservationIgnored private var session: NFCNDEFReaderSession?
}

public extension NFCNDEFReader {

  func beginScanning(
    queue: dispatch_queue_t? = nil,
    invalidateAfterFirstRead: Bool = true
  ) {
    clearErrors()

    let session = NFCNDEFReaderSession(
      delegate: self,
      queue: queue,
      invalidateAfterFirstRead: invalidateAfterFirstRead
    )
    session.begin()

    self.session = session
  }

  func clearMessages() {
    messages.removeAll()
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

    switch error {
    case let error as NFCReaderError:
      self.error = error
    default:
      self.unknownError = error
    }
  }
}
