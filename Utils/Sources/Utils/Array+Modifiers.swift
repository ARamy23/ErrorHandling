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
  public func appending(_ element: Element, if condition: Bool = true) -> Self {
    guard condition else { return self }
    var current = self
    current.append(element)
    return current
  }

  public func appending(elements: [Element], if condition: Bool = true) -> Self {
    guard condition else { return self }
    var current = self
    current.append(contentsOf: elements)
    return current
  }
    
  public func appending(_ element: () async throws -> (Element), if condition: Bool = true) async rethrows -> Self {
    guard condition else { return self }
    var current = self
    current.append(try await element())
    return current
  }
  
  public func appending(elements: () async throws -> ([Element]), if condition: Bool = true) async rethrows -> Self {
    guard condition else { return self }
    var current = self
    current.append(contentsOf: try await elements())
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
