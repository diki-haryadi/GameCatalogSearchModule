//
//  GetRecentSearchesUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class GetRecentSearchesUseCase: UseCase {
    public typealias Parameters = Void
    public typealias ReturnType = [String]
    
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: Void) async -> Result<[String], Error> {
        let recentSearches = repository.getRecentSearches()
        return .success(recentSearches)
    }
}
