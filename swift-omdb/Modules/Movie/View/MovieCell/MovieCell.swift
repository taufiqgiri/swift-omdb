//
//  MovieCell.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 15/06/24.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        titleLabel.text = nil
    }

    private func setupView() {
        movieImageView.layer.cornerRadius = 10
    }
    
    func bindData(data: MovieModel) {
        if let url = URL(string: data.Poster ?? "") {
            movieImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "movieclapper.fill"))
        }
        
        titleLabel.text = data.Title
    }
}
