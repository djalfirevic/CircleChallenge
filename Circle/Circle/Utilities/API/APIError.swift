//
//  APIError.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknown
    case unauthorized
    case network(Error)
    case error(reason: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unknown:
            return "Unknown error"
        case .unauthorized:
            return "Unauthorized"
        case let .network(error):
            return error.localizedDescription
        case let .error(reason):
            return reason
        }
    }
}
