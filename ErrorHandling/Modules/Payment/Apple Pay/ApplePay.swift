//
//  ApplePay.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation
import PassKit

// MARK: - ApplePayProtocol

protocol ApplePayProtocol {
  var status: ApplePay.Status { get }
}

// MARK: - ApplePay

struct ApplePay: ApplePayProtocol {
  private(set) var status: Status {
    .unavailable
  }
}

extension ApplePay {
  enum Status {
    case unavailable
    case needsSetup
    case available

    var isUsable: Bool { self != .unavailable }
  }
}
