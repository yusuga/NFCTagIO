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

  @ObservationIgnored private var internalState: InternalState?
}

public extension NFCTagReader {
  
  class InternalState {
    let session: NFCNDEFReaderSession
    let scanningMode: ScanningMode
    let alertMessage: NFCNDEFReaderSessionAlertMessage?
    let onConnectionError: ((Error) async -> ConnectionErrorResponsePolicy)
    var connectionTask: Task<Void, Never>?
    
    init(
      session: NFCNDEFReaderSession,
      scanningMode: ScanningMode,
      alertMessage: NFCNDEFReaderSessionAlertMessage?,
      onConnectionError: @escaping (Error) -> ConnectionErrorResponsePolicy
    ) {
      self.session = session
      self.scanningMode = scanningMode
      self.alertMessage = alertMessage
      self.onConnectionError = onConnectionError
    }
    
    deinit {
      connectionTask?.cancel()
    }
  }
  
  enum ScanningMode {
    case read
    case write(message: () async throws -> NFCNDEFMessage)
  }
  
  enum ConnectionErrorResponsePolicy {
    case restartPolling
    case invalidate(errorMessage: String?)
  }
  
  func beginScanning(
    mode scanningMode: ScanningMode,
    alertMessage: NFCNDEFReaderSessionAlertMessage? = nil,
    queue: dispatch_queue_t? = nil,
    onConnectionError: @escaping ((Error) -> ConnectionErrorResponsePolicy) = { _ in .restartPolling }
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

    isScanning = true
    
    internalState = .init(
      session: session,
      scanningMode: scanningMode,
      alertMessage: alertMessage,
      onConnectionError: onConnectionError
    )
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

    internalState?.connectionTask = Task {
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
          switch internalState?.scanningMode {
          case .read:
            let message = try await tag.readNDEF()

            logger.debug("message: \(message)")
            scannedMessage = message

            if let success = internalState?.alertMessage?.success {
              session.alertMessage = success
            }

            session.invalidate()
          case let .write(message):
            let message = try await message()
            logger.debug("message: \(message)")
            
            try await tag.writeNDEF(message)
            
            if let success = internalState?.alertMessage?.success {
              session.alertMessage = success
            }

            session.invalidate()
          case .none:
            session.invalidate(errorMessage: "Unexpected flow. scanningMode is nil.")
          }
        @unknown default:
          throw NFCTagIOError.unknownNFCNDEFStatus(rawValue: status.rawValue)
        }
      } catch {
        logger.error("\(#function), error: \(error)")
        
        switch await internalState?.onConnectionError(error) {
        case .restartPolling, .none:
          session.restartPolling()
        case let .invalidate(errorMessage):
          session.invalidate(errorMessage: errorMessage ?? "")
        }
      }
    }
  }

  public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    logger.trace("\(#function), \(error)")

    if let failure = internalState?.alertMessage?.failure {
      session.alertMessage = failure
    }

    internalState = nil
    isScanning = false
    self.error = error
  }
}
