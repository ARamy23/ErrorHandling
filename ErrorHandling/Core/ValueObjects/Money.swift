//
//  Money.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

struct Money {
  var value: Double
  var currency = "EGP"

  func display() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = currency
    numberFormatter.maximumFractionDigits = 2

    return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)\(currency)"
  }
}
