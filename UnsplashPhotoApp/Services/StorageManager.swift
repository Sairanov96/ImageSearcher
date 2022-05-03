//
//  StorageManager.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    var realm: Realm? {
            do {
                let realm = try Realm()
                return realm
            } catch let error as NSError {
                print(error)
            }
            return nil
        }
    
    private init() {}
    
    func save(_ photo: Photo) {
        write {
            realm?.add(photo)
        }
    }
    
    func delete(_ photo: Photo) {
        write {
            if let urls = photo.urls, let user = photo.user {
                realm?.delete(urls)
                realm?.delete(user)
            }
            realm?.delete(photo)
        }
    }
}

extension StorageManager {
    private func write(completion: () -> Void) {
        do {
            try realm?.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
