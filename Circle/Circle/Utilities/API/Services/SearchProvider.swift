//
//  AuthProvider.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Combine

protocol SearchRroviderProtocol {
    func seachUsers(with term: String, page: Int, count: Int) -> AnyPublisher<SearchResponse, Error>
}

final class SearchRrovider: SearchRroviderProtocol {
    
    // MARK: - Properties
    private let service: SearchRroviderProtocol
    
    // MARK: - Initializer
    init(service: SearchRroviderProtocol = SearchApiService()) {
        self.service = service
    }

    // MARK: - AuthRroviderProtocol
    func seachUsers(with term: String, page: Int, count: Int) -> AnyPublisher<SearchResponse, Error> {
        service.seachUsers(with: term, page: page, count: count)
    }
    
}
