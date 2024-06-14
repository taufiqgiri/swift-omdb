//
//  ViewController.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.showRootViewController(rootViewController: BaseNavigationController(rootViewController: MovieListView()))
    }


}

