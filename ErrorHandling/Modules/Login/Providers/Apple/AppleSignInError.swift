//
//  AppleSignInError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 21/08/2022.
//

import Foundation
import UIKit.UIImage

public struct AppleSignInError {
  public let title: String
  public let description: String?

  public init(title: String, description: String? = nil) {
    self.title = title
    self.description = description
  }
}
