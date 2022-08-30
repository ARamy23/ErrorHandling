//
//  NetworkError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 30/08/2022.
//

import Foundation

public struct NetworkError: Error {
  let underlyingError: Error?
  
  init(underlyingError: Error? = nil) {
    self.underlyingError = underlyingError
  }
}

extension NetworkError {
  static let unreachable = NetworkError()
  static let cancelled = NetworkError()
  static let decodingFailure: (Error?) -> NetworkError = { .init(underlyingError: $0) }
  static let unknown: (Error?) -> NetworkError = { .init(underlyingError: $0) }
}
