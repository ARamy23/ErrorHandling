//
//  PaymentCardsEndpoint.swift
//  CafuPlayground
//
//  Created by Ahmed Ramy on 24/08/2022.
//

import Foundation

// MARK: - PaymentCardsEndpoint

enum PaymentCardsEndpoint {
  case fetch
}

// MARK: Endpoint

extension PaymentCardsEndpoint: Endpoint {
  var path: String {
    "payment-cards"
  }

  var parameters: HTTPParameters {
    [:]
  }

  var method: HTTPMethod {
    .GET
  }
}
