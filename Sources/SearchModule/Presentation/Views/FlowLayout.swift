//
//  FlowLayout.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import SwiftUI

struct FlowLayout<Content: View>: View {
    @State private var viewHeight: CGFloat = .zero
    private let items: [AnyView]
    private let verticalSpacing: CGFloat
    private let horizontalSpacing: CGFloat
    
    public init(
        verticalSpacing: CGFloat = 8,
        horizontalSpacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
        
        // Use Mirror API to extract array of views from content
        // Mirror is used to introspect ForEach children from the ViewBuilder
        let children = Mirror(reflecting: content()).children.compactMap { $0.value }
        if let firstChild = children.first,
           let childArray = Mirror(reflecting: firstChild).children.first?.value as? [AnyView] {
            self.items = childArray
        } else {
            self.items = []
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            content(in: geometry)
                .background(viewHeightReader)
        }
        .frame(height: viewHeight)
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                item
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height = height + lastHeight + verticalSpacing
                        }
                        let result = width
                        if index == items.count - 1 {
                            width = 0
                        } else {
                            width = width + d.width + horizontalSpacing
                        }
                        lastHeight = d.height
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        height
                    })
            }
        }
    }
    
    private var viewHeightReader: some View {
        GeometryReader { geometry -> Color in
            let height = geometry.frame(in: .local).size.height
            DispatchQueue.main.async {
                self.viewHeight = height
            }
            return Color.clear
        }
    }
}

extension ForEach {
    func convertToAnyView() -> [AnyView] {
        return self.data.map { item in
            AnyView(self.content(item))
        }
    }
}

// SearchModule/Sources/SearchModule/Navigation/SearchCoordinator.swift
import Foundation
import UIKit
import SwiftUI
import CoreModule

public protocol SearchCoordinator {
    func start() -> UIViewController
    func navigateToDetail(itemId: String)
}

public class DefaultSearchCoordinator: SearchCoordinator {
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol
    private let searchViewModel: SearchViewModel
    
    public init(
        navigationController: UINavigationController,
        moduleFactory: ModuleFactoryProtocol,
        searchViewModel: SearchViewModel
    ) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.searchViewModel = searchViewModel
    }
    
    public func start() -> UIViewController {
        let searchView = SearchView(viewModel: searchViewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: searchView)
        navigationController.viewControllers = [hostingController]
        return navigationController
    }
    
    public func navigateToDetail(itemId: String) {
        guard let detailViewController = moduleFactory.makeDetailModule(itemId: itemId) else { return }
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
