//
//  PaymentCard.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

struct PaymentCard: PaymentMethod {
  let id: UUID = .init()
  let last4Digits: String
  let expiryDate: String
  let holderName: String
}
