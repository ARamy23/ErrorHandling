//
//  RepositoryError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

public struct RepositoryError: Error {
  let underlyingError: Error?

  init(underlyingError: Error? = nil) {
    self.underlyingError = underlyingError
  }

  static let networkError: (NetworkError?) -> RepositoryError = { .init(underlyingError: $0) }
}
