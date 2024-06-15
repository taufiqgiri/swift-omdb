//
//  Utils.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit

struct Utils {
    static func showRootViewController(rootViewController: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = rootViewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
