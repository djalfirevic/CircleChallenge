//
//  DataLoader.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Combine
import Pulse

final class DataLoader: NSObject {
    fileprivate enum Constants {
        static let timeoutInterval: TimeInterval = 60
        static let memoryCacheSizeMB = 25 * 1024 * 1024
        static let diskCacheSizeMB = 250 * 1024 * 1024
    }
    
    // MARK: - Properties
    private static let cache: URLCache = URLCache(memoryCapacity: Constants.memoryCacheSizeMB,
                                                  diskCapacity: Constants.diskCacheSizeMB,
                                                  diskPath: String(describing: DataLoader.self))
    private static let sessionConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.urlCache = cache
        return configuration
    }()
    private var session = URLSession(configuration: sessionConfiguration)
    private let logger = NetworkLogger()
    
    // MARK: - Public API
    func decodablePublisher<T: Decodable>(for endpoint: Endpoint) -> AnyPublisher<T, Error> {
        if !Reachability.isConnectedToNetwork() {
            return AnyPublisher(Fail<T, Error>(error: APIError.error(reason: "No network connection")))
        }
        
        guard let url = endpoint.url else {
            return AnyPublisher(Fail<T, Error>(error: APIError.invalidURL))
        }
        
        let request = createRequest(for: url, forEndpoint: endpoint)
        
        let logBuilder = LogBuilder()
        logBuilder.append("\(endpoint.method.rawValue) \(endpoint.absolutePath)")
        logBuilder.append("\(endpoint.headerTypes)")
        
        return session.dataTaskPublisher(for: request)
            .retry(1)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    let responseStatus = ResponseStatus(statusCode: httpResponse.statusCode)
                    logBuilder.append("Status Code: \(httpResponse.statusCode)")
                    
                    LoggerStore.default.storeRequest(request, response: response, error: nil, data: data, metrics: nil)
                    
                    switch responseStatus {
                    case .unauthorized:
                        if endpoint.isLoggingEnabled {
                            CircleLogger.log(message: logBuilder.build(), type: .error)
                        }
                        
                        throw APIError.unauthorized
                    default:
                        break
                    }
                }
                
                let string = String(data: data, encoding: .utf8) ?? ""
                logBuilder.append("Response data: \(string)")
                
                if endpoint.isLoggingEnabled {
                    CircleLogger.log(message: logBuilder.build(), type: .success)
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let object = try decoder.decode(T.self, from: data)
                    
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .success)
                    }
                    
                    return object
                } catch let DecodingError.dataCorrupted(context) {
                    logBuilder.append("Decoding error: \(String(describing: context))")

                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                } catch let DecodingError.keyNotFound(key, context) {
                    logBuilder.append("Key '\(key)' not found: \(context.debugDescription)")
                    logBuilder.append("codingPath: \(context.codingPath)")

                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                } catch let DecodingError.valueNotFound(value, context) {
                    logBuilder.append("Value '\(value)' not found: \(context.debugDescription)")
                    logBuilder.append("codingPath: \(context.codingPath)")

                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                } catch let DecodingError.typeMismatch(type, context)  {
                    logBuilder.append("Type '\(type)' mismatch: \(context.debugDescription)")
                    logBuilder.append("codingPath: \(context.codingPath)")

                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                } catch {
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                }
                
                return try decoder.decode(T.self, from: data)
            }
            .mapError { error in
                if let error = error as? APIError {
                    logBuilder.append("Error: \(error)")
                    logBuilder.append("Error: \(error.localizedDescription)")
                    
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                    
                    return error
                } else {
                    logBuilder.append("Error: \(error)")
                    logBuilder.append("Error: \(error.localizedDescription)")
                    
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                    
                    return APIError.error(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func dataPublisher(for endpoint: Endpoint) -> AnyPublisher<String, Error> {
        if !Reachability.isConnectedToNetwork() {
            return AnyPublisher(Fail<String, Error>(error: APIError.error(reason: "No network connection")))
        }
        
        guard let url = endpoint.url else {
            return AnyPublisher(Fail<String, Error>(error: APIError.invalidURL))
        }
        
        let request = createRequest(for: url, forEndpoint: endpoint)
        
        let logBuilder = LogBuilder()
        logBuilder.append("\(endpoint.method.rawValue) \(endpoint.absolutePath)")
        logBuilder.append("\(endpoint.headerTypes)")
        
        return session.dataTaskPublisher(for: request)
            .retry(1)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    let responseStatus = ResponseStatus(statusCode: httpResponse.statusCode)
                    logBuilder.append("Status Code: \(httpResponse.statusCode)")
                    
                    LoggerStore.default.storeRequest(request, response: response, error: nil, data: data, metrics: nil)
                    
                    switch responseStatus {
                    case .unauthorized:
                        if endpoint.isLoggingEnabled {
                            CircleLogger.log(message: logBuilder.build(), type: .error)
                        }
                        
                        throw APIError.unauthorized
                    default:
                        break
                    }
                }
                
                let string = String(data: data, encoding: .utf8) ?? ""
                logBuilder.append("Response data: \(string)")
                
                if endpoint.isLoggingEnabled {
                    CircleLogger.log(message: logBuilder.build(), type: .success)
                }
                
                return string
            }
            .mapError { error in
                if let error = error as? APIError {
                    logBuilder.append("Error: \(error)")
                    logBuilder.append("Error: \(error.localizedDescription)")
                    
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                    
                    return error
                } else {
                    logBuilder.append("Error: \(error)")
                    logBuilder.append("Error: \(error.localizedDescription)")
                    
                    if endpoint.isLoggingEnabled {
                        CircleLogger.log(message: logBuilder.build(), type: .error)
                    }
                    
                    return APIError.error(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private API
    private func createRequest(for url: URL, forEndpoint endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        for (key, value) in endpoint.headerTypes {
            request.setValue(value, forHTTPHeaderField: key.rawValue)
        }
        
        if endpoint.isPrivate {
            request.setValue("Bearer ", forHTTPHeaderField: HttpHeaderField.authorization.rawValue)
        }
        
        request.httpBody = endpoint.body
        
        return request
    }
    
}
