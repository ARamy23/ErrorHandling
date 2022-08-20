//
//  AppDelegate.swift
//  Al-Najd
//
//  Created by Ahmed Ramy on 02/08/2022.
//

import UIKit

@main
class AppDelegate: ApplicationPluggableDelegate {
  override func plugins() -> [ApplicationPlugin] {
    [
      ReportPlugin(),
      AppearancePlugin(),
    ]
  }
}
