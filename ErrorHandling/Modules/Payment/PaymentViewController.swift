//
//  PaymentViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import Combine
import DSKit
import DSKitFakery
import UIKit

// MARK: - PaymentViewController

class PaymentViewController: BaseViewController {
  let viewModel: PaymentViewModel = .init()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Payment"
    viewModel.viewDidLoad()
    update()
    bind()
  }

  func update() {
    show(content: paymentMethodsSection(), addNewPaymentMethodSection())
    showBottom(content: bottomContentSection())
  }
}

extension PaymentViewController {
  // MARK: Internal

  func makeWalletViewModel(from wallet: PaymentViewModel.WalletPaymentMethodUIModel) -> DSViewModel {
    // Title
    let composer = DSTextComposer()
    composer.add(type: .headlineWithSize(15), text: wallet.title)

    if let subtitle = wallet.subtitle {
      composer.add(type: .subheadline, text: subtitle)
    }

    var action = composer.actionViewModel()

    // Switch
    var switchModel = DSSwitchVM(isOn: wallet.isSelected)
    switchModel.didUpdate = { [unowned self] _ in
      self.viewModel.didToggleWallet()
      self.update()
    }

    // Set switch as right side view
    action.rightSideView = DSSideView(view: switchModel)

    let icon = wallet.icon.image
    action.leftImage(image: icon, size: .size(.init(width: 60, height: 36)), contentMode: .scaleAspectFit)

    return action
  }

  func makeApplePayViewModel(from applePay: PaymentViewModel.ApplePayPaymentMethodUIModel) -> DSViewModel {
    // Title
    let composer = DSTextComposer()
    composer.add(type: .headlineWithSize(15), text: applePay.title)

    var action = composer.actionViewModel()
    action.height = .absolute(50)

    let icon = applePay.icon.image
    action.leftImage(image: icon, size: .size(.init(width: 60, height: 36)), contentMode: .scaleAspectFit)

    if let subtitle = applePay.subtitle {
      action.rightSideView = DSSideView(view: DSButtonVM(title: subtitle) { [unowned self] _ in self.viewModel.didTapApplePay() })
    }

    return action
  }

  // MARK: Private

  private func bind() {
    viewModel.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
      guard let self = self else { return }
      self.handle(error: state.error)
      self.handle(success: state.message)
      self.update()
    }.store(in: &cancellables)
  }

  private func paymentMethodsSection() -> DSSection {
    [DSViewModel]()
      .appendingIfNotNil(viewModel.state.wallet.map { makeWalletViewModel(from: $0) })
      .appending(elements: viewModel.state.paymentCards.map { makeCardViewModel(from: $0) })
      .list()
      .headlineHeader("Select your preferred payment method.", size: 16)
  }

  private func makeCardViewModel(from card: PaymentViewModel.PaymentCardMethodUIModel) -> DSViewModel {
    // Text
    let composer = DSTextComposer()
    composer.add(type: .headlineWithSize(15), text: card.title)

    if let subtitle = card.subtitle {
      composer.add(type: .subheadline, text: subtitle)
    }

    // Action
    var action = composer.checkboxActionViewModel(selected: card.isSelected)

    // Icon
    let icon = card.icon.image
    action.leftImage(image: icon, size: .size(.init(width: 60, height: 36)), contentMode: .scaleAspectFit)

    // Handle did tap
    action.didTap { [unowned self] (_: DSActionVM) in
      self.viewModel.didSelect(card)
      self.update()
    }

    return action
  }

  /// Bottom content section
  /// - Returns: DSSection
  private func bottomContentSection() -> DSSection {
    [makeAuthorizePayment()]
      .appendingIfNotNil(makeApplePayMethod())
      .grid(columns: 2)
      .subheadlineHeader("Subject to VAT")
  }

  /// Add new payment method section
  /// - Returns: DSSection
  private func addNewPaymentMethodSection() -> DSSection {
    let icon = DSSFSymbolConfig.buttonIcon("plus.circle")
    let button = DSButtonVM(title: "Add New Payment Method", icon: icon, type: .secondaryView) { [unowned self] _ in
      self.pop()
    }

    return button.list()
  }

  private func makeApplePayMethod() -> DSButtonVM? {
    guard let applePayUIModel = viewModel.state.applePay else { return nil }
    var button = DSButtonVM(title: applePayUIModel.title, icon: Asset.SocialMedia.apple.image) { [unowned self] _ in
      self.viewModel.didTapApplePay()
    }

    button.textAlignment = .right
    button.imagePosition = .leftMargin
    button.customFont = .headlineWithSize(13)

    return button
  }

  private func makeAuthorizePayment() -> DSButtonVM {
    var button = DSButtonVM(title: "Authorize Purchase") { [unowned self] _ in
      self.pop()
    }
    button.textAlignment = .left
    button.imagePosition = .rightMargin

    return button
  }
}

// MARK: - SwiftUI Preview

import SwiftUI

// MARK: - Payment1ViewControllerPreview

struct Payment1ViewControllerPreview: PreviewProvider {
  static var previews: some View {
    Group {
      PreviewContainer(VC: PaymentViewController(), BlackToneAppearance()).edgesIgnoringSafeArea(.all)
    }
  }
}
