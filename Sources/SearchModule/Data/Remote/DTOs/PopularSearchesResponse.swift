//
//  PopularSearchesResponse.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

struct PopularSearchesResponse: Decodable {
    let popularSearches: [String]
}

// SearchModule/Sources/SearchModule/Domain/Models/SearchResultItem.swift
import Foundation

public struct SearchResultItem: Identifiable, Codable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let imageUrl: String
    public let category: String
    public let type: SearchResultType
    public let relevanceScore: Double
    
    public init(
        id: String,
        title: String,
        description: String,
        imageUrl: String,
        category: String,
        type: SearchResultType,
        relevanceScore: Double
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.type = type
        self.relevanceScore = relevanceScore
    }
}

public enum SearchResultType: String, Codable {
    case article
    case video
    case podcast
    case event
    case profile
    case unknown
}
