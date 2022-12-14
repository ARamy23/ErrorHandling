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

  open func onSuccess(_: Model) { }
  open func onFailure(_: Error) { }

  // MARK: Public

  public func execute() async throws -> Model {
    do {
      try validate()
      let response = try await process()
      onSuccess(response)
      return response
    } catch {
      onFailure(error)
      throw error
    }
  }
}
