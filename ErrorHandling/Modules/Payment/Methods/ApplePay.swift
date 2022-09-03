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
  var supportedNetworks: [PKPaymentNetwork] { get }
}

// MARK: - ApplePay

struct ApplePay: ApplePayProtocol {
  let id: UUID = .init()

  var status: Status {
    let isServiceAvailable = PKPaymentAuthorizationController.canMakePayments()
    let isItSetup = PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)

    return isServiceAvailable ? (isItSetup ? .available : .needsSetup) : .unavailable
  }

  // NOTE: It would be better to fetch this from a configuration
  let supportedNetworks: [PKPaymentNetwork] = [
    .visa,
    .masterCard,
    .amex,
  ]
}

extension ApplePay {
  enum Status {
    case unavailable
    case needsSetup
    case available

    var isUsable: Bool { self != .unavailable }
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
