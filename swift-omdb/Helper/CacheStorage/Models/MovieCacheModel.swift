//
//  MovieCacheModel.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import RealmSwift

class MovieCacheModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var Title: String = ""
    @objc dynamic var Poster: String = ""
    @objc dynamic var imdbID: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
