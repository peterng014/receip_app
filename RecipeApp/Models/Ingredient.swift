//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

struct Ingredient: Codable {
    var quantity: String
    var name: String
    var type: String
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        return "Name: \(name)\nQuantity: \(quantity)"
    }
}
