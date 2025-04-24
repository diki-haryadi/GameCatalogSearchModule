//
//  SearchViewModel.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import Combine
import CoreModule

public class SearchViewModel: ObservableObject {
    private let searchItemsUseCase: SearchItemsUseCase
    private let getRecentSearchesUseCase: GetRecentSearchesUseCase
    private let clearRecentSearchesUseCase: ClearRecentSearchesUseCase
    private let getPopularSearchesUseCase: GetPopularSearchesUseCase
    private let logger = Logger(category: "SearchViewModel")
    
    @Published public var searchQuery = ""
    @Published public var searchResults: [SearchResultItem] = []
    @Published public var recentSearches: [String] = []
    @Published public var popularSearches: [String] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var searchState: SearchState = .initial
    
    private var searchTask: Task<Void, Never>?
    private let debounceTimeInterval: TimeInterval = 0.5
    
    public init(
        searchItemsUseCase: SearchItemsUseCase,
        getRecentSearchesUseCase: GetRecentSearchesUseCase,
        clearRecentSearchesUseCase: ClearRecentSearchesUseCase,
        getPopularSearchesUseCase: GetPopularSearchesUseCase
    ) {
        self.searchItemsUseCase = searchItemsUseCase
        self.getRecentSearchesUseCase = getRecentSearchesUseCase
        self.clearRecentSearchesUseCase = clearRecentSearchesUseCase
        self.getPopularSearchesUseCase = getPopularSearchesUseCase
        
        // Setup search debounce
        setupSearchDebounce()
    }
    
    public func loadInitialData() {
        loadRecentSearches()
        loadPopularSearches()
    }
    
    private func setupSearchDebounce() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .seconds(debounceTimeInterval), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .cancel()
    }
    
    public func performSearch(query: String) {
        // Cancel any ongoing search task
        searchTask?.cancel()
        
        if query.isEmpty {
            searchResults = []
            searchState = .initial
            return
        }
        
        isLoading = true
        errorMessage = nil
        searchState = .searching
        
        searchTask = Task {
            do {
                let result = await searchItemsUseCase.execute(parameters: query)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let items):
                        self.searchResults = items
                        self.searchState = items.isEmpty ? .noResults : .results
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.searchState = .error
                        self.logger.log("Search error: \(error.localizedDescription)", level: .error)
                    }
                }
            }
        }
    }
    
    private func loadRecentSearches() {
        Task {
            let result = await getRecentSearchesUseCase.execute()
            
            if case .success(let searches) = result {
                await MainActor.run {
                    self.recentSearches = searches
                }
            }
        }
    }
    
    private func loadPopularSearches() {
        Task {
            let result = await getPopularSearchesUseCase.execute()
            
            await MainActor.run {
                switch result {
                case .success(let searches):
                    self.popularSearches = searches
                case .failure(let error):
                    self.logger.log("Failed to load popular searches: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
    
    public func clearRecentSearches() {
        Task {
            let _ = await clearRecentSearchesUseCase.execute()
            
            await MainActor.run {
                self.recentSearches = []
            }
        }
    }
    
    public func selectRecentSearch(_ query: String) {
        searchQuery = query
        performSearch(query: query)
    }
}

public enum SearchState {
    case initial
    case searching
    case results
    case noResults
    case error
}
