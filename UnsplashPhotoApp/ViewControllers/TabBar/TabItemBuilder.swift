//
//  TabItemBuilder.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 29.04.2022.
//

import UIKit

enum TabItemBuilder {
    static func build(from types: [TabType]) -> [TabItem] {
        return types.map { type in
            let image = image(for: type)
            let viewController = viewController(for: type)
            return .init(image: image, viewController: viewController, type: type)
        }
    }
}

// MARK: - Private methods
private extension TabItemBuilder {
    static func image(for type: TabType) -> UIImage? {
        switch type {
        case .home:
            return UIImage(systemName: "house")
        case .favorite:
            return UIImage(systemName: "star")
        }
    }
    
    static func viewController(for type: TabType) -> UIViewController {
        switch type {
        case .home:
            let viewController = HomeTableController()
            return UINavigationController(rootViewController: viewController)
        case .favorite:
            let viewController = FavoriteViewController()
            return UINavigationController(rootViewController: viewController)
        }
    }
}


