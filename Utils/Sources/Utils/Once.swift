//
//  Once.swift
//
//
//  Created by Ahmed Ramy on 15/02/2022.
//

import Foundation

public class Once {
  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func run(_ action: @escaping VoidCallback) {
    guard didRun == false else { return }
    didRun = true
    action()
  }

  // MARK: Private

  private var didRun = false
}
