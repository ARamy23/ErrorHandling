//
//  PaymentCardsRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - PaymentCardsRepositoryProtocol

protocol PaymentCardsRepositoryProtocol {
  func fetchCards() async throws -> String
}

// MARK: - PaymentCardsRepository

class PaymentCardsRepository: PaymentCardsRepositoryProtocol {
  func fetchCards() async throws -> String {
    "Cardzzz"
  }
}
