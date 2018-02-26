//
//  DateExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/23/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Date {
    func formatForDisplayOfTime() -> String {
        let formatter = DateFormatter()
        var hours = 0
        var minutes = 0
        var appendage = "a"
        
        formatter.dateFormat = "HH"
        let hoursString = formatter.string(from: self)
        if let numHours = Int(hoursString) {
            if numHours > 12 {
                hours = numHours - 12
                appendage = "p"
            }
        }
        
        formatter.dateFormat = "mm"
        let minutesString = formatter.string(from: self)
        if let numMinutes = Int(minutesString) { minutes = numMinutes }
        
        return "\(hours):\(minutes)\(appendage)"
    }
}
