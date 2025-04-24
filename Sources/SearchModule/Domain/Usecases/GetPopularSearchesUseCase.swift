//
//  GetPopularSearchesUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class GetPopularSearchesUseCase: UseCase {
    public typealias Parameters = Void
    public typealias ReturnType = [String]
    
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: Void) async -> Result<[String], Error> {
        do {
            let popularSearches = try await repository.getPopularSearches()
            return .success(popularSearches)
        } catch {
            return .failure(error)
        }
    }
}
