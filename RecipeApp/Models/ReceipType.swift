//
//  ReceipType.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation

struct ReceipType: Codable {
    var id: Int             = -1
    var name: String        = ""
    
    init(_ dict: [String: Any]) {
        if let id = dict["id"] as? String {
            self.id = id.intValue
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
    }
    
    init(_ name: String) {
        self.name = name
    }
    
    init(_ id: Int) {
        self.id = id
    }
}
