//
//  User.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class User {
    var family: String?
    var icon: UIImage?
    var name: String?
    var location: String?
    var status: Bool
    
    init(family: String? = nil, icon: UIImage? = nil, name: String? = nil, location: String? = nil, status: Bool = false) {
        self.icon = icon
        self.name = name
        self.location = location
        self.status = status
        self.family = family
    }
}
