//
//  SceneDelegate.swift
//  Al-Najd
//
//  Created by Ahmed Ramy on 02/08/2022.
//

import UIKit

class SceneDelegate: ScenePluggableDelegate { }

extension SceneDelegate {
  override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    guard let scene = scene as? UIWindowScene else { return }
    // Build and assign main window
    window = UIWindow(windowScene: scene)
    defer { window?.makeKeyAndVisible() }
    set(
      rootViewTo: ItemDetailsViewController()
    )
  }
}

// MARK: - Helpers
private extension SceneDelegate {
  
  /// Assign root view to window. Adds any environment objects if needed.
  func set<T: UIViewController>(rootViewTo view: T) {
    window?.rootViewController = view
  }
}

