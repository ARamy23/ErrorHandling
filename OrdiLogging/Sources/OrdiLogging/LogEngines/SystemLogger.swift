//
//  SystemLogger.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 23/10/2021.
//

import Foundation

public final class SystemLogger: LogEngine {
  // MARK: Lifecycle

  private init() { }

  // MARK: Public

  public static let main: SystemLogger = .init()

  public func info(message: String) {
    #if DEBUG
    print(message.withPrefix("ℹ️ "))
    #endif
  }

  public func warn(message: String) {
    #if DEBUG
    print(message.withPrefix("⚠️ "))
    #endif
  }

  public func error(message: String) {
    #if DEBUG
    print(message.withPrefix("🚨 "))
    #endif
  }
}
