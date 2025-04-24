//
//  SearchLocalDataSource.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class SearchLocalDataSource {
    private let localStorage: LocalStorageProtocol
    private let logger = Logger(category: "SearchLocalDataSource")
    
    // Keys
    private enum Keys {
        static let recentSearches = "recent_searches"
        static let cachedResults = "cached_search_results_"
        static let popularSearches = "popular_searches"
    }
    
    // Constants
    private let maxRecentSearches = 10
    private let cacheExpirationTime: TimeInterval = 60 * 60 // 1 hour
    
    public init(localStorage: LocalStorageProtocol) {
        self.localStorage = localStorage
    }
    
    func saveSearchQuery(_ query: String) {
        var recentSearches = getRecentSearches()
        
        // Remove if already exists to avoid duplicates
        recentSearches.removeAll { $0.lowercased() == query.lowercased() }
        
        // Add to the beginning
        recentSearches.insert(query, at: 0)
        
        // Limit the number of recent searches
        if recentSearches.count > maxRecentSearches {
            recentSearches = Array(recentSearches.prefix(maxRecentSearches))
        }
        
        do {
            try localStorage.save(recentSearches, forKey: Keys.recentSearches)
        } catch {
            logger.log("Failed to save search query: \(error.localizedDescription)", level: .error)
        }
    }
    
    func getRecentSearches() -> [String] {
        do {
            return try localStorage.get(forKey: Keys.recentSearches) ?? []
        } catch {
            logger.log("Failed to get recent searches: \(error.localizedDescription)", level: .error)
            return []
        }
    }
    
    func clearRecentSearches() {
        localStorage.remove(forKey: Keys.recentSearches)
    }
    
    func cacheSearchResults(query: String, results: [SearchResultItem]) throws {
        let cacheItem = CachedSearchResults(
            results: results,
            timestamp: Date().timeIntervalSince1970
        )
        try localStorage.save(cacheItem, forKey: Keys.cachedResults + query.lowercased())
    }
    
    func getCachedResults(for query: String) throws -> [SearchResultItem]? {
        guard let cachedItem: CachedSearchResults = try localStorage.get(
            forKey: Keys.cachedResults + query.lowercased()
        ) else {
            return nil
        }
        
        // Check if cache is still valid
        let currentTime = Date().timeIntervalSince1970
        if currentTime - cachedItem.timestamp > cacheExpirationTime {
            // Cache expired
            localStorage.remove(forKey: Keys.cachedResults + query.lowercased())
            return nil
        }
        
        return cachedItem.results
    }
    
    func cachePopularSearches(_ searches: [String]) {
        do {
            try localStorage.save(searches, forKey: Keys.popularSearches)
        } catch {
            logger.log("Failed to cache popular searches: \(error.localizedDescription)", level: .error)
        }
    }
    
    func getCachedPopularSearches() -> [String]? {
        do {
            return try localStorage.get(forKey: Keys.popularSearches)
        } catch {
            logger.log("Failed to get cached popular searches: \(error.localizedDescription)", level: .error)
            return nil
        }
    }
}
