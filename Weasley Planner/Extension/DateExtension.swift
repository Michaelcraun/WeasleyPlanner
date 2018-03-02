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
        formatter.dateFormat = "h:mm a"
        
        return formatter.string(from: self)
    }
    
    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        return dateFormatter.string(from: self)
    }
}
