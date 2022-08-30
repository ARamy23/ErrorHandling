//
//  WalletEndpoint.swift
//  CafuPlayground
//
//  Created by Ahmed Ramy on 24/08/2022.
//

import Foundation

enum WalletEndpoint {
    case fetch
}

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
