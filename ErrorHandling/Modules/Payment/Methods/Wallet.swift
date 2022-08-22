//
//  Wallet.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

struct Wallet: PaymentMethod {
  let id: UUID = .init()
  var balance: Money
}
