//
//  MovieListView.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit

class MovieListView: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var onboardingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.view.backgroundColor = .black
        welcomeLabel.text = "Welcome 👋"
        onboardingLabel.text = "Let's relax and watch a movie!"
    }

}
