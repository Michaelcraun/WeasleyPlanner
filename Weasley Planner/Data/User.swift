//
//  User.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit
import Firebase

/// Represents a single user to be created and stored on Firebase and displayed to the user.
/// - important: All values are optional
class User {
    var coordinate: CLLocationCoordinate2D?
    var family: String?
    var icon: UIImage?
    var isFamilyCreator: Bool
    var name: String?
    var location: String?
    var status: Bool
    var uid: String?
    
    /// The initializer for the User class
    /// - parameter coordinate: The optional CLLocationCoordinate2D value that represents the coordinate of the
    /// specified user (defaults to nil)
    /// - parameter family: The optional String value that represents the user's family (defaults to nil)
    /// - parameter icon: The optional UIImage value that represents the user's chosen image (dfaults to nil)
    /// - parameter isFamilyCreator: A Boolean value that represents if the user has created the user's family
    /// (defaults to false)
    /// - parameter name: The optional String value that represents the specified user's name (defaults to nil)
    /// - parameter location: The optional String value that represents the specified user's physical address
    /// (defaults to nil)
    /// - parameter status: A Boolean value that represents whether the user is currently logged in or not
    /// (defaults to false)
    /// - parameter uid: The String value that represents the user's unique identifier
    init(coordinate: CLLocationCoordinate2D? = nil, family: String? = nil, icon: UIImage? = nil, isFamilyCreator: Bool = false, name: String? = nil, location: String? = nil, status: Bool = false, uid: String? = nil) {
        self.coordinate = coordinate
        self.icon = icon
        self.isFamilyCreator = isFamilyCreator
        self.name = name
        self.location = location
        self.status = status
        self.family = family
        self.uid = uid
    }
    
    /// Creates an MKAnnotationView for a specific user, using that user's image
    /// - returns: An MKAnnotationView that represents the specified user
    func annotationViewForUser() -> MKAnnotationView {
        let userAnnotation = MKAnnotationView()
        userAnnotation.addBorder()
        userAnnotation.layer.cornerRadius = 15
        
        userAnnotation.backgroundColor = secondaryColor
        userAnnotation.image = icon?.resizeImage(CGSize(width: 30, height: 30))
        
        return userAnnotation
    }
}

/// The MKAnnotation object to be used in the map view
class UserAnnotaion: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var user: User
    
    init(coordinate: CLLocationCoordinate2D, user: User) {
        self.coordinate = coordinate
        self.user = user
        
        super.init()
    }
    
    func update(_ annotation: UserAnnotaion, withCoordinate coordinate: CLLocationCoordinate2D) {
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
    }
}
