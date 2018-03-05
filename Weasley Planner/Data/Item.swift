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
    var name: String
    var obtained: Bool
    
    /// The initializer for the Item class
    /// - parameter quantity: A String value representing the quantity of the Item needed (defaults to an empty
    /// String). This parameter is represented as a String value, due to the possibility of fractions
    /// - parameter name: A String value representing the name of the Item needed
    /// - parameter obtained: A Boolean value representing whether or not the item has been obtained (defaults
    /// to false)
    init(quantity: String = "", name: String, obtained: Bool = false) {
        self.quantity = quantity
        self.name = name
        self.obtained = obtained
    }
}
