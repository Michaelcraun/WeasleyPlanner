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
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: smallFontSize)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = secondaryTextColor
        return label
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = primaryColor
        view.isHidden = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let eventView: UIView = {
        let view = UIView()
        view.backgroundColor = primaryColor
        view.isHidden = true
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
        self.addBorder()
    }
    
    func layoutCell() {
        self.addSubview(eventView)
        self.addSubview(selectedView)
        self.addSubview(dayLabel)
        
        eventView.anchor(leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         bottom: self.bottomAnchor,
                         size: .init(width: 0, height: 5))
        
        selectedView.anchor(top: self.topAnchor,
                            centerX: self.centerXAnchor,
                            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                            size: .init(width: 30, height: 30))
        
        dayLabel.anchor(centerX: selectedView.centerXAnchor,
                        centerY: selectedView.centerYAnchor)
    }
}

class EventTableCell: UITableViewCell {
    var event: Event?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    func layoutCell(forEvent event: Event) {
        clearCell()
        self.event = event
        
        let cellView: UIView = {
            let view = event.eventView()
            return view
        }()
        
        self.addSubview(cellView)
        
        cellView.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor)
    }
    
    func layoutCellForNoEvents() {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            
            let noEventsImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                return imageView
            }()
            
            let noEventsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.text = "No Events..."
                label.textAlignment = .center
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(noEventsLabel)
            view.addSubview(noEventsImageView)
            
            noEventsLabel.anchor(leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 bottom: view.bottomAnchor)
            
            noEventsImageView.anchor(top: view.topAnchor,
                                     leading: view.leadingAnchor,
                                     trailing: view.trailingAnchor,
                                     bottom: noEventsLabel.topAnchor,
                                     padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        
        cellView.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor)
    }
}
