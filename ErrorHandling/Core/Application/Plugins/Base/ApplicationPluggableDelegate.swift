//
//  ApplicationPluggableDelegate.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 9/30/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//
#if os(iOS)
import UIKit.UIApplication
import UIKit.UIWindow

/// Subclassed by the `AppDelegate` to pass lifecycle events to loaded plugins.
///
/// The application plugins will be processed in sequence after calling `plugins() -> [ApplicationPlugin]`.
///
///     @UIApplicationMain
///     class AppDelegate: ApplicationPluggableDelegate {
///
///         override func plugins() -> [ApplicationPlugin] {[
///             LoggerPlugin(),
///             NotificationPlugin()
///         ]}
///     }
///
/// Each application plugin has access to the `AppDelegate` lifecycle events:
///
///     struct LoggerPlugin: ApplicationPlugin {
///         private let log = Logger()
///
///         func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
///             log.config(for: application)
///             return true
///         }
///
///         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
///             log.info("App did finish launching.")
///             return true
///         }
///
///         func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
///             log.warning("App did receive memory warning.")
///         }
///
///         func applicationWillTerminate(_ application: UIApplication) {
///             log.warning("App will terminate.")
///         }
///     }
open class ApplicationPluggableDelegate: UIResponder, UIApplicationDelegate {
  // MARK: Lifecycle


  public override init() {
    super.init()

    // Load lazy property early
    _ = pluginInstances
  }

  // MARK: Open


  /// List of application plugins for binding to `AppDelegate` events
  open func plugins() -> [ApplicationPlugin] { [] } // Override

  // MARK: Public

  public var window: UIWindow?

  /// List of application plugins for binding to `AppDelegate` events
  public private(set) lazy var pluginInstances: [ApplicationPlugin] = plugins()
}

extension ApplicationPluggableDelegate {
  open func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool
  {
    // Ensure all delegates called even if condition fails early
    // swiftlint:disable reduce_boolean
    pluginInstances.reduce(true) {
      $0 && $1.application(application, willFinishLaunchingWithOptions: launchOptions)
    }
  }

  open func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    // Ensure all delegates called even if condition fails early
    // swiftlint:disable reduce_boolean
    pluginInstances.reduce(true) {
      $0 && $1.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  }

  open func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void)
    -> Bool
  {
    // Ensure all delegates called even if condition fails early
    // swiftlint:disable reduce_boolean
    pluginInstances.reduce(false) {
      $0 || $1.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
  }
}

extension ApplicationPluggableDelegate {
  open func applicationWillEnterForeground(_: UIApplication) {
    pluginInstances
      .compactMap { $0 as? ScenePlugin }
      .forEach { $0.sceneWillEnterForeground() }
  }

  open func applicationDidEnterBackground(_: UIApplication) {
    pluginInstances
      .compactMap { $0 as? ScenePlugin }
      .forEach { $0.sceneDidEnterBackground() }
  }

  open func applicationDidBecomeActive(_: UIApplication) {
    pluginInstances
      .compactMap { $0 as? ScenePlugin }
      .forEach { $0.sceneDidBecomeActive() }
  }

  open func applicationWillResignActive(_: UIApplication) {
    pluginInstances
      .compactMap { $0 as? ScenePlugin }
      .forEach { $0.sceneWillResignActive() }
  }
}

extension ApplicationPluggableDelegate {
  open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
    pluginInstances.forEach { $0.applicationProtectedDataWillBecomeUnavailable(application) }
  }

  open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
    pluginInstances.forEach { $0.applicationProtectedDataDidBecomeAvailable(application) }
  }
}

extension ApplicationPluggableDelegate {
  open func applicationWillTerminate(_ application: UIApplication) {
    pluginInstances.forEach { $0.applicationWillTerminate(application) }
  }

  open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    pluginInstances.forEach { $0.applicationDidReceiveMemoryWarning(application) }
  }
}

/// Conforming to an app plugin and added to `AppDelegate.application()` will trigger events.
public protocol ApplicationPlugin {
  func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

  func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication)
  func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)

  func applicationWillTerminate(_ application: UIApplication)
  func applicationDidReceiveMemoryWarning(_ application: UIApplication)
}

// MARK: - Optionals
extension ApplicationPlugin {
  public func application(
    _: UIApplication,
    willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool { true }
  public func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool { true }
  public func application(
    _: UIApplication,
    continue _: NSUserActivity,
    restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void)
    -> Bool { false }

  public func applicationProtectedDataWillBecomeUnavailable(_: UIApplication) { }
  public func applicationProtectedDataDidBecomeAvailable(_: UIApplication) { }

  public func applicationWillTerminate(_: UIApplication) { }
  public func applicationDidReceiveMemoryWarning(_: UIApplication) { }
}

public protocol RemoteNotificationPluginDelegate: AnyObject {
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
}

extension RemoteNotificationPluginDelegate {
  public func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any]) { }
  public func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken _: Data) { }
  public func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) { }
}
#endif
