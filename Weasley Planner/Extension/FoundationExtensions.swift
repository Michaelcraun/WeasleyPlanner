//
//  FoundationExtensions.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/15/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension String {
    func quantity() -> Int {
        var numAsString = ""
        
        for character in self {
            guard let number = Int(String(character)) else { break }
            if number == 0 {
                break
            } else {
                numAsString += "\(number)"
            }
        }
        
        if let number = Int(numAsString) {
            return number
        } else {
            return 0
        }
    }
    
    func trimmingQunatity(_ quantity: Int) -> String {
        var stringWithoutQuantity = self
        
        if quantity != 0 {
            let quantityAsString = "\(quantity)"
            let quantityCharacterCount = quantityAsString.count + 1
            
            stringWithoutQuantity.removeFirst(quantityCharacterCount)
        }
        return stringWithoutQuantity
    }
}
