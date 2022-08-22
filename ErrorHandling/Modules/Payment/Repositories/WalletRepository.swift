//
//  WalletRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - WalletRepositoryProtocol

protocol WalletRepositoryProtocol {
  func fetchWallet() async throws -> Wallet
}

// MARK: - WalletRepository

class WalletRepository: WalletRepositoryProtocol {
  func fetchWallet() async throws -> Wallet {
    if Bool.random() {
      return Wallet(balance: .init(value: Bool.random() ? 425.0 : 0.0))
    } else {
      throw NoWalletFoundError()
    }
  }
}

// MARK: - NoWalletFoundError

struct NoWalletFoundError: PaymentMethodRepositoryError { }
