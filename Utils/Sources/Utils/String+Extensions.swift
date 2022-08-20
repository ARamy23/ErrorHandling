//
//  String+Extensions.swift
//  String+Extensions
//
//  Created by Ahmed Ramy on 23/08/2021.
//

import Foundation

extension String {
  public static let empty = ""

  public var asError: Error {
    NSError(domain: self, code: -1, userInfo: [NSLocalizedDescriptionKey: self])
  }

  public func toURL() -> URL? {
    URL(string: self)
  }

  public func matches(_ regex: String) -> Bool {
    range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
  }
}

extension Optional where Wrapped == String {
  public var emptyIfNil: String {
    self ?? .empty
  }

  public var dotIfNil: String {
    self ?? "."
  }
}

extension Optional where Wrapped == NSAttributedString {
  public var emptyIfNil: NSAttributedString {
    self ?? NSAttributedString(string: .empty)
  }
}

extension String {
  public var trimCardNumber: String {
    replacingOccurrences(of: "*", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
  }

  public var trimPhoneNumber: String {
    replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
      .replacingOccurrences(of: "-", with: "")
      .replacingOccurrences(of: " ", with: "")
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }

  public func replacingOccurrences(with this: [String]) -> String {
    var value = self
    this.forEach { value = value.replacingOccurrences(of: $0, with: "") }
    return value
  }
}

extension Int {
  public func format(as formattingStyle: NumberFormatter.Style) -> String {
    NumberFormatter().then { $0.numberStyle = formattingStyle }.string(from: NSNumber(value: self)) ?? "..."
  }
}
