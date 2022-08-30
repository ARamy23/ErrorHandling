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

  func viewDidLoad() {
    Task {
      let response = try await PaymentUsecase().execute()
      state.allMethods = response.map { PaymentMethodUIModel($0) }
      
      state.wallet = response.compactMap {
        guard let wallet = $0 as? Wallet else { return nil }
        return PaymentMethodUIModel(wallet)
      }.first
      
      state.paymentCards = response.compactMap {
        guard let card = $0 as? PaymentCard else { return nil }
        return PaymentMethodUIModel(card)
      }
      
      state.applePay = response.compactMap {
        guard let applePay = $0 as? ApplePayProtocol else { return nil }
        return PaymentMethodUIModel(applePay)
      }.first
    }
  }

  func didSelect(_ method: PaymentMethodUIModel) {
    state.selectedPaymentMethod = method
  }

  func isSelected(_ method: PaymentMethodUIModel) -> Bool {
    state.selectedPaymentMethod?.id == method.id
  }

  func addNewPaymentMethod() { }
  func authorizePurchase() { }
}

extension PaymentViewModel {
  struct State {
    var wallet: PaymentMethodUIModel?
    var paymentCards: [PaymentMethodUIModel] = []
    var applePay: PaymentMethodUIModel?
    var allMethods: [PaymentMethodUIModel] = []
    var selectedPaymentMethod: PaymentMethodUIModel?
    
    var error: PresentationError?
    var message: SuccessMessage?
  }

  struct PaymentMethodUIModel: Identifiable {
    // MARK: Lifecycle

    init(id: UUID, title: String, subtitle: String? = nil, icon: ImageAsset) {
      self.id = id
      self.title = title
      self.subtitle = subtitle
      self.icon = icon
    }

    init(_ method: PaymentMethod) {
      switch method {
      case let card as PaymentCard:
        self = .init(id: card.id, title: card.last4Digits.withPrefix("•••• "), icon: card.type.image)
      case let wallet as Wallet:
        self = .init(id: wallet.id, title: "Wallet", icon: Asset.PayMethods.bitcoin)
      case let applePay as ApplePay:
        self = .init(id: applePay.id, title: "Apple Pay", icon: Asset.PayMethods.applepay)
      default:
        self = .init(id: .init(), title: .empty, icon: Asset.PayMethods.visa)
      }
    }

    // MARK: Internal

    let id: UUID
    let title: String
    let subtitle: String?
    let icon: ImageAsset
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
