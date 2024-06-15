//
//  APIMappingProtocol.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Moya

protocol APIMappingProtocol {}

extension APIMappingProtocol {
//    func handleResult<T: NullableMap>(_ result: Result<Moya.Response, MoyaError>,
//                                      typeResponse: T.Type,
//                                      onSuccess: ((BaseResponseModel<T>) -> Void)?,
//                                      onFailure: ((Error) -> Void)? ) {
//        switch result {
//        case .success(let response):
//            self.mapResponse(response, type: typeResponse, onSuccess: onSuccess, onFailure: onFailure)
//        case .failure(let error):
//            onFailure?(error)
//        }
//    }
//    
//    private func mapResponse<T: NullableMap>(_ response: Moya.Response,
//                                             type: T.Type,
//                                             onSuccess: ((BaseResponseModel<T>) -> Void)?,
//                                             onFailure: ((Error) -> Void)? ) {
//        DispatchQueue(label: "map_queue").async {
//            do {
//                let response = try JSONDecoder().decode(BaseResponseModel<T>.self, from: response.data)
//                DispatchQueue.main.async { onSuccess?(response) }
//            } catch {
//                DispatchQueue.main.async { onFailure?(error) }
//            }
//        }
//    }
    
    func handleResult<T: NullableMap>(_ result: Result<Moya.Response, MoyaError>,
                                      typeResponse: T.Type,
                                      onSuccess: ((BaseResponseListModel<T>) -> Void)?,
                                      onFailure: ((Error) -> Void)? ) {
        switch result {
        case .success(let response):
            self.mapResponse(response, type: typeResponse, onSuccess: onSuccess, onFailure: onFailure)
        case .failure(let error):
            onFailure?(error)
        }
    }
    
    private func mapResponse<T: NullableMap>(_ response: Moya.Response,
                                             type: T.Type,
                                             onSuccess: ((BaseResponseListModel<T>) -> Void)?,
                                             onFailure: ((Error) -> Void)? ) {
        DispatchQueue(label: "map_queue").async {
            do {
                let response = try JSONDecoder().decode(BaseResponseListModel<T>.self, from: response.data)
                DispatchQueue.main.async { onSuccess?(response) }
            } catch {
                DispatchQueue.main.async { onFailure?(error) }
            }
        }
    }
}

enum CommonError: Error {
    case mappingError
    
    var message: String {
        switch self {
        case .mappingError:
            return "No data or errors successfully mapped!"
        }
    }
}
