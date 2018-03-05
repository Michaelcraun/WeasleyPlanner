//
//  DateExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/23/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Date {
    /// Formats a given Date for displaying only the time
    /// - returns: A String representation of the given Date, displayed only as time (i.e., 2018-03-05T02:30:58+0000
    /// would display as "2:30 AM")
    func formatForDisplayOfTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        return formatter.string(from: self)
    }
    
    /// Formats a given date as a String representation
    /// - returns: A full String representation of the given date (i.e., 2018-03-05T02:30:58+0000 would display as
    /// "March 05, 2018 2:30 AM")
    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        return dateFormatter.string(from: self)
    }
}
