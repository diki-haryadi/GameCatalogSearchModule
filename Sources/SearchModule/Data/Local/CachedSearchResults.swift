//
//  CachedSearchResults.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

struct CachedSearchResults: Codable {
    let results: [SearchResultItem]
    let timestamp: TimeInterval
}

// SearchModule/Sources/SearchModule/Data/Remote/DTOs/SearchResultItemDTO.swift
import Foundation

struct SearchResultItemDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let category: String
    let type: String
    let relevanceScore: Double
    
    func toDomain() -> SearchResultItem {
        return SearchResultItem(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            category: category,
            type: SearchResultType(rawValue: type) ?? .unknown,
            relevanceScore: relevanceScore
        )
    }
}
