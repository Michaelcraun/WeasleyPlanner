//
//  MainFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

extension MainVC {
    func updateUserLocation(_ location: CLLocation) {
        guard let uid = DataHandler.instance.currentUserID else { return }
        let coordinate = [location.coordinate.latitude, location.coordinate.longitude]
        var addressString = ""
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let _ = error { return }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks[0]
            
            if let subThoroughfare = placemark.subThoroughfare {
                addressString = subThoroughfare
            }
            
            if let thoroughfare = placemark.thoroughfare {
                if addressString == "" {
                    addressString = thoroughfare
                } else {
                    addressString += " \(thoroughfare)"
                }
            }
            
            if let locality = placemark.locality {
                if addressString == "" {
                    addressString = locality
                } else {
                    addressString += ", \(locality)"
                }
            }
            
            if let country = placemark.country {
                if addressString == "" {
                    addressString = country
                } else {
                    addressString += ", \(country)"
                }
            }
            
            if let postalCode = placemark.postalCode {
                if addressString == "" {
                    addressString = postalCode
                } else {
                    addressString += ", \(postalCode)"
                }
            }
            
            let userData: Dictionary<String,Any> = ["coordinate" : coordinate,
                                                    "location" : addressString]
            DataHandler.instance.updateFirebaseUser(uid: uid, userData: userData)
        }
    }
    
    func initializeCurrentUser() {
        selfUser = User(status: true)
        DataHandler.instance.REF_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == DataHandler.instance.currentUserID {
                    guard let family = user.childSnapshot(forPath: "family").value as? String else { return }
                    guard let name = user.childSnapshot(forPath: "name").value as? String else { return }
                    guard let imageName = user.childSnapshot(forPath: "imageName").value as? String else { return }
                    
                    self.selfUser.family = family
                    self.selfUser.name = name
                    
                    DataHandler.instance.REF_IMAGE.child("\(imageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                        if let _ = error { return }
                        guard let imageData = data else { return }
                        guard let image = UIImage(data: imageData) else { return }
                        
                        self.selfUser.icon = image
                        self.initializeFamilyUsers()
                    })
                }
            }
        })
        
        DataHandler.instance.REF_USER.observe(.value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == DataHandler.instance.currentUserID {
                    guard let location = user.childSnapshot(forPath: "location").value as? String else { return }
                    self.selfUser.location = location
                }
            }
        })
    }
    
    func initializeFamilyUsers() {
        guard let familyName = selfUser.family, familyName != "" else { return }
        DataHandler.instance.familyUsers = []
        
        DataHandler.instance.REF_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                guard let userFamily = user.childSnapshot(forPath: "family").value as? String else { return }
                if userFamily == familyName {
                    guard let userImageName = user.childSnapshot(forPath: "imageName").value as? String else { return }
                    guard let userName = user.childSnapshot(forPath: "name").value as? String else { return }
                    guard let userLocation = user.childSnapshot(forPath: "location").value as? String else { return }
                    guard let userStatus = user.childSnapshot(forPath: "status").value as? Bool else { return }
                    
                    DataHandler.instance.REF_IMAGE.child("\(userImageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                        if let _ = error { return }
                        guard let imageData = data else { return }
                        guard let image = UIImage(data: imageData) else { return }
                        
                        let newFamilyUser = User(family: familyName, icon: image, name: userName, location: userLocation, status: userStatus, uid: user.key)
                        DataHandler.instance.familyUsers.append(newFamilyUser)
                        self.familyTable.reloadData()
                    })
                }
            }
        })
    }
    
    func observeFamilyUsers() {
        var userToEdit: User?
        
        DataHandler.instance.REF_USER.observe(.value, with: { (snapshot) in
            guard let familyName = self.selfUser.family, familyName != "" else { return }
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                guard let userFamily = user.childSnapshot(forPath: "family").value as? String else { return }
                if userFamily == familyName {
                    guard let userName = user.childSnapshot(forPath: "name").value as? String else { return }
                    var i = 0
                    for familyUser in DataHandler.instance.familyUsers {
                        if userName == familyUser.name {
                            userToEdit = familyUser
                            break
                        } else {
                            i += 1
                        }
                    }
                    
                    if userToEdit != nil {
                        guard let userCoordinates = user.childSnapshot(forPath: "coordinate").value as? [CLLocationDegrees] else { return }
                        guard let userLocation = user.childSnapshot(forPath: "location").value as? String else { return }
                        guard let userStatus = user.childSnapshot(forPath: "status").value as? Bool else { return }
                        let userCoordinate = CLLocationCoordinate2D(latitude: userCoordinates[0], longitude: userCoordinates[1])
                        
                        userToEdit?.coordinate = userCoordinate
                        userToEdit?.location = userLocation
                        userToEdit?.status = userStatus
                        
                        DataHandler.instance.familyUsers[i] = userToEdit!
                        self.familyTable.reloadData()
                        userToEdit = nil
                    }
                }
            }
            self.loadUserAnnotations()
            if self.mapIsCenteredOnFamily {
                mapManager.zoom(toFitAnnotationOn: self.mapView)
            } else if self.userToCenterMapOn != nil {
                if let coordinate = self.userToCenterMapOn?.coordinate {
                    mapManager.centerMapOnLocation(coordinate)
                }
            }
        })
    }
    
    func loadUserAnnotations() {
        guard let familyName = selfUser.family, familyName != "" else { return }
        
        for user in DataHandler.instance.familyUsers {
            if let coordinate = user.coordinate {
                let annotation = UserAnnotaion(coordinate: coordinate, user: user)
                var userIsVisible: Bool {
                    return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                        if let userAnnotation = annotation as? UserAnnotaion {
                            if userAnnotation.user.name == user.name {
                                userAnnotation.update(userAnnotation, withCoordinate: coordinate)
                                return true
                            }
                        }
                        return false
                    })
                }
                
                if !userIsVisible {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}
