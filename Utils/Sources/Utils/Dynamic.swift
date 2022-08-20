//
//  Dynamic.swift
//
//
//  Created by Ahmed Ramy on 15/02/2022.
//

import Foundation

// MARK: - Dynamic

/// Lightweight Observable Pattern
public class Dynamic<T> {
  // MARK: Lifecycle

  public init(_ v: T) {
    value = v
  }

  // MARK: Public

  public var value: T {
    didSet {
      update()
    }
  }

  public func bind(to binding: @escaping Callback<T>) {
    bindings.append(binding)
  }

  // MARK: Private

  private var bindings: [Callback<T>] = []

  private func update() {
    bindings.forEach {
      $0(value)
    }
  }
}

// MARK: Equatable

extension Dynamic: Equatable where T: Equatable {
  public static func == (lhs: Dynamic<T>, rhs: Dynamic<T>) -> Bool {
    lhs.value == rhs.value
  }
}
