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
    Wallet(balance: .init(value: 425.0))
  }
}

// MARK: - NoWalletFoundError
extension RepositoryError {
  static let noWalletFound: RepositoryError = .init()
  static let bannedWallet: RepositoryError = .init()
  static let walletInReview: RepositoryError = .init()
}
