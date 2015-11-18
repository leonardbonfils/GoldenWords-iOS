//
//  MyGlobalVariables.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-21.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import Foundation
import UIKit

// Base API URL

struct MyGlobalVariables {
    static var baseURL = "http://goldenwords.ca/api/get"
    static var goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)

}

extension UIColor {
    
    class func goldenWordsYellow() -> UIColor {
        return UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    }
}