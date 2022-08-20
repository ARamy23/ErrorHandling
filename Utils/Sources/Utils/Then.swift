import Foundation
import UIKit

// MARK: - Then

public protocol Then { }

extension Then where Self: Any {
  /// Makes it available to set properties with closures just after initializing and copying the value types.
  ///
  ///     let frame = CGRect().with {
  ///       $0.origin.x = 10
  ///       $0.size.width = 100
  ///     }
  public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try block(&copy)
    return copy
  }

  /// Makes it available to execute something with closures.
  ///
  ///     UserDefaults.standard.do {
  ///       $0.set("devxoul", forKey: "username")
  ///       $0.set("devxoul@gmail.com", forKey: "email")
  ///       $0.synchronize()
  ///     }
  public func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }
}

extension Then where Self: AnyObject {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///       $0.textAlignment = .center
  ///       $0.textColor = UIColor.black
  ///       $0.text = "Hello, World!"
  ///     }
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

// MARK: - NSObject + Then

extension NSObject: Then { }

// MARK: - CGPoint + Then

extension CGPoint: Then { }

// MARK: - CGRect + Then

extension CGRect: Then { }

// MARK: - CGSize + Then

extension CGSize: Then { }

// MARK: - CGVector + Then

extension CGVector: Then { }

// MARK: - Array + Then

extension Array: Then { }

// MARK: - Dictionary + Then

extension Dictionary: Then { }

// MARK: - Set + Then

extension Set: Then { }

// MARK: - UIEdgeInsets + Then

extension UIEdgeInsets: Then { }

// MARK: - UIOffset + Then

extension UIOffset: Then { }

// MARK: - UIRectEdge + Then

extension UIRectEdge: Then { }
