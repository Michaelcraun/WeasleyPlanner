//
//  Constants.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

//MARK: - UI Constants
let primaryColor = UIColor(red: 91 / 255, green: 72 / 255, blue: 47 / 255, alpha: 1)
let secondaryColor = UIColor(red: 219 / 255, green: 202 / 255, blue: 179 / 255, alpha: 1)
let primaryTextColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
let secondaryTextColor = UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1)

let fontName = "Harry P"
let secondaryFontName = "Copperplate"

let largeFontSize: CGFloat = 30.0
let mediumFontSize: CGFloat = 25.0
let smallFontSize: CGFloat = 20.0
let smallerFontSize: CGFloat = 15.0
let smallestFontSize: CGFloat = 10.0

//MARK: - Layout Constants
var topBannerHeight: CGFloat {
    switch UIDevice.current.modelName {
    case "iPhone X": return 108
    default: return 78
    }
}

//MARK: - Data Constants
let ad = UIApplication.shared.delegate as! AppDelegate

/// The calculated bounds of the calendar in string format. This computed variable calculates the date one year
/// ago from today, starting at the first day of the year, and the date five years from now, ending on the last
/// day of the year and returns an Array of type String with two values: the first being the beginning of the
/// calendar range and the second being the end of the calendar range.
var calendarBounds: [String] {
    let calendar = Calendar.current
    let today = Date()
    let todayYear = calendar.component(.year, from: today)
    let oneYearAgo = todayYear - 1
    let oneYearFromNow = todayYear + 1
    let yearAgoString = "01 01 \(oneYearAgo)"
    let oneYearString = "12 31 \(oneYearFromNow)"
    let calendarBounds = [yearAgoString, oneYearString]
    return calendarBounds
}

//MARK: - Delegate Constants
let mapManager: MapDelegate = {
    var delegate = MapDelegate()
    DispatchQueue.main.async { delegate = MapDelegate() }
    return delegate
}()
let photoManager = PhotoDelegate()
let textManager = TextDelegate()
