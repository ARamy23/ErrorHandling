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
  private func bind() {
    viewModel.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
      guard let self = self else { return }
      self.handle(error: state.error)
      self.handle(success: state.message)
      self.update()
    }.store(in: &cancellables)
  }

  private func paymentMethodsSection() -> DSSection {
    viewModel
      .state
      .paymentMethods.map { paymentMethod($0) }
      .list()
      .headlineHeader("Select your preferred payment method.", size: 16)
  }

  private func paymentMethod(_ method: PaymentViewModel.PaymentMethodUIModel) -> DSViewModel {
    // Text
    let composer = DSTextComposer()
    composer.add(type: .headlineWithSize(15), text: method.title)

    if let subtitle = method.subtitle {
      composer.add(type: .subheadline, text: subtitle)
    }

    // Action
    var action = composer.checkboxActionViewModel(selected: viewModel.isSelected(method))

    // Icon
    let icon = method.icon.image
    action.leftImage(image: icon, size: .size(.init(width: 60, height: 36)), contentMode: .scaleAspectFit)

    // Handle did tap
    action.didTap { [unowned self] (_: DSActionVM) in
      self.viewModel.didSelect(method)
      self.update()
    }

    return action
  }

  /// Bottom content section
  /// - Returns: DSSection
  private func bottomContentSection() -> DSSection {
    let icon = DSSFSymbolConfig.buttonIcon("arrow.right")
    var button = DSButtonVM(title: "Authorize Purchase", icon: icon) { [unowned self] _ in
      self.pop()
    }
    button.textAlignment = .left
    button.imagePosition = .rightMargin

    let section = button.list().subheadlineHeader("Subject to VAT")
    return section
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
