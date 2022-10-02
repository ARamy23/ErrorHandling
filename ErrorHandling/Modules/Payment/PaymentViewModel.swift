//
//  PaymentViewModel.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - PaymentViewModel

class PaymentViewModel {
  @Published var state: State = .init()

	fileprivate func updateState(_ response: [PaymentMethod]) {
		state.wallet = response.compactMap {
			guard let wallet = $0 as? Wallet else { return nil }
			return WalletPaymentMethodUIModel(wallet)
		}.first

		state.paymentCards = response.compactMap {
			guard let card = $0 as? PaymentCard else { return nil }
			return PaymentCardMethodUIModel(card)
		}

		state.applePay = response.compactMap {
			guard let applePay = $0 as? ApplePayProtocol else { return nil }
			return ApplePayPaymentMethodUIModel(
				applePay,
				applePay.status == .needsSetup ? "Setup Apple Pay" : "Pay with Apple")
		}.first
	}

	func fetchPaymentMethods() {
		Task {
			do {
				updateState(try await PaymentUsecase().execute())
			} catch PaymentUsecaseError.noPaymentMethodsFound {
				state.isEmpty = true
			} catch is UnknownBusinessError {
				state.error = .default
			} catch {
				state.error = .default
			}
		}
	}

  func didTapApplePay() {
    if state.applePay?.needsSetup == true {
      // Show Setup Screen
    } else {
      // Pay with Apple
    }
  }

  func didToggleWallet() {
    state.wallet?.isSelected.toggle()
  }

  func didSelect(_ paymentCard: PaymentCardMethodUIModel) {
    state.paymentCards = state.paymentCards.map {
      var updatedCard = $0
      updatedCard.isSelected = $0.id == paymentCard.id
      return updatedCard
    }
  }

  func addNewPaymentMethod() { }
  func authorizePurchase() { }
}

// MARK: - PaymentMethodUIModel

protocol PaymentMethodUIModel {
  var id: UUID { get }
  var title: String { get }
  var subtitle: String? { get }
  var icon: ImageAsset { get }
  var isSelected: Bool { get set }
}

extension PaymentViewModel {
  struct State {
    var wallet: WalletPaymentMethodUIModel?
    var paymentCards: [PaymentCardMethodUIModel] = []
    var applePay: ApplePayPaymentMethodUIModel?

		var isEmpty: Bool = true

    var error: PresentationError?
    var message: SuccessMessage?
  }

  struct PaymentCardMethodUIModel: PaymentMethodUIModel, Identifiable {
    // MARK: Internal
    let id: UUID
    let title: String
    let subtitle: String?
    let icon: ImageAsset
    var isSelected = false

    // MARK: Lifecycle

    init(id: UUID, title: String, subtitle: String? = nil, icon: ImageAsset) {
      self.id = id
      self.title = title
      self.subtitle = subtitle
      self.icon = icon
    }

    init(_ card: PaymentCard) {
      self = .init(id: card.id, title: card.last4Digits.withPrefix("•••• "), icon: card.type.image)
    }
  }

  struct WalletPaymentMethodUIModel: PaymentMethodUIModel, Identifiable {
    let id: UUID
    let title: String
    let credit: Money
    let subtitle: String?
    let icon: ImageAsset
    var isSelected = false

    init(_ wallet: Wallet) {
      self = .init(id: wallet.id, credit: wallet.balance, icon: Asset.PayMethods.bitcoin)
    }

    init(id: UUID, credit: Money, icon: ImageAsset) {
      self.id = id
      self.title = credit.display()
      self.credit = credit
      self.icon = icon
      subtitle = "Use wallet's credit first"
    }
  }

  struct ApplePayPaymentMethodUIModel: PaymentMethodUIModel, Identifiable {
		let id: UUID
		let title: String
		let subtitle: String?
		let needsSetup: Bool
		let icon: ImageAsset
		var isSelected = false

    init(
      _ applePay: ApplePayProtocol,
      _ title: String)
    {
      self = .init(id: applePay.id, title: title, needsSetup: applePay.status == .needsSetup, icon: Asset.PayMethods.applepay)
    }

    init(id: UUID, title: String, needsSetup: Bool, icon: ImageAsset) {
      self.id = id
      self.title = title
      self.needsSetup = needsSetup
      self.icon = icon
      subtitle = nil
    }
  }
}

extension PaymentCard.CardType {
  var image: ImageAsset {
    switch self {
    case .visa: return Asset.PayMethods.visa
    case .masterCard: return Asset.PayMethods.masterCard
    case .amex: return Asset.PayMethods.americanExpress
    }
  }
}
