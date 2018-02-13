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
    
    func observeCurrentUser() {
        DataHandler.instance.REF_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == DataHandler.instance.currentUserID {
                    guard let userDict = user.value as? Dictionary<String,Any> else { return }
                    guard let family = userDict["family"] as? String else { return }
                    guard let name = userDict["name"] as? String else { return }
                    guard let imageName = userDict["imageName"] as? String else { return }
                    
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
                    })
                }
            }
            self.familyUsers = [self.selfUser]
        })
        
        DataHandler.instance.REF_USER.observe(.value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == DataHandler.instance.currentUserID {
                    guard let userDict = user.value as? Dictionary<String,Any> else { return }
                    guard let location = userDict["location"] as? String else { return }
                    guard let status = userDict["status"] as? Bool else { return }
                    
                    self.selfUser.location = location
                    self.selfUser.status = status
                }
            }
            self.familyUsers = [self.selfUser]
        })
    }
}
