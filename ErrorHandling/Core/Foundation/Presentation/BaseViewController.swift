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
}
