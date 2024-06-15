//
//  MovieService.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Foundation

protocol MovieServiceProtocol {
    func getMovieList(keyword: String,
                      page: Int,
                      onSuccess: ((BaseResponseListModel<MovieModel>) -> Void)?,
                      onFailure: ((Error) -> Void)?)
}

class MovieService: MovieServiceProtocol, APIMappingProtocol {
    let provider: BaseProvider<MovieProvider>
    
    init(provider: BaseProvider<MovieProvider> = BaseProvider<MovieProvider>()) {
        self.provider = provider
    }
    
    func getMovieList(keyword: String, page: Int, onSuccess: ((BaseResponseListModel<MovieModel>) -> Void)?, onFailure: ((any Error) -> Void)?) {
        provider.request(.searchMovie(keyword: keyword, page: page)) { [weak self] result in
            guard let self else { return }
            
            self.handleResult(result,
                              typeResponse: MovieModel.self,
                              onSuccess: onSuccess,
                              onFailure: onFailure)
        }
    }
}
