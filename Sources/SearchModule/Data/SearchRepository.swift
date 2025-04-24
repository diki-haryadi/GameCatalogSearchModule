//
//  SearchRepository.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class SearchRepository: SearchRepositoryProtocol {
    private let remoteDataSource: SearchRemoteDataSource
    private let localDataSource: SearchLocalDataSource
    private let logger = Logger(category: "SearchRepository")
    
    public init(
        remoteDataSource: SearchRemoteDataSource,
        localDataSource: SearchLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func searchItems(query: String) async throws -> [SearchResultItem] {
        if query.isEmpty {
            return []
        }
        
        // Check if we have cached results for this query
        if let cachedResults = try? localDataSource.getCachedResults(for: query) {
            logger.log("Using cached search results for query: \(query)", level: .debug)
            return cachedResults
        }
        
        // Perform search on remote
        logger.log("Performing remote search for query: \(query)", level: .debug)
        let searchResultDTOs = try await remoteDataSource.searchItems(query: query)
        let searchResults = searchResultDTOs.map { $0.toDomain() }
        
        // Cache results
        try? localDataSource.cacheSearchResults(query: query, results: searchResults)
        
        // Save query to search history
        localDataSource.saveSearchQuery(query)
        
        return searchResults
    }
    
    public func getRecentSearches() -> [String] {
        return localDataSource.getRecentSearches()
    }
    
    public func clearRecentSearches() {
        localDataSource.clearRecentSearches()
    }
    
    public func getPopularSearches() async throws -> [String] {
        // Try to get from cache first
        if let cachedPopular = localDataSource.getCachedPopularSearches() {
            return cachedPopular
        }
        
        // If not in cache, fetch from remote
        let popularSearches = try await remoteDataSource.getPopularSearches()
        
        // Cache the results
        localDataSource.cachePopularSearches(popularSearches)
        
        return popularSearches
    }
}
