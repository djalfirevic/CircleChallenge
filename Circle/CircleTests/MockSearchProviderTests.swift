//
//  MockSearchProviderTests.swift
//  MockSearchProviderTests
//
//  Created by Djuro on 8/28/21.
//

import XCTest
import Combine
@testable import Circle

final class MockSearchProviderTests: XCTestCase {
    
    // MARK: - Properties
    private let searchProvider = MockSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Tests
    func testSearch() {
        searchProvider
            .seachUsers(with: "test", page: 0, count: 1)
            .sink { result in
                switch result {
                case .failure(let error):
                    Logger.logError(message: "Search Provider", error: error)
                    XCTFail("Search Provider failed")
                case .finished:
                    break
                }
            } receiveValue: { response in
                XCTAssert(response.items.count == 1, "Users count should be 1")
                
                Logger.log(message: "Fetched \(response.items.count)", type: .debug)
            }
            .store(in: &cancellables)
    }
    
}
