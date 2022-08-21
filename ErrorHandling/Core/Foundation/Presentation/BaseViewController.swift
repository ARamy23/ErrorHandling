//
//  BaseViewController.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import DSKit
import Foundation
import SPIndicator
import UIKit

open class BaseViewController: DSViewController {
  open func handle(error: PresentationError?) {
    guard let error = error else { return }
    switch error.type {
    case .indicator:
      SPIndicator.present(title: error.title, message: error.description, preset: .error, haptic: .error, from: .top)
    }
  }

  open func handle(success: SuccessMessage?) {
    guard let success = success else { return }
    SPIndicator.present(title: success.title, message: success.description, preset: .done, haptic: .success, from: .bottom)
  }
}
