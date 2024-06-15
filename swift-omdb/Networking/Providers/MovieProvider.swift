//
//  MovieProvider.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Moya

enum MovieProvider {
    case searchMovie(keyword: String, page: Int)
}

extension MovieProvider: TargetType {
    var baseURL: URL {
        return URL(string: "http://www.omdbapi.com")!
    }
    
    var path: String {
        return "/"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .searchMovie(let keyword, let page):
            let param: [String: Any] = [
                "s": keyword,
                "apikey": "e404bf91",
                "page": page,
                "type": "movie"
            ]
            
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}
