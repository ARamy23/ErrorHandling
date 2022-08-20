//
//  ReportPlugin.swift
//  Al-Najd
//
//  Created by Ahmed Ramy on 04/08/2022.
//

import Foundation
import OrdiLogging
import OrdiPulseLogging
import UIKit

// MARK: - ReportPlugin

struct ReportPlugin { }

// MARK: ApplicationPlugin

extension ReportPlugin: ApplicationPlugin {
  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    setup()
    return true
  }
}

extension ReportPlugin {
  private func setup() {
    LoggersManager.engines.append(PulseLogger.main)
    LoggersManager.info(message: "Loggers woke up!")
  }
}
