//
//  PulseLogger.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 11/07/2021.
//  Copyright © 2021 Ahmed Ramy. All rights reserved.
//

import Foundation
import Logging
import OrdiLogging
import Pulse
import PulseUI
import UIKit

// MARK: - PulseLogger

public final class PulseLogger: LogEngine {
  // MARK: Lifecycle


  private init() {
    LoggingSystem.bootstrap(PersistentLogHandler.init)
    logger = Logger(label: Bundle.main.bundleIdentifier ?? "")
  }

  // MARK: Public

  public static let main: PulseLogger = .init()

  public func info(message: String) {
    #if DEBUG
    logger.info(Logger.Message(stringLiteral: message))
    #endif
  }

  public func warn(message: String) {
    #if DEBUG
    logger.warning(Logger.Message(stringLiteral: message))
    #endif
  }

  public func error(message: String) {
    #if DEBUG
    logger.error(Logger.Message(stringLiteral: message))
    #endif
  }

  // MARK: Private

  private let logger: Logger
}

extension UIWindow {
  public static var showPulseUI: () -> Void = { }

  public override func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
    guard motion == .motionShake else { return }
    Self.showPulseUI()
  }
}
