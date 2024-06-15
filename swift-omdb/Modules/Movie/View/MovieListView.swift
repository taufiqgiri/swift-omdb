//
//  MovieListView.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit
import RealmSwift

class MovieListView: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchField: SearchField!
    
    internal var viewModel: MovieViewModel = MovieViewModel()
    internal let realm = try! Realm()
    internal var movieCaches: [MovieCacheModel] = []
    internal var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }

    private func setupView() {
        self.view.backgroundColor = .black
        welcomeLabel.text = "Welcome 👋"
        onboardingLabel.text = "Let's relax and watch a movie!"
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.self))
        
        searchField.delegate = self
        loadMovieCache()
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.getMovieList(keyword: "movie", isInitialLoad: true)
    }
    
    private func loadMovieCache() {
        var newMovies: [MovieModel] = []
        let movies = realm.objects(MovieCacheModel.self)
        
        movies.forEach {
            movieCaches.append($0)
            
            var movie = MovieModel(dict: [:])
            movie?.Title = $0.Title
            movie?.Poster = $0.Poster
            movie?.imdbID = $0.imdbID
            
            newMovies.append(movie!)
        }
        
        viewModel.movies = newMovies
        movieCollectionView.reloadData()
    }
    
    private func createLoadingView() -> UIView {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.7)

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .red
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        return loadingView
    }
    
    private func showLoadingView() {
        if loadingView == nil {
            loadingView = createLoadingView()
        }
        
        if let loadingView = loadingView {
            view.addSubview(loadingView)
        }
    }
    
    private func hideLoadingView() {
        loadingView?.removeFromSuperview()
    }
}

extension MovieListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MovieCell",
            for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        cell.bindData(data: viewModel.movies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 5, height: 300)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            if !viewModel.isFetchingData && !viewModel.isEndOfPage {
                viewModel.getMovieList(keyword: viewModel.latestKeyword)
            }
        }
    }
}

extension MovieListView: MovieViewModelDelegate {
    func didSuccessLoadMovie(isInitialLoad: Bool) {
        if isInitialLoad {
            showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideLoadingView()
            }
        }
        saveMovieCache()
        movieCollectionView.reloadData()
    }
    
    private func saveMovieCache() {
        if movieCaches.isEmpty {
            var movieList: [MovieCacheModel] = []
            viewModel.movies.enumerated().forEach { index, movie in
                let newMovie = MovieCacheModel()
                newMovie.Title = movie.Title ?? ""
                newMovie.Poster = movie.Poster ?? ""
                newMovie.imdbID = movie.imdbID ?? ""
                
                movieList.append(newMovie)
            }
            
            try! realm.write {
                realm.add(movieList)
            }
        }
    }
    
    func didFailLoadMovie() {
        if !viewModel.isEndOfPage {
            let alert = UIAlertController(title: "Error", message: viewModel.errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MovieListView: SearchFieldDelegate {
    func didIdleTyping() {
        if searchField.text.count >= 3 {
            viewModel.getMovieList(keyword: searchField.text)
        }
    }
    
    func didEndEditing() {
        if searchField.text.count >= 3 {
            viewModel.getMovieList(keyword: searchField.text)
        }
    }
}
