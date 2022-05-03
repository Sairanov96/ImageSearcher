//
//  SearchPhoto.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 03.05.2022.
//

import Foundation
import RealmSwift

struct SearchPhoto:  Codable {
    let results: [Photo]
}
