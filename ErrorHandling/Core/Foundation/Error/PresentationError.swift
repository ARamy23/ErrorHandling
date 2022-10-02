//
//  PresentationError.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import Foundation
import UIKit.UIImage

// MARK: - PresentationMethod

public struct PresentationError {
	let title: String
	let description: String?
	let icon: UIImage?
	let type: PresentationMethod

	init(title: String, description: String? = nil, type: PresentationMethod = .indicator, icon: UIImage? = nil) {
		self.title = title
		self.description = description
		self.type = type
		self.icon = icon
	}
}

enum PresentationMethod {
	case indicator
}


extension PresentationError {
	static let `default`: PresentationError = .init(title: "Opps, Something went wrong.")
}
