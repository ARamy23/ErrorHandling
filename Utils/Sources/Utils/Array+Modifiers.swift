//
//  File.swift
//
//
//  Created by Ahmed Ramy on 25/01/2022.
//

import Foundation

extension Array where Element: Identifiable {
  public mutating func findAndReplaceElseAppend(with replacer: Element) {
    if let index = firstIndex(where: { $0.id == replacer.id }) {
      self[index] = replacer
    } else {
      append(replacer)
    }
  }

  public mutating func findAndReplace(with replacer: Element) {
    guard let index = firstIndex(where: { $0.id == replacer.id }) else { return }
    self[index] = replacer
  }

  public mutating func findAndRemove(_ target: Element) {
    removeAll(where: { $0.id == target.id })
  }
}

extension Array {
  public func appending(_ elements: Element) -> Self {
    var current = self
    current.append(elements)
    return current
  }

  public func appending(elements: [Element]) -> Self {
    var current = self
    current.append(contentsOf: elements)
    return current
  }
}

extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
    sorted { a, b in
      a[keyPath: keyPath] < b[keyPath: keyPath]
    }
  }
}

// MARK: - Changeable

public protocol Changeable { }
extension Changeable {
  public func changing(_ change: (inout Self) -> Void) -> Self {
    var a = self
    change(&a)
    return a
  }
}

// MARK: - Array + Changeable

extension Array: Changeable where Element: Changeable { }
