//
//  ErrorModel.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Foundation

struct ErrorModel {
    var message: String?
    
    init(message: String? = nil) {
        self.message = message
    }
        
    func isConnectionIssue() -> Bool {
        if self.message?.contains("InternetConnectionError") == true {
            return true
        }
        
        return false
    }
}
