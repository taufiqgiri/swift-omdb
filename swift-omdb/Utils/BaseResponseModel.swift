//
//  BaseResponseModel.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Foundation

struct BaseResponseListModel<T>: NullableMap where T: NullableMap {
    var Error: String?
    var Search: [T]?
    var totalResults: String?
    var Response: String?
    
    init?(dict: [String : Any]?) {
        guard let dict else { return nil }
        Error = dict["Error"] as? String
        if let dataArray = dict["Search"] as? [[String: Any]] {
            Search = dataArray.compactMap({ T(dict: $0) })
        }
        totalResults = dict["totalResults"] as? String
        Response = dict["Response"] as? String
    }
    
    func dictionary() -> [String : Any]? {
        var dict: [String: Any] = [:]
        dict["Error"] = Error
        dict["Search"] = Search?.compactMap({$0.dictionary()})
        dict["totalResults"] = totalResults
        dict["Response"] = Response
        return dict
    }
    
    func mapErrorModel() -> ErrorModel {
        let errorModel = ErrorModel(message: Error)
        
        return errorModel
    }
}
