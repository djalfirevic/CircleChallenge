//
//  MockSearchService.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Combine

final class MockSearchService: SearchRroviderProtocol {
    
    // MARK: - SearchRroviderProtocol
    func seachUsers(with term: String, page: Int, count: Int) -> AnyPublisher<SearchResponse, Error> {
        let response = SearchResponse(items: [User(id: 1, login: "test", avatarUrl: "some_url")])
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
