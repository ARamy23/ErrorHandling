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
    applePay: ApplePayProtocol = ApplePay(),
    flags: FeatureFlagsProtocol = FeatureFlags())
  {
    self.walletRepository = walletRepository
    self.cardsRepository = cardsRepository
    self.applePay = applePay
    self.flags = flags
  }

  // MARK: Internal

  let walletRepository: WalletRepositoryProtocol
  let cardsRepository: PaymentCardsRepositoryProtocol
  let applePay: ApplePayProtocol
  let flags: FeatureFlagsProtocol

  override func process() async throws -> [PaymentMethod] {
    var methods: [PaymentMethod] = [].appending(elements: try await cardsRepository.fetchCards())

    if flags.wallet {
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
    }

    return methods.appending(applePay, if: flags.applePay)
  }
}
