//
//  BusinessError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 22/08/2022.
//

import Foundation

/// A handshake for all business errors
///
/// Acts a common type between business errors, and a constraint to Usecase users where, if they were to throw an error, the caller dealing with a Usecase is expecting at least a Business Error
/// so, it can handle it
///
/// - Note: An abstraction also means, if needed, we can add general logic to most of our errors in an extension, and override it if needed specifically
protocol BusinessError: BaseError { }
