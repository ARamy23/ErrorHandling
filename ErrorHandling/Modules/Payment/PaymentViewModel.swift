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

  func viewDidLoad() { }

  func didSelect(_: PaymentMethodUIModel) { }
  func addNewPaymentMethod() { }
  func authorizePurchase() { }
}

extension PaymentViewModel {
  struct State {
    var paymentMethods: [PaymentMethodUIModel] = []
    var error: PresentationError?
    var message: SuccessMessage?
  }

  struct PaymentMethodUIModel: Identifiable {
    let id: UUID = .init()
    let title: String
    let subtitle: String?
    let icon: ImageAsset
    let isSelected: Bool
  }
}
