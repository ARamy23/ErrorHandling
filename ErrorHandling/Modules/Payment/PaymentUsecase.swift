//
//  PaymentUsecase.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation
import OrdiLogging
import Utils

final class PaymentUsecase: Usecase<[PaymentMethod]> {
  // MARK: Lifecycle

  init(
    walletRepository: WalletRepositoryProtocol = WalletRepository(),
    cardsRepository: PaymentCardsRepositoryProtocol = PaymentCardsRepository(),
    applePay: ApplePayProtocol = ApplePay())
  {
    self.walletRepository = walletRepository
    self.cardsRepository = cardsRepository
    self.applePay = applePay
  }

  // MARK: Internal

  let walletRepository: WalletRepositoryProtocol
  let cardsRepository: PaymentCardsRepositoryProtocol
  let applePay: ApplePayProtocol

  override func process() async throws -> [PaymentMethod] {
    var methods: [PaymentMethod] = []

    methods.append(contentsOf: try await cardsRepository.fetchCards())

    do {
      methods.append(try await walletRepository.fetchWallet())
    } catch let error as NoWalletFoundError {
      LoggersManager.error(error)
    } catch let error as BannedWalletError {
      LoggersManager.error(error)
    } catch let error as WalletInReviewError {
      LoggersManager.error(error)
    } catch {
      LoggersManager.error(message: "Unhandlable error caught: \(error)")
    }

    methods.append(applePay)

    return methods
  }
}
