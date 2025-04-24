//
//  ClearRecentSearchesUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class ClearRecentSearchesUseCase: UseCase {
    public typealias Parameters = Void
    public typealias ReturnType = Void
    
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: Void) async -> Result<Void, Error> {
        repository.clearRecentSearches()
        return .success(())
    }
}
