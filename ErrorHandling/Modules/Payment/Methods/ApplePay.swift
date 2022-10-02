//
//  ApplePay.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation
import PassKit

// MARK: - ApplePayProtocol

protocol ApplePayProtocol: PaymentMethod {
  var id: UUID { get }
  var status: ApplePay.Status { get }
}

// MARK: - ApplePay

struct ApplePay: ApplePayProtocol {
  let id: UUID = .init()
  let status: Status
}

extension ApplePay {
  enum Status {
    case needsSetup
    case available
  }
}

// MARK: - FakeApplePay

struct FakeApplePay: ApplePayProtocol {
  let id: UUID = .init()

  var status: ApplePay.Status { .needsSetup }

  // NOTE: It would be better to fetch this from a configuration
  let supportedNetworks: [PKPaymentNetwork] = [
    .visa,
    .masterCard,
    .amex,
  ]
}
