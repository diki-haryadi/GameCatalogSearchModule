//
//  SearchRepositoryProtocol.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

public protocol SearchRepositoryProtocol {
    func searchItems(query: String) async throws -> [SearchResultItem]
    func getRecentSearches() -> [String]
    func clearRecentSearches()
    func getPopularSearches() async throws -> [String]
}
