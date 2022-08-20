//
//  Int+Extensions.swift
//
//
//  Created by Ahmed Ramy on 02/03/2022.
//

import Foundation

extension Comparable {
  public func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}

#if swift(<5.1)
extension Strideable where Stride: SignedInteger {
  public func clamped(to limits: CountableClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
#endif
