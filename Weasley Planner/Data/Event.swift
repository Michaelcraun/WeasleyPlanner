//
//  Event.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation

/// An enumeration of event types
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

/// Represents a single event to be created and stored on Firebase and displayed to the user.
/// - important: The Event date, identifier, title, and type must be declared at the time initialization.
/// All other values are optional.
class Event {
    var assignedUser: User?
    var location: CLLocation?
    var date: Date
    var identifier: String
    var locationString: String?
    var recurrenceString: String?
    var title: String
    var type: EventType
    
    /// The initializer for the Event class
    /// - parameter assignedUser: The optional User value that has been assigned to complete the specified
    /// Event (defaults to nil)
    /// - parameter location: The optional CLLocation value that represents the location where the Event
    /// is to take place (defaults to nil)
    /// - parameter date: The Date value that represents when the Event is to take place
    /// - parameter locationString: The optinal String value that represents the physical address of where
    /// the event is to take place (defaults to nil)
    /// - parameter recurrenceString: The optional String value that represents the recurrence of a specific
    /// Event (defaults to nil)
    /// - parameter title: The String value that represents the title of the Event
    /// - parameter type: The EventType value that represents the type of Event
    /// - parameter identifier: The String value that represents the unique identifier of the specified Event
    init(assignedUser: User? = nil, location: CLLocation? = nil, date: Date, locationString: String? = nil, recurrenceString: String? = nil, title: String, type: EventType, identifier: String) {
        self.assignedUser = assignedUser
        self.location = location
        self.date = date
        self.locationString = locationString
        self.recurrenceString = recurrenceString
        self.title = title
        self.type = type
        self.identifier = identifier
    }
    
    /// Creates a view for a given event to be displayed for the user in CalendarVC
    /// - returns: A UIView that displays the event's assignedUser, date, locationString, title, and type (as
    /// a specific color)
    func eventView() -> UIView {
        let eventView: UIView = {
            let view = UIView()
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.backgroundColor = secondaryColor
            view.layer.cornerRadius = 5
            
            let timeView: UIView = {
                let view = UIView()
                view.backgroundColor = .clear
                
                let timeLabel: UILabel = {
                    let label = UILabel()
                    label.font = UIFont(name: secondaryFontName, size: 10)
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
                                 size: .init(width: 5, height: 0))
                
                timeLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: colorView.leadingAnchor,
                                 bottom: view.bottomAnchor)
                
                return view
            }()
            
            let userIconView: UIImageView = {
                let imageView = UIImageView()
                imageView.addBorder()
                imageView.layer.cornerRadius = 25
                imageView.image = {
                    guard let user = self.assignedUser else { return #imageLiteral(resourceName: "defaultProfileImage") }
                    return user.icon
                }()
                return imageView
            }()
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallFontSize)
                label.text = self.title
                label.textColor = secondaryTextColor
                return label
            }()
            
            let locationLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallestFontSize)
                label.numberOfLines = 0
                label.textColor = primaryColor
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
                                  padding: .init(top: 5, left: 5, bottom: 0, right: 5))
                
                locationLabel.anchor(top: titleLabel.bottomAnchor,
                                     leading: timeView.trailingAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            } else {
                view.addSubview(timeView)
                view.addSubview(userIconView)
                view.addSubview(titleLabel)
                view.addSubview(locationLabel)
                
                timeView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                size: .init(width: 60, height: 0))
                
                userIconView.anchor(top: view.topAnchor,
                                    leading: timeView.trailingAnchor,
                                    bottom: view.bottomAnchor,
                                    centerY: view.centerYAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                    size: .init(width: 50, height: 0))
                
                titleLabel.anchor(top: view.topAnchor,
                                  leading: userIconView.trailingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 5, left: 5, bottom: 0, right: 5))
                
                locationLabel.anchor(top: titleLabel.bottomAnchor,
                                     leading: userIconView.trailingAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            }
            return view
        }()
        return eventView
    }
    
    /// Creates a Dictionary of a given event to store on Firebase
    /// - returns: A Dictionary of type [String : Any] that represents the information contained within a recipe
    func dictionary() -> [String : Any] {
        var eventDictionary = [String : Any]()
        eventDictionary["date"] = self.date.string()
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
        
        eventDictionary["recurrenceString"] = {
            guard let recurrenceString = self.recurrenceString else { return "none" }
            return recurrenceString
        }()
        
        return eventDictionary
    }
}
