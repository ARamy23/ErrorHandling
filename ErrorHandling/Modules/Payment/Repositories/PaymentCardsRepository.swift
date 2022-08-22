//
//  PaymentCardsRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - PaymentCardsRepositoryProtocol

protocol PaymentCardsRepositoryProtocol {
  func fetchCards() async throws -> [PaymentCard]
}

// MARK: - PaymentCardsRepository

class PaymentCardsRepository: PaymentCardsRepositoryProtocol {
  func fetchCards() async throws -> [PaymentCard] {
    [
      .init(last4Digits: "4242", expiryDate: "01/25", holderName: "John Doe", type: .visa),
      .init(last4Digits: "1234", expiryDate: "02/24", holderName: "Doe John", type: .amex),
      .init(last4Digits: "9876", expiryDate: "03/23", holderName: "Some Doe", type: .masterCard),
    ]
  }
}
