//
//  MyGlobalVariables.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-21.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import Foundation
import UIKit

// Declaring variables to be used globally within the app.
struct MyGlobalVariables {
    static var baseURL = "http://goldenwords.ca/api/get"
    static var loadingIndicatorColor = UIColor.opaqueGoldenWordsYellow()
    static var viewControllerToDisplay = ""

}

// Extending UIColor to include goldenWordsYellow
extension UIColor {
    
    class func goldenWordsYellow() -> UIColor {
        return UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    }
    
    class func opaqueGoldenWordsYellow() -> UIColor {
        return UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 1.0)
    }
}

// Extending UIViewController to include a function to fetch CoreData entities (articles) for the Saved Articles view
extension UIViewController {
    
    
}