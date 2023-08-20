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
  public var messages = [NFCNDEFMessage]()
  public var error: Error?

  @ObservationIgnored private var alertMessage: SessionAlertMessage?
  @ObservationIgnored private var session: NFCNDEFReaderSession?
}

public extension NFCNDEFReader {

  func beginScanning(
    alertMessage: SessionAlertMessage? = nil,
    queue: dispatch_queue_t? = nil,
    invalidateAfterFirstRead: Bool = true
  ) throws {
    clear()

    guard NFCNDEFReaderSession.readingAvailable else {
      throw NFCTagIOError.nfcTagReadingNotSupported
    }

    let session = NFCNDEFReaderSession(
      delegate: self,
      queue: queue,
      invalidateAfterFirstRead: invalidateAfterFirstRead
    )
    if let scanning = alertMessage?.scanning {
      session.alertMessage = scanning
    }

    guard !session.isReady else {
      throw NFCTagIOError.nfcReaderSessionAlreadyStarted
    }

    session.begin()

    self.session = session
    self.isScanning = true
  }

  func clear() {
    messages.removeAll()
    error = nil
  }
}

extension NFCNDEFReader: NFCNDEFReaderSessionDelegate {

  public func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    logger.trace(#function)
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    logger.trace("\(#function), \(messages.description)")

    self.messages.insert(contentsOf: messages, at: 0)

    if let success = alertMessage?.success {
      session.alertMessage = success
    }
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    logger.trace("\(#function), \(error), \(Thread.isMainThread)")

    if let failure = alertMessage?.failure {
      session.alertMessage = failure
    }

    isScanning = false
    self.error = error
  }
}
