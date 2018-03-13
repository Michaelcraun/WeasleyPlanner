//
//  StringExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/15/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension String {
    func quantity() -> String {
        var numAsString = ""
        
        for character in self {
            if character == "/" || character == "." {
                numAsString += "\(String(character))"
            } else {
                guard let number = Int(String(character)), number != 0 else { break }
                numAsString += "\(number)"
            }
        }
        return numAsString
    }
    
    func measurement() -> UnitOfMeasurement? {
        var stringParts = [String.SubSequence]()
        if self.contains("|") {
            stringParts = self.split(separator: "|")
        } else {
            stringParts = self.split(separator: " ")
        }
        
        let measurement = String(stringParts[0])
        if let unit = UnitOfMeasurement(rawValue: measurement) { return unit }
        return nil
    }
    
    func trimming(quantity: String, andMeasurement unit: UnitOfMeasurement?) -> String {
        var itemNameString = self
        
        if quantity != "" {
            let quantityCharacterCount = quantity.count + 1
            itemNameString.removeFirst(quantityCharacterCount)
        }
        
        if let unit = unit {
            let unitRawValue = unit.rawValue
            let unitCharacterCount = unitRawValue.count + 1
            itemNameString.removeFirst(unitCharacterCount)
        }
        return itemNameString
    }
    
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        return dateFormatter.date(from: self)
    }
}
