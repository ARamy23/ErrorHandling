//
//  PulseLogger.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 11/07/2021.
//  Copyright © 2021 Ahmed Ramy. All rights reserved.
//

import Pulse
import PulseUI
import Logging
import Foundation
import OrdiLogging
import UIKit
import PulseUI

public final class PulseLogger: LogEngine {
    public static let main: PulseLogger = .init()

    private let logger: Logger
    
    private init() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
        logger = Logger(label: Bundle.main.bundleIdentifier ?? "")
    }

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
}

public extension UIWindow {
    static var showPulseUI: () -> Void = { }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        Self.showPulseUI()
    }
}
