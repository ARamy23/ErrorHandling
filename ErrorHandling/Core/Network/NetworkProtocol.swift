//
//  NetworkProtocol.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 03/11/2021.
//

import Combine
import Foundation

public protocol NetworkProtocol {
  func call<T: Decodable, U: Endpoint>(api: U, model: T.Type) async throws -> T
}
