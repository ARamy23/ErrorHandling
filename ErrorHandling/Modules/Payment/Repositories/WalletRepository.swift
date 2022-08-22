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
      throw [
        NoWalletFoundError(),
        BannedWalletError(),
        WalletInReviewError(),
      ][Int.random(in: 0...2)]
    }
  }
}

// MARK: - NoWalletFoundError

struct NoWalletFoundError: PaymentMethodRepositoryError { }

// MARK: - BannedWalletError

struct BannedWalletError: PaymentMethodRepositoryError { }

// MARK: - WalletInReviewError

struct WalletInReviewError: PaymentMethodRepositoryError { }
