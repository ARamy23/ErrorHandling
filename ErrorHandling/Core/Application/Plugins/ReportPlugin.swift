//
//  ReportPlugin.swift
//  Al-Najd
//
//  Created by Ahmed Ramy on 04/08/2022.
//

import Foundation
import OrdiLogging
import UIKit
import OrdiPulseLogging

struct ReportPlugin { }

extension ReportPlugin: ApplicationPlugin {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    setup()
    return true
  }
}

private extension ReportPlugin {
  func setup() {
    LoggersManager.engines.append(PulseLogger.main)
    LoggersManager.info(message: "Loggers woke up!")
  }
}
