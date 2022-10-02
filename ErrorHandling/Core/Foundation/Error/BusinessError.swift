//
//  BusinessError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

public protocol BusinessError: Error { }

public struct UnknownBusinessError: BusinessError {
	public let underlyingError: Error?
	
	public init(underlyingError: Error?) {
		self.underlyingError = underlyingError
	}
}
