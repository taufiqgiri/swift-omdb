//
//  MovieViewModel.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import Foundation

protocol MovieViewModelDelegate: AnyObject {
    func didSuccessLoadMovie(isInitialLoad: Bool)
    func didFailLoadMovie()
}

class MovieViewModel {
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    weak var delegate: MovieViewModelDelegate?
    
    var page = 1000
    var movies: [MovieModel] = []
    var errorMessage: String?
    var latestKeyword: String = ""
    var isFetchingData = false
    var isEndOfPage = false
    
    func getMovieList(keyword: String, isInitialLoad: Bool = false) {
        isFetchingData = true
        if keyword != latestKeyword {
            page = 1
            isEndOfPage = false
        }
        
        errorMessage = nil
        service.getMovieList(keyword: keyword, page: page) { [weak self] result in
            guard let self else { return }
            
            isFetchingData = false
            if result.Response == "True" {
                if self.page == 1 {
                    self.movies = result.Search ?? []
                } else {
                    self.movies.append(contentsOf: result.Search ?? [])
                }
                
                self.page += 1
                latestKeyword = keyword
                self.delegate?.didSuccessLoadMovie(isInitialLoad: isInitialLoad)
            } else {
                self.errorMessage = result.Error
                if latestKeyword == keyword && result.Error?.lowercased().contains("movie not found") == true {
                    isEndOfPage = true
                }
                latestKeyword = keyword
                self.delegate?.didFailLoadMovie()
            }
        } onFailure: { [weak self] error in
            guard let self else { return }
            isFetchingData = false
            self.errorMessage = error.localizedDescription
            latestKeyword = keyword
            self.delegate?.didFailLoadMovie()
        }
    }
}
