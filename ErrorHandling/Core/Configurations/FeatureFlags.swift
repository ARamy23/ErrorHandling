//
//  FeatureFlags.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

// MARK: - FeatureFlagsProtocol

protocol FeatureFlagsProtocol {
  var applePay: Bool { get }
  var wallet: Bool { get }
}

// MARK: - FeatureFlags

struct FeatureFlags: FeatureFlagsProtocol {
  let applePay = false
  let wallet = false
}
