//
//  HomeViewModel.swift
//  Circle
//
//  Created by Djuro on 8/28/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties
    private let searchProvider: SearchRroviderProtocol
    private var cancellables = Set<AnyCancellable>()
    private let itemsPerPage = 30
    private var page = 0
    private var searchTerm = ""
    var hasMoreData = false
    @Published var items = [User]()
    
    // MARK: - Initializer
    init(searchProvider: SearchRroviderProtocol = SearchApiService()) {
        self.searchProvider = searchProvider
    }
    
    // MARK: - Public API
    func refresh() {
        page = 0
        fetchItems(for: searchTerm)
    }
    
    func fetchItems(for term: String) {
        if searchTerm != term {
            page = 0
            items.removeAll()
        }
        
        searchTerm = term
        
        searchProvider
            .seachUsers(with: term, page: page, count: itemsPerPage)
            .sink { result in
                switch result {
                case .failure(let error):
                    CircleLogger.logError(message: "Search Provider", error: error)
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] response in
                self.items.append(contentsOf: response.items)
                self.page += 1
                self.hasMoreData = response.items.count == self.itemsPerPage
                
                CircleLogger.log(message: "Fetched \(response.items.count)", type: .debug)
            }
            .store(in: &cancellables)
    }
    
}
