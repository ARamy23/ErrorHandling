//
//  LoggersManager.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 23/10/2021.
//

import Foundation

// MARK: - LoggersManager

public enum LoggersManager {
  public static var engines: [LogEngine] = [
    SystemLogger.main,
  ]

  public static func info(message: String) {
    engines.forEach { $0.info(message: message) }
  }

  public static func warn(message: String) {
    engines.forEach { $0.warn(message: message) }
  }

  public static func error(message: String) {
    engines.forEach { $0.error(message: message) }
  }

  public static func info(_ error: Error) {
    engines.forEach { $0.info(message: "\(error)") }
  }

  public static func warn(_ error: Error) {
    engines.forEach { $0.warn(message: "\(error)") }
  }

  public static func error(_ error: Error) {
    engines.forEach { $0.error(message: "\(error)") }
  }
}

extension String {
  public func tagWith(_ tag: LogTag) -> String {
    withPrefix("\(tag.rawValue) ")
  }

  public func tagWith(_ tags: [LogTag]) -> String {
    tags.map { "[\($0.rawValue)]" }.joined(separator: "").withPrefix(" \(self)")
  }

  public func withPrefix(_ prefix: String) -> String {
    "\(prefix)\(self)"
  }

  public func withSuffix(_ suffix: String) -> String {
    "\(self)\(suffix)"
  }
}
