//
//  User.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit

class User {
    var coordinate: CLLocationCoordinate2D?
    var family: String?
    var icon: UIImage?
    var isFamilyCreator: Bool
    var name: String?
    var location: String?
    var status: Bool
    var uid: String?
    
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
    
    func annotationViewForUser() -> MKAnnotationView {
        let userAnnotation = MKAnnotationView()
        userAnnotation.layer.borderColor = primaryColor.cgColor
        userAnnotation.layer.borderWidth = 1
        userAnnotation.layer.cornerRadius = 15
        
        userAnnotation.backgroundColor = secondaryColor
        userAnnotation.clipsToBounds = true
        userAnnotation.image = icon?.resizeImage(CGSize(width: 30, height: 30))
        
        return userAnnotation
    }
}

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
