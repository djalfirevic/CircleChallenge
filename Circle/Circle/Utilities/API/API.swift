//
//  API.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation

struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var `default`: Self {
        return URLHost(rawValue: "api.github.com")
    }
}

enum HttpMethod: String {
    case get
    case post
    case put
    case delete
}

enum ResponseStatus {
    case informational
    case success
    case redirect
    case clientError
    case serverError
    case systemError
    case unauthorized
    
    // MARK: - Initializer
    init(statusCode: Int) {
        switch statusCode {
            case 100...199: self = .informational
            case 200...299: self = .success
            case 300...399: self = .redirect
            case 400...499:
                if statusCode == 401 {
                    self = .unauthorized
                } else {
                    self = .clientError
                }
            case 500...599: self = .serverError
            default: self = .systemError
        }
    }
}

enum HttpHeaderField: String {
    case contentType = "Content-Type"
    case accept = "Accept"
    case authorization = "Authorization"
}

extension URLRequest {
    var curlString: String {
        guard let url = url else { return "" }
        
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
