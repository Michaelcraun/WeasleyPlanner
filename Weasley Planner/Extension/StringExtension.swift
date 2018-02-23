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
    
    func trimmingQunatity(_ quantity: String) -> String {
        var stringWithoutQuantity = self
        
        if quantity != "" {
            let quantityCharacterCount = quantity.count + 1
            stringWithoutQuantity.removeFirst(quantityCharacterCount)
        }
        return stringWithoutQuantity
    }
    
    func adding(_ addition: String) -> String {
        if self.contains("/") || addition.contains("/") {
            let quantityParts = getNumeratorAndDenominatorFrom(self)
            let additionParts = getNumeratorAndDenominatorFrom(addition)
            findCommonDenominators(withFractions: [quantityParts, additionParts])
            
            return ""
        } else if self.contains(".") || addition.contains(".") {
            guard let quantityDouble = Double(self), quantityDouble != 0.0 else { return "2" }
            guard let additionDouble = Double(addition), additionDouble != 0.0 else { return "2" }
            return "\(quantityDouble + additionDouble)"
        } else {
            guard let quantityInt = Int(self), quantityInt != 0 else { return "2" }
            guard let additionInt = Int(addition), additionInt != 0 else { return "2" }
            return "\(quantityInt + additionInt)"
        }
    }
    
    private func getNumeratorAndDenominatorFrom(_ fraction: String) -> [Int] {
        if fraction.contains("/") {
            let fractionParts = fraction.split(separator: "/")
            guard let fractionNum = Int(fractionParts[0]) else { return [] }
            guard let fractionDen = Int(fractionParts[1]) else { return [] }
            return [fractionNum, fractionDen]
        } else {
            guard let fractionNumAndDen = Int(fraction) else { return [] }
            return [fractionNumAndDen, fractionNumAndDen]
        }
    }
    
    private func findCommonDenominators(withFractions fractions: [[Int]]) -> [Int] {
        return []
    }
    
    private func addFractions(_ fractions: [[Int]]) -> [[Int]] {
        return []
    }
    
    private func reduceFractions(_ fractions: [[Int]]) -> [Int] {
        return []
    }
}
