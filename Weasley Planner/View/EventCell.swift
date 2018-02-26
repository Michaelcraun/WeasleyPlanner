//
//  EventCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/23/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    
}

class EventTableCell: UITableViewCell {
    var event: Event?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    
}
