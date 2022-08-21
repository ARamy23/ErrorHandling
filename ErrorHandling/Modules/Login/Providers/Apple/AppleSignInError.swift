//
//  AppleSignInError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 21/08/2022.
//

import Foundation
import UIKit.UIImage

public struct AppleSignInError: PresentationError {
  public let title: String
  public let description: String?
  public let type: PresentationMethod
  public let icon: UIImage?

  public init(title: String, description: String? = nil, type: PresentationMethod = .indicator, icon: UIImage? = nil) {
    self.title = title
    self.description = description
    self.type = type
    self.icon = icon
  }
}
