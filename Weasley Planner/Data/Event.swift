//
//  Event.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation

enum EventType: String {
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
    var location: CLLocation?
    var date: Date
    var identifier: String
    var locationString: String?
    var title: String
    var type: EventType
    
    init(assignedUser: User? = nil, location: CLLocation? = nil, date: Date, locationString: String? = nil, title: String, type: EventType, identifier: String) {
        self.assignedUser = assignedUser
        self.location = location
        self.date = date
        self.locationString = locationString
        self.title = title
        self.type = type
        self.identifier = identifier
    }
    
    func eventView() -> UIView {
        let eventView: UIView = {
            let view = UIView()
            
            let timeView: UIView = {
                let view = UIView()
                view.backgroundColor = .clear
                
                let timeLabel: UILabel = {
                    let label = UILabel()
                    label.font = UIFont(name: fontName, size: smallFontSize)
                    label.textAlignment = .center
                    label.text = self.date.formatForDisplayOfTime()
                    return label
                }()
                
                let colorView: UIView = {
                    let view = UIView()
                    view.backgroundColor = self.type.color
                    view.alpha = 0.75
                    return view
                }()
                
                view.addSubview(colorView)
                view.addSubview(timeLabel)
                
                colorView.anchor(top: view.topAnchor,
                                 trailing: view.trailingAnchor,
                                 bottom: view.bottomAnchor,
                                 size: .init(width: 2, height: 0))
                
                timeLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: colorView.leadingAnchor,
                                 bottom: view.bottomAnchor)
                
                return view
            }()
            
            let userIconView: UIImageView = {
                let imageView = UIImageView()
                imageView.anchor(size: .init(width: 60, height: 60))
                imageView.image = {
                    guard let user = self.assignedUser else { return #imageLiteral(resourceName: "defaultProfileImage") }
                    return user.icon
                }()
                imageView.addBorder()
                imageView.layer.cornerRadius = 30
                return imageView
            }()
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = self.title
                label.textColor = secondaryTextColor
                return label
            }()
            
            let locationLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.textColor = secondaryTextColor
                label.text = {
                    guard let locationString = self.locationString else { return "" }
                    return locationString
                }()
                return label
            }()
            
            if assignedUser == nil {
                view.addSubview(timeView)
                view.addSubview(titleLabel)
                view.addSubview(locationLabel)
                
                timeView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                size: .init(width: 60, height: 0))
                
                titleLabel.anchor(top: view.topAnchor,
                                  leading: timeView.trailingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 2, left: 2, bottom: 0, right: 2))
                
                locationLabel.anchor(top: titleLabel.bottomAnchor,
                                     leading: timeView.trailingAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: .init(top: 2, left: 2, bottom: 2, right: 2))
            } else {
                view.addSubview(timeView)
                view.addSubview(userIconView)
                view.addSubview(titleLabel)
                view.addSubview(locationLabel)
                
                timeView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                size: .init(width: 60, height: 0))
                
                userIconView.anchor(leading: timeView.trailingAnchor,
                                    centerY: view.centerYAnchor,
                                    padding: .init(top: 0, left: 5, bottom: 0, right: 0))
                
                titleLabel.anchor(top: view.topAnchor,
                                  leading: timeView.trailingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 2, left: 2, bottom: 0, right: 2))
                
                locationLabel.anchor(top: titleLabel.bottomAnchor,
                                     leading: timeView.trailingAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: .init(top: 2, left: 2, bottom: 2, right: 2))
            }
            return view
        }()
        return eventView
    }
    
    func dictionary() -> [String : Any] {
        var eventDictionary = [String : Any]()
        eventDictionary["date"] = self.date
        eventDictionary["title"] = self.title
        eventDictionary["type"] = self.type.rawValue
        
        eventDictionary["user"] = {
            guard let eventUser = self.assignedUser else { return "none" }
            return eventUser.name
        }()
        
        eventDictionary["location"] = {
            guard let eventLocation = self.location else { return [] }
            let locationArray = [eventLocation.coordinate.latitude, eventLocation.coordinate.longitude]
            return locationArray
        }()
        
        eventDictionary["locationString"] = {
            guard let eventLocationString = self.locationString else { return "none" }
            return eventLocationString
        }()
        
        return eventDictionary
    }
}
