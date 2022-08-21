//
//  SuccessMessage.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 21/08/2022.
//

import Foundation
import UIKit.UIImage

public struct SuccessMessage {
  var title: String
  var description: String?
  var icon: UIImage?
  var type: PresentationMethod

  init(title: String, description: String? = nil, icon: UIImage? = nil, type: PresentationMethod = .indicator) {
    self.title = title
    self.description = description
    self.icon = icon
    self.type = type
  }
}
