//
//  LogEngine.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 23/10/2021.
//

import Foundation

// MARK: - LogEngine

public protocol LogEngine {
  func info(message: String)
  func warn(message: String)
  func error(message: String)
}

// MARK: - LogTag

public enum LogTag: String {
  case `internal` = "[Internal]"
  case facebook = "[Facebook]"
  case parsing = "[Parsing]"
  case google = "[Google]"
  case authentication = "[Authentication]"
  case firebase = "[Firebase]"
  case cache = "[Cache]"
  case network = "[Network]"
  case download = "[Download]"
}

extension Array where Element == LogEngine {
  public static var local: [Element] = [SystemLogger.main]
  public static var remote: [Element] = []

  public static var all: [Element] { local + remote }
}
