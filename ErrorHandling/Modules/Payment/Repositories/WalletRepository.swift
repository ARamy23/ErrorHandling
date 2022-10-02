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
		guard Bool.random() else { throw WalletRepositoryError.noWalletFound }
		return Wallet(balance: .init(value: 425.0))
  }
}

// MARK: - NoWalletFoundError
enum WalletRepositoryError: RepositoryError {
	case noWalletFound
	case banned
	case inReview(_ state: ReviewState)
}

extension WalletRepositoryError {
	enum ReviewState {
		case pending
		case beingProcessed
	}
}
