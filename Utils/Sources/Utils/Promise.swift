//
//  Promise.swift
//  Proba (iOS)
//
//  Proprietary and confidential.
//  Unauthorized copying of this file or any part thereof is strictly prohibited.
//
//  Created by Ahmed Ramy on 03/09/2021.
//  Copyright © 2021 Proba B.V. All rights reserved.
//

import Foundation

/// Lightweight Promise Wrapper for better code readability
/// ## Promise
/// ### Normal way of doing things
/// ```
/// func asyncWork(completion: (String) -> Void) {
///     // ...
///     completion("test")
/// }
///
/// func asyncWorkNext(completion: (String) -> Void) { ... }
///
/// asyncWork { value in
///    print(value)
///    asyncWorkNext { string in
///     asyncWorkNext { string in
///       asyncWorkNext { string in
///         ... (Triangle of Doom issue)
///       }
///     }
///   }
/// }
/// ```
///
/// ### With Promise
/// ```
/// let asyncPromise = Promise<String> { resolve in
///    // ...
///    resolve("test")
/// }
///
/// let asyncPromise2 = Promise<String> { resolve in
///    // ...
///    resolve("test")
/// }
///
/// let asyncPromise3 = Promise<String> { resolve in
///    // ...
///    resolve("test")
/// }
///
/// asyncPromise.then(asyncPromise2).then(asyncPromise3)
///
/// // OR
///
/// Promise<String> { resolve in ... }.then(Promise<Int> { ...}).then(Promise<Bool> { ... })
///
/// ```
public class Promise<Value> {
  // MARK: Lifecycle

  public init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
    executor(resolve)
  }

  // MARK: Public

  // observe
  public func then(_ onResolved: @escaping (Value) -> Void) {
    callbacks.append(onResolved)
    triggerCallbacksIfResolved()
  }

  // flatMap
  public func then<NewValue>(_ onResolved: @escaping (Value) -> Promise<NewValue>) -> Promise<NewValue> {
    Promise<NewValue> { resolve in
      then { value in
        onResolved(value).then(resolve)
      }
    }
  }

  // map
  public func then<NewValue>(_ onResolved: @escaping (Value) -> NewValue) -> Promise<NewValue> {
    then { value in
      Promise<NewValue> { resolve in
        resolve(onResolved(value))
      }
    }
  }

  // MARK: Internal

  enum State<T> {
    case pending
    case resolved(T)
  }

  // MARK: Private

  private var state: State<Value> = .pending
  private var callbacks: [(Value) -> Void] = []

  private func resolve(value: Value) {
    updateState(to: .resolved(value))
  }

  private func updateState(to newState: State<Value>) {
    guard case .pending = state else { return }
    state = newState
    triggerCallbacksIfResolved()
  }

  private func triggerCallbacksIfResolved() {
    guard case .resolved(let value) = state else { return }
    callbacks.forEach { callback in
      callback(value)
    }
    callbacks.removeAll()
  }
}
