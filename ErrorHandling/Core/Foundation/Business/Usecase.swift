//
//  Usecase.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

open class Usecase<Model> {
  // MARK: Open

  open func validate() throws { }
  open func process() async throws -> Model { fatalError("This is meant to be overriden") }

  // MARK: Public

  public func execute() async throws -> Model {
    do {
      try validate()
      return try await process()
    } catch {
      throw error
    }
  }
}
