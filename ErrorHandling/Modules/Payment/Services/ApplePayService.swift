//
//  ApplePayService.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 26/09/2022.
//

import Foundation
import PassKit

protocol ApplePayServiceProtocol {
	func fetchApplePay() throws -> ApplePayProtocol
}

struct ApplePayService: ApplePayServiceProtocol {
	// NOTE: It would be better to fetch this from a configuration
	let supportedNetworks: [PKPaymentNetwork] = [
		.visa,
		.masterCard,
		.amex,
	]

	func fetchApplePay() throws -> ApplePayProtocol {
		guard PKPaymentAuthorizationController.canMakePayments() else { throw ApplePayError.serviceNotAvailable }
		let isItSetup = PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
		return ApplePay(status: isItSetup ? .needsSetup : .available)
	}
}

enum ApplePayError: Error {
	case serviceNotAvailable
}
