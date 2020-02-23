//
//  Constants.swift
//  RecipeApp
//
//  Created by Phu Nguyen on 2/22/20.
//  Copyright © 2020 The Vis. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct File {
        static let receipTypeName = "recipetypes"
        static let receipsName     = "receips"
        static let receipTypeExtension = "xml"
        static let receipsExtension = "json"
    }
    
    struct SegueName {
        static let showDetailSegueIdentifier = "showReceipDetail"
        static let addAttributesSegueIdentifier = "addAttributes"
    }
    
    struct Names {
        static let appName = "Receip App"
        static let placeholder = "placeholder"
    }
    
    struct Margins {
        static let horizonal: CGFloat = 20.0
    }
}


enum FileManagerError: Error {
    case readFileError
    case missingFileName
    case copyFileError
    case saveFileError
}
