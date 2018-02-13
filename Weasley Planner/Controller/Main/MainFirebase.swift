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
    func updateUserLocation(with location: CLLocation) {
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
                        if let error = error {
                            print("FIREBASE: There was an error loading the image...", error)
                            return
                        }
                        
                        guard let imageData = data else { return }
                        guard let image = UIImage(data: imageData) else { return }
                        self.selfUser.icon = image
                        
                        self.initializeFamilyUsers()
                    })
                }
            }
        })
    }
    
    func initializeFamilyUsers() {
        guard let familyName = selfUser.family, familyName != "" else { return }
        print("FAMILY: in initializeFamilyUsers: familyName: \(familyName)")
        familyUsers = []
        
        DataHandler.instance.REF_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                guard let userFamily = user.childSnapshot(forPath: "family").value as? String else { return }
                if userFamily == familyName {
                    guard let userImageName = user.childSnapshot(forPath: "imageName").value as? String else { return }
                    guard let userName = user.childSnapshot(forPath: "name").value as? String else { return }
                    guard let userLocation = user.childSnapshot(forPath: "location").value as? String else { return }
                    guard let userStatus = user.childSnapshot(forPath: "status").value as? Bool else { return }
                    
                    print("FAMILY: in initializeFamilUsers: newFamilyUserInfo: \(userImageName, userName, userLocation, userStatus)")
                    
                    DataHandler.instance.REF_IMAGE.child("\(userImageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                        if let error = error {
                            print("FIREBASE: There was an error loading the image...", error)
                            return
                        }
                        
                        guard let imageData = data else { return }
                        guard let image = UIImage(data: imageData) else { return }
                        let newFamilyUser = User(family: familyName, icon: image, name: userName, location: userLocation, status: userStatus, uid: user.key)
                        
                        self.familyUsers.append(newFamilyUser)
                        
                        self.observeFamilyUsers()
                    })
                }
            }
        })
    }
    
    func observeFamilyUsers() {
        guard let familyName = selfUser.family, familyName != "" else { return }
        var userToEdit: User?
        
        DataHandler.instance.REF_USER.observe(.value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                guard let userFamily = user.childSnapshot(forPath: "family").value as? String else { return }
                if userFamily == familyName {
                    guard let userName = user.childSnapshot(forPath: "name").value as? String else { return }
                    var i = 0
                    for familyUser in self.familyUsers {
                        if userName == familyUser.name {
                            userToEdit = familyUser
                            
                            guard let userLocation = user.childSnapshot(forPath: "location").value as? String else { return }
                            guard let userStatus = user.childSnapshot(forPath: "status").value as? Bool else { return }
                            
                            userToEdit?.location = userLocation
                            userToEdit?.status = userStatus
                            
                            self.familyUsers[i] = userToEdit!
                        } else {
                            i += 1
                        }
                    }
                }
            }
        })
    }
}
