//
//  Constants.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

//MARK: UI Constants
let primaryColor = UIColor(red: 91 / 255, green: 72 / 255, blue: 47 / 255, alpha: 1)
let secondaryColor = UIColor(red: 219 / 255, green: 202 / 255, blue: 179 / 255, alpha: 1)

let primaryTextColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
let secondaryTextColor = UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1)
let fontName = "Harry P"
let largeFontSize: CGFloat = 30.0
let mediumFontSize: CGFloat = 25.0
let smallFontSize: CGFloat = 20.0

//MARK: Layout constants
var topBannerHeight: CGFloat {
    switch UIDevice.current.modelName {
    case "iPhone X": return 108
    default: return 70
    }
}
