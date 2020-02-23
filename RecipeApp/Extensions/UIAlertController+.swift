//
//  UIAlertController+.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/23/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func show(_ message: String, fromController controller: UIViewController) {
        let alert = UIAlertController(title: Constants.Names.appName,
                                      message: message,
                                      preferredStyle: .alert)
        let okaction = UIAlertAction(title: "ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okaction)
        controller.present(alert, animated: true, completion: nil)
    }
}
