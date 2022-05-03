//
//  TabItem.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 29.04.2022.
//

import Foundation
import UIKit

enum TabType: Int, CaseIterable {
    case home = 0, favorite
}

struct TabItem {
    let image: UIImage?
    let viewController: UIViewController
    let type: TabType
}
