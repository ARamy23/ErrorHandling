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

  fileprivate func addWalletIfPossible(_ methods: inout [PaymentMethod]) async {
    if flags.wallet {
      do {
        methods.append(try await walletRepository.fetchWallet())
      } catch let error as NetworkError {
        LoggersManager.error(error)
      } catch {
        LoggersManager.error(message: "Unknown error caught: \(error)")
      }
    }
  }
  
  override func process() async throws -> [PaymentMethod] {
    var methods: [PaymentMethod] = []
    
    await addWalletIfPossible(to: &methods)
    await addPaymentCardsIfPossible(to: &methods)
    await addApplePayIfPossible(to: &methods)
    
    return methods
  }
}

private extension PaymentUsecase {
    func addApplePayIfPossible(to methods: inout [PaymentMethod]) async {
      guard flags.applePay && applePay.status.isUsable else { return }
      methods.append(applePay)
    }
    
    func addPaymentCardsIfPossible(to methods: inout [PaymentMethod]) async {
        do {
          methods.append(contentsOf: try await cardsRepository.fetchCards())
        } catch {
            LoggersManager.error(message: "\(error)")
        }
    }
    
    func addWalletIfPossible(to methods: inout [PaymentMethod]) async {
      guard flags.wallet else { return }
      do {
        let wallet = try await walletRepository.fetchWallet()
        if wallet.balance.value != 0 {
          methods.append(wallet)
        } else {
          LoggersManager.info(message: "Wallet was found empty, so wasn't added to payment options")
        }
      } catch {
        LoggersManager.error(message: "\(error)")
      }
    }
}
