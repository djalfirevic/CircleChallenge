//
//  Endpoint.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

struct Endpoint: CustomStringConvertible {
    
    // MARK: - Properties
    let method: HttpMethod
    let host: String
    let path: String
    let body: Data?
    let queryItems: [URLQueryItem]
    let headerTypes: [HttpHeaderField: String]
    static let defaultHeaderTypes = [
        HttpHeaderField.accept: "application/json",
        HttpHeaderField.contentType: "application/json",
    ]
    var isLoggingEnabled = false
    var isPrivate = true
    var description: String {
        "\(method.rawValue.uppercased()) \(path)"
    }
    var absolutePath: String {
        guard let url = url else { return "" }
        return url.absoluteString
    }
    
    // MARK: - Initializer
    init(host: String = URLHost.default.rawValue,
         method: HttpMethod = .get,
         path: String,
         body: Data? = nil,
         queryItems: [URLQueryItem] = [],
         headerTypes: [HttpHeaderField: String] = Endpoint.defaultHeaderTypes,
         isLoggingEnabled: Bool = true,
         isPrivate: Bool = true) {
        self.method = method
        self.host = host
        self.path = path
        self.body = body
        self.queryItems = queryItems
        self.headerTypes = headerTypes
        self.isLoggingEnabled = isLoggingEnabled
        self.isPrivate = isPrivate
    }
    
    // MARK: - Public API
    static func serializeToJSON<T: Codable>(object: T) -> Data? {
        return try! JSONEncoder().encode(object)
    }
    
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}
