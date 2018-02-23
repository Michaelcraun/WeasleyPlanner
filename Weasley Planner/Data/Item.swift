//
//  Item.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

class Item {
    var quantity: String
    var name: String
    var obtained: Bool
    
    init(quanity: String = "", name: String, obtained: Bool = false) {
        self.quantity = quanity
        self.name = name
        self.obtained = obtained
    }
}
