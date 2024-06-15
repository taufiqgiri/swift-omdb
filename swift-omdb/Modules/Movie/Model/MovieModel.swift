//
//  MovieModel.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Foundation

struct MovieModel: NullableMap {
    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var Ratings: [RatingModel]?
    var Metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var type: String?
    var DVD: String?
    var BoxOffice: String?
    var Production: String?
    var Website: String?
    var Response: String?
    
    init?(dict: [String : Any]?) {
        guard let dict else { return }
        
        Title = dict["Title"] as? String
        Year = dict["Year"] as? String
        Rated = dict["Rated"] as? String
        Released = dict["Released"] as? String
        Runtime = dict["Runtime"] as? String
        Genre = dict["Genre"] as? String
        Director = dict["Director"] as? String
        Writer = dict["Writer"] as? String
        Actors = dict["Actors"] as? String
        Plot = dict["Plot"] as? String
        Language = dict["Language"] as? String
        Country = dict["Country"] as? String
        Awards = dict["Awards"] as? String
        Poster = dict["Poster"] as? String
        Metascore = dict["Metascore"] as? String
        imdbRating = dict["imdbRating"] as? String
        imdbVotes = dict["imdbVotes"] as? String
        imdbID = dict["imdbID"] as? String
        type = dict["Type"] as? String
        DVD = dict["DVD"] as? String
        BoxOffice = dict["BoxOffice"] as? String
        Production = dict["Production"] as? String
        Website = dict["Website"] as? String
        Response = dict["Response"] as? String
        
        if let ratingsDict = dict["Ratings"] as? [[String: Any]] {
            Ratings = ratingsDict.compactMap({ RatingModel(dict: $0) })
        }
    }
    
    func dictionary() -> [String : Any]? {
        var dict: [String: Any] = [:]
        
        dict["Title"] = Title
        dict["Year"] = Year
        dict["Ratings"] = Ratings?.compactMap({ $0.dictionary() })
        dict["Rated"] = Rated
        dict["Released"] = Released
        dict["Runtime"] = Runtime
        dict["Genre"] = Genre
        dict["Director"] = Director
        dict["Writer"] = Writer
        dict["Actors"] = Actors
        dict["Plot"] = Plot
        dict["Language"] = Language
        dict["Country"] = Country
        dict["Awards"] = Awards
        dict["Poster"] = Poster
        dict["Metascore"] = Metascore
        dict["imdbRating"] = imdbRating
        dict["imdbVotes"] = imdbVotes
        dict["imdbID"] = imdbID
        dict["Type"] = type
        dict["DVD"] = DVD
        dict["BoxOffice"] = BoxOffice
        dict["Production"] = Production
        dict["Website"] = Website
        dict["Response"] = Response
        
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case Title, Year, Ratings, Rated, Released
        case Runtime, Genre, Director, Writer, Actors
        case Plot, Language, Country, Awards, Poster
        case Metascore, imdbRating, imdbVotes, imdbID, DVD
        case BoxOffice, Production, Website, Response
        case type = "Type"
    }
}

struct RatingModel: NullableMap {
    var Source: String?
    var Value: String?
    
    init?(dict: [String : Any]?) {
        guard let dict else { return }
        
        Source = dict["Source"] as? String
        Value = dict["Value"] as? String
    }
    
    func dictionary() -> [String : Any]? {
        var dict: [String: Any] = [:]
        
        dict["Source"] = Source
        dict["Value"] = Value
        
        return dict
    }
}
