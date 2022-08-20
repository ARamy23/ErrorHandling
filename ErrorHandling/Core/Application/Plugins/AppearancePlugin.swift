//
//  AppearancePlugin.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import DSKit
import UIKit

// MARK: - AppearancePlugin

struct AppearancePlugin { }

// MARK: ApplicationPlugin

extension AppearancePlugin: ApplicationPlugin {
  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setup()
    return true
  }
}

extension AppearancePlugin {
  private func setup() {
    DSAppearance.shared.main = BlackToneAppearance()
    DSAppearance.shared.userInterfaceStyle = .unspecified
  }
}
