//
//  NFCTagReader.swift
//
//
//  Created by yusuga on 2023/08/19.
//

import CoreNFC
import Observation

@Observable
open class NFCTagReader: NSObject {

  public private(set) var isScanning = false
  public var scannedMessage: NFCNDEFMessage?
  public var error: Error?

  @ObservationIgnored private var alertMessage: NFCNDEFReaderSessionAlertMessage?
  @ObservationIgnored private var connectionTask: Task<Void, Never>?
  @ObservationIgnored private var session: NFCNDEFReaderSession?
}

public extension NFCTagReader {

  func beginScanning(
    alertMessage: NFCNDEFReaderSessionAlertMessage? = nil,
    queue: dispatch_queue_t? = nil
  ) throws {
    error = nil

    guard NFCNDEFReaderSession.readingAvailable else {
      throw NFCTagIOError.nfcTagReadingNotSupported
    }

    let session = NFCNDEFReaderSession(
      delegate: self,
      queue: queue,
      invalidateAfterFirstRead: false
    )
    if let scanning = alertMessage?.scanning {
      session.alertMessage = scanning
    }

    guard !session.isReady else {
      throw NFCTagIOError.nfcReaderSessionAlreadyStarted
    }

    session.begin()

    self.session = session
    self.alertMessage = alertMessage
    self.isScanning = true
  }
}

extension NFCTagReader: NFCNDEFReaderSessionDelegate {

  public func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    logger.trace(#function)
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    assertionFailure("The reader session doesn’t call this method when the delegate provides the readerSession(_:didDetect:) method.")
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
    logger.trace("\(#function), \(tags.description)")

    connectionTask = Task {
      do {
        guard let tag = tags.first else {
          throw NFCTagIOError.nfcTagsEmpty
        }

        try await session.connect(to: tag)
        let (status, capacity) = try await tag.queryNDEFStatus()

        logger.info("status: \(status), capacity: \(capacity)")

        switch status {
        case .notSupported:
          session.invalidate(errorMessage: "Tag is not supported.")
        case .readWrite, .readOnly:
          let message = try await tag.readNDEF()

          logger.debug("message: \(message)")
          scannedMessage = message

          if let success = alertMessage?.success {
            session.alertMessage = success
          }

          session.invalidate()
        @unknown default:
          throw NFCTagIOError.unknownNFCNDEFStatus(rawValue: status.rawValue)
        }
      } catch {
        logger.error("\(#function), error: \(error)")
        session.restartPolling()
      }
    }
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    logger.trace("\(#function), \(error)")

    if let failure = alertMessage?.failure {
      session.alertMessage = failure
    }

    connectionTask?.cancel()
    isScanning = false
    self.error = error
  }
}
