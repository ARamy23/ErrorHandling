//
//  WalletRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

protocol WalletRepositoryProtocol {
  func fetchWallet() async throws -> String
}
