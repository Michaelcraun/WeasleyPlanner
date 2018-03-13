//
//  Item.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

/// Represents a single shopping list item to be created and stored on Firebase and displayed to the user.
/// - important: Only the item name must be declared at the time of initialization. All other values have
/// defaults.
class Item {
    var quantity: String
    var unitOfMeasurement: UnitOfMeasurement?
    var name: String
    var obtained: Bool
    
    /// The initializer for the Item class
    /// - parameter quantity: A String value representing the quantity of the Item needed (defaults to an empty
    /// String). This parameter is represented as a String value, due to the possibility of fractions
    /// - parameter name: A String value representing the name of the Item needed
    /// - parameter obtained: A Boolean value representing whether or not the item has been obtained (defaults
    /// to false)
    init(quantity: String = "", unitOfMeasurement: UnitOfMeasurement? = nil, name: String, obtained: Bool = false) {
        self.quantity = quantity
        self.unitOfMeasurement = unitOfMeasurement
        self.name = name
        self.obtained = obtained
    }
    
    /// Creates a Dictionary representation of an item to store on Firebase
    /// - returns: A Dictionary value that contains all of the Item information
    func dictionary() -> [String : Any] {
        var itemDictionary = [String : Any]()
        itemDictionary["quantity"] = self.quantity
        itemDictionary["name"] = self.name
        itemDictionary["obtained"] = self.obtained
        itemDictionary["measurement"] = {
            guard let measurement = self.unitOfMeasurement else { return "none" }
            guard let quantity = Int(self.quantity), quantity != 0 else { return measurement.rawValue }
            if quantity > 1 { return measurement.pluralRepresentation }
            return measurement.rawValue
        }()
        return itemDictionary
    }
    
    /// Creates a String representation of an item to be displayed on user's family shopping list
    /// - returns: A String value that represents an Item
    func stringRepresentation() -> String {
        var itemString = ""
        
        if self.quantity != "" || self.quantity != "0" { itemString = "\(self.quantity) " }
        if let unit = unitOfMeasurement {
            if let quantityInt = Int(self.quantity) {
                switch quantityInt {
                case 0...1: itemString += "\(unit.rawValue) "
                default: itemString += "\(unit.pluralRepresentation) "
                }
            } else {
                //TODO: Handle for fractions and decimals
            }
        }
        itemString += self.name
        
        return itemString
    }
}
