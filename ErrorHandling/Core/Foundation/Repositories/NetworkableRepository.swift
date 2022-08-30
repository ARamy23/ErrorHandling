//
//  NetworkableRepository.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 30/08/2022.
//

import Foundation

protocol NetworkableRepository {
  var network: NetworkProtocol { get }
  
  func adapt(_ error: Error) -> RepositoryError
}
