//
//  TabBarController.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 29.04.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var items: [TabItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = tabBar.frame.size.height + 16
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = view.frame.height - height
    }
}

// MARK: - Private methods
private extension TabBarController {
    func setupViews() {
        configureTabBar()
        configureTabs()
        
        selectedIndex = TabType.home.rawValue
    }
    
    func configureTabBar() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.backgroundImage = .init()
    }
    
    func configureTabs() {
        items = TabItemBuilder.build(from: TabType.allCases)
        
        viewControllers = items.enumerated().map { index, item -> UIViewController in
            let tab: UITabBarItem = .init(title: nil, image: item.image, tag: index)
            item.viewController.tabBarItem = tab
            return item.viewController
        }
    }
}
