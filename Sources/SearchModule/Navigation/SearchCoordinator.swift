//
//  SearchCoordinator.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import UIKit
import CoreModule

public class SearchModuleAssembly {
    private let coreAssembly: CoreAssembly
    
    public init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    public func makeSearchModule(navigationController: UINavigationController) -> UIViewController {
        let remoteDataSource = SearchRemoteDataSource(apiService: coreAssembly.apiService)
        let localDataSource = SearchLocalDataSource(localStorage: coreAssembly.localStorage)
        let repository = SearchRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        
        let searchItemsUseCase = SearchItemsUseCase(repository: repository)
        let getRecentSearchesUseCase = GetRecentSearchesUseCase(repository: repository)
        let clearRecentSearchesUseCase = ClearRecentSearchesUseCase(repository: repository)
        let getPopularSearchesUseCase = GetPopularSearchesUseCase(repository: repository)
        
        let viewModel = SearchViewModel(
            searchItemsUseCase: searchItemsUseCase,
            getRecentSearchesUseCase: getRecentSearchesUseCase,
            clearRecentSearchesUseCase: clearRecentSearchesUseCase,
            getPopularSearchesUseCase: getPopularSearchesUseCase
        )
        
        let coordinator = DefaultSearchCoordinator(
            navigationController: navigationController,
            moduleFactory: coreAssembly.moduleFactory,
            searchViewModel: viewModel
        )
        
        return coordinator.start()
    }
}Name: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search", text: $viewModel.searchQuery)
                .disableAutocorrection(true)
                .focused($isSearchFieldFocused)
            
            if !viewModel.searchQuery.isEmpty {
                Button(action: {
                    viewModel.searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.searchState {
        case .initial:
            initialStateView
        case .searching:
            loadingView
        case .results:
            searchResultsView
        case .noResults:
            noResultsView
        case .error:
            errorView
        }
    }
    
    private var initialStateView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !viewModel.recentSearches.isEmpty {
                    recentSearchesSection
                }
                
                if !viewModel.popularSearches.isEmpty {
                    popularSearchesSection
                }
            }
            .padding()
        }
    }
    
    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear") {
                    viewModel.clearRecentSearches()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ForEach(viewModel.recentSearches, id: \.self) { search in
                HStack {
                    Text(search)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectRecentSearch(search)
                }
                
                if search != viewModel.recentSearches.last {
                    Divider()
                }
            }
        }
    }
    
    private var popularSearchesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Searches")
                .font(.headline)
            
            FlowLayout(spacing: 8) {
                ForEach(viewModel.popularSearches, id: \.self) { search in
                    Text(search)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.primary)
                        .clipShape(Capsule())
                        .onTapGesture {
                            viewModel.selectRecentSearch(search)
                        }
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .padding()
            
            Text("Searching...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchResultsView: some View {
        List {
            ForEach(viewModel.searchResults) { result in
                SearchResultRow(item: result)
                    .onTapGesture {
                        coordinator.navigateToDetail(itemId: result.id)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(system
            Image(systemName: "magnifyingglass")
                           .font(.system(size: 50))
                           .foregroundColor(.gray.opacity(0.5))
                       
                       Text("No Results Found")
                           .font(.title2)
                           .fontWeight(.bold)
                       
                       Text("Try different keywords or check your spelling")
                           .font(.body)
                           .foregroundColor(.secondary)
                           .multilineTextAlignment(.center)
                           .padding(.horizontal, 32)
                   }
                   .padding()
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
               }
               
               private var errorView: some View {
                   VStack(spacing: 16) {
                       Image(systemName: "exclamationmark.triangle")
                           .font(.system(size: 50))
                           .foregroundColor(.orange)
                       
                       Text("Oops!")
                           .font(.title)
                           .fontWeight(.bold)
                       
                       Text(viewModel.errorMessage ?? "Something went wrong")
                           .font(.body)
                           .multilineTextAlignment(.center)
                           .padding(.horizontal)
                           .foregroundColor(.secondary)
                       
                       Button(action: {
                           viewModel.performSearch(query: viewModel.searchQuery)
                       }) {
                           Text("Try Again")
                               .fontWeight(.semibold)
                               .foregroundColor(.white)
                               .padding(.vertical, 12)
                               .padding(.horizontal, 24)
                               .background(Color.blue)
                               .clipShape(Capsule())
                       }
                       .padding(.top, 8)
                   }
                   .padding()
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
               }
           }
