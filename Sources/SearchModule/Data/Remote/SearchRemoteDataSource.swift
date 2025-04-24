//
//  SearchRemoteDataSource.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class SearchRemoteDataSource {
    private let apiService: APIServiceProtocol
    private let logger = Logger(category: "SearchRemoteDataSource")
    
    public init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func searchItems(query: String) async throws -> [SearchResultItemDTO] {
        logger.log("Executing search query: \(query)", level: .debug)
        let endpoint = APIEndpoints.searchItems(query: query)
        return try await apiService.request(endpoint: endpoint)
    }
    
    func getPopularSearches() async throws -> [String] {
        logger.log("Fetching popular searches", level: .debug)
        let endpoint = GenericEndpoint(
            path: "/api/search/popular",
            method: .get
        )
        let response: PopularSearchesResponse = try await apiService.request(endpoint: endpoint)
        return response.popularSearches
    }
}
