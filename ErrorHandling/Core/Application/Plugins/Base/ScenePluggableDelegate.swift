//
//  ScenePluggableDelegate.swift
//  Al-Najd
//
//  Created by Ahmed Ramy on 02/08/2022.
//

#if os(iOS)
import UIKit.UIResponder
import UIKit.UIScene
import UIKit.UIWindow
import UIKit.UIWindowScene

/// Subclassed by the `SceneDelegate` to pass lifecycle events to loaded plugins.
///
/// The scene plugins will be processed in sequence after calling `plugins() -> [ScenePlugin]`.
///
///     class SceneDelegate: ScenePluggableDelegate {
///
///         override func plugins() -> [ScenePlugin] {[
///             LoggerPlugin(),
///             NotificationPlugin()
///         ]}
///     }
///
/// Each scene plugin has access to the `SceneDelegate` lifecycle events:
///
///     struct LoggerPlugin: ScenePlugin {
///         private let log = Logger()
///
///         func sceneWillEnterForeground() {
///             log.info("Scene will enter foreground.")
///         }
///
///         func sceneDidEnterBackground() {
///             log.info("Scene did enter background.")
///         }
///     }
@available(iOS 13.0, *)
open class ScenePluggableDelegate: UIResponder, UIWindowSceneDelegate {
  // MARK: Lifecycle

  public override init() {
    super.init()

    // Load lazy property early
    _ = pluginInstances
  }

  // MARK: Open

  /// List of scene plugins for binding to `SceneDelegate` events
  open func plugins() -> [ScenePlugin] { [] } // Override

  // MARK: Public

  public var window: UIWindow?

  /// List of scene plugins for binding to `SceneDelegate` events
  public private(set) lazy var pluginInstances: [ScenePlugin] = plugins()
}

@available(iOS 13.0, *)
extension ScenePluggableDelegate {
  open func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
    pluginInstances.forEach { $0.scene(scene, willConnectTo: session, options: connectionOptions) }
  }

  open func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    pluginInstances.forEach { $0.scene(scene, continue: userActivity) }
  }

  open func sceneWillEnterForeground(_: UIScene) {
    pluginInstances.forEach { $0.sceneWillEnterForeground() }
  }

  open func sceneDidEnterBackground(_: UIScene) {
    pluginInstances.forEach { $0.sceneDidEnterBackground() }
  }

  open func sceneDidBecomeActive(_: UIScene) {
    pluginInstances.forEach { $0.sceneDidBecomeActive() }
  }

  open func sceneWillResignActive(_: UIScene) {
    pluginInstances.forEach { $0.sceneWillResignActive() }
  }

  open func sceneDidDisconnect(_: UIScene) {
    pluginInstances.forEach { $0.sceneDidDisconnect() }
  }
}

/// Conforming to an scene plugin and added to `SceneDelegate.plugins()` will trigger events.
public protocol ScenePlugin {
  /// Tells the delegate that the scene is about to begin running in the foreground and become visible to the user.
  func sceneWillEnterForeground()

  /// Tells the delegate that the scene is running in the background and is no longer onscreen.
  func sceneDidEnterBackground()

  /// Tells the delegate that the scene became active and is now responding to user events.
  func sceneDidBecomeActive()

  /// Tells the delegate that the scene is about to resign the active state and stop responding to user events.
  func sceneWillResignActive()

  /// Tells the delegate that UIKit removed a scene from your app.
  func sceneDidDisconnect()

  /// Tells the delegate about the addition of a scene to the app.
  @available(iOS 13.0, *)
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)

  /// Tells the delegate to handle the specified Handoff-related activity.
  @available(iOS 13.0, *)
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity)
}

// MARK: - Optionals
extension ScenePlugin {
  public func sceneWillEnterForeground() { }
  public func sceneDidEnterBackground() { }
  public func sceneDidBecomeActive() { }
  public func sceneWillResignActive() { }
  public func sceneDidDisconnect() { }

  @available(iOS 13.0, *)
  public func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) { }

  @available(iOS 13.0, *)
  public func scene(_: UIScene, continue _: NSUserActivity) { }
}
#endif
