//
//  WalletEndpoint.swift
//  CafuPlayground
//
//  Created by Ahmed Ramy on 24/08/2022.
//

import Foundation

// MARK: - WalletEndpoint

enum WalletEndpoint {
  case fetch
}

// MARK: Endpoint

extension WalletEndpoint: Endpoint {
  var path: String {
    "wallet-profile"
  }

  var parameters: HTTPParameters {
    [:]
  }

  var method: HTTPMethod {
    .GET
  }
}
