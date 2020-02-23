//
//  Receip.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

enum ReceipState: Int, Codable {
    case new
    case added
    case updating
}

class Receip: Codable {
    var name: String = ""
    var type: ReceipType
    var ingredients: [Ingredient]
    var steps: [String]
    var imageName: String
    
    var localURL: String = ""
    var state: ReceipState = .added
    
    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case ingredients
        case steps
        case imageName
        
        case localURL
        case state
    }
    
    init(_ name: String) {
        self.name = name
        self.type = ReceipType("Click to change receip type")
        self.ingredients = []
        self.steps = []
        self.imageName = ""
        self.state = .new
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name        = try container.decode(String.self, forKey: .name)
        type        = try container.decode(ReceipType.self, forKey: .type)
        ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        steps       = try container.decode([String].self, forKey: .steps)
        imageName   = try container.decode(String.self, forKey: .imageName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(steps, forKey: .steps)
        try container.encode(imageName, forKey: .imageName)
        
        try container.encode(localURL, forKey: .localURL)
        try container.encode(state, forKey: .state)
    }

}
