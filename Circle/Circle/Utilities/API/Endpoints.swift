//
//  Endpoints.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

extension Endpoint {
    
    // MARK: - Public API
    static func seachUsers(with term: String, page: Int, count: Int) -> Endpoint {
        let queryItems = [
            URLQueryItem(name: "q", value: term),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(count)"),
        ]
                         
        return Endpoint(method: .get, path: "search/users", queryItems: queryItems, isPrivate: false)
    }
    
}
