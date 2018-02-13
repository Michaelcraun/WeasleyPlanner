//
//  Event.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation

enum EventType {
    case appointment
    case chore
    case meal
    
    var color: UIColor {
        switch self {
        case .appointment: return UIColor.red
        case .chore: return UIColor.green
        case .meal: return UIColor.blue
        }
    }
}

class Event {
    var assignedUser: User?
    var coordinate: CLLocationCoordinate2D?
    var date: Date?
    var location: String?
    var name: String?
    var type: EventType?
    
    init(assignedUser: User? = nil, coordinate: CLLocationCoordinate2D? = nil, date: Date, location: String? = nil, name: String, type: EventType) {
        self.assignedUser = assignedUser
        self.coordinate = coordinate
        self.date = date
        self.location = location
        self.name = name
        self.type = type
    }
}
