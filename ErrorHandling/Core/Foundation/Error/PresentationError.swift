//
//  PresentationError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import Foundation
import UIKit.UIImage

// MARK: - PresentationError

public protocol PresentationError: BaseError {
  var title: String { get }
  var description: String? { get }
  var icon: UIImage? { get }
  var type: PresentationMethod { get }
}

// MARK: - PresentationMethod

public enum PresentationMethod {
  case indicator
}
