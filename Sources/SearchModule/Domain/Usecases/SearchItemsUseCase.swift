//
//  SearchItemsUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class SearchItemsUseCase: UseCase {
    public typealias Parameters = String
    public typealias ReturnType = [SearchResultItem]
    
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: String) async -> Result<[SearchResultItem], Error> {
        do {
            let results = try await repository.searchItems(query: parameters)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}
