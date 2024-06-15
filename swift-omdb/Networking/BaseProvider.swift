//
//  BaseProvider.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import Foundation
import Moya

class BaseProvider<T: TargetType>: MoyaProvider<T> {
    final class func endpointClosure (target: T) -> Endpoint {
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint
    }
    
    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = BaseProvider.endpointClosure,
                  requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure,
                   callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
    }
    
    @discardableResult
    override func request(_ target: Target,
                          callbackQueue: DispatchQueue? = .none,
                          progress: ProgressBlock? = .none,
                          completion: @escaping Completion) -> Cancellable {
        return request(target,
                       callbackQueue: callbackQueue,
                       progress: progress,
                       handleSession: true,
                       completion: completion)
    }
    
    @discardableResult
    func request(_ target: Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none,
                 handleSession: Bool = true,
                 completion: @escaping Completion) -> Cancellable {
        switch Reach().connectionStatus() {
        case .offline:
            let errorResponse: Result<Response, MoyaError> = .failure(.underlying(InternetConnectionError(), nil))
            completion(errorResponse)
            let cancelProv = CancelProvider()
            cancelProv.cancel()
            return cancelProv
        case .online:
            let response = super.request(target, callbackQueue: callbackQueue, progress: progress, completion: { result in
                switch result {
                case .success(let response):
                    completion(result)
                case .failure(let error):
                    completion(result)
                }
            })
            
            return response
        default:
            let errorResponse: Result<Response, MoyaError> = .failure(.underlying(InternetConnectionError(), nil))
            completion(errorResponse)
            let cancelProv = CancelProvider()
            cancelProv.cancel()
            return cancelProv
        }
    }
}

struct InternetConnectionError: LocalizedError {
    var errorDescription = "Check your internet connection"
}

class CancelProvider: Cancellable {
    var isCancelled: Bool = false
    
    func cancel() {
        isCancelled = true
    }
}
