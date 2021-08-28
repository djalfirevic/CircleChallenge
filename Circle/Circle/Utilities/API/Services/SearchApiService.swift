//
//  SearchApiService.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Combine

final class SearchApiService: SearchRroviderProtocol {
    
    // MARK: - SearchRroviderProtocol
    func seachUsers(with term: String, page: Int, count: Int) -> AnyPublisher<SearchResponse, Error> {
        DataLoader().decodablePublisher(for: Endpoint.seachUsers(with: term, page: page, count: count))
    }
    
}
