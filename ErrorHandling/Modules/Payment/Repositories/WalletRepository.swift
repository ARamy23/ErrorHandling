//
//  WalletRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - WalletRepositoryProtocol

protocol WalletRepositoryProtocol {
  func fetchWallet() async throws -> String
}

// MARK: - WalletRepository

class WalletRepository: WalletRepositoryProtocol {
  func fetchWallet() async throws -> String {
    if Bool.random() { return "Found your wallet" } else { throw NoWalletFoundError() }
  }
}

// MARK: - NoWalletFoundError

struct NoWalletFoundError: PaymentMethodRepositoryError { }
