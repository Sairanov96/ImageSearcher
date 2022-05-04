//
//  Photo.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import Foundation
import RealmSwift


class Photo: Object, Codable {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var created_at = ""
    @Persisted var urls: Urls? = nil
    @Persisted var user: User? = nil
    @Persisted var downloads: Int? = 0
}

class User: Object, Codable {
    @Persisted var name = ""
    @Persisted var location: String? = ""
}

class Urls: Object, Codable {
    @Persisted var small = ""
    @Persisted var thumb = ""
}
