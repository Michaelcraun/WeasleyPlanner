//
//  SettingsFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/12/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

extension SettingsVC {
    func observeForNearbyUsers() {
        nearbyUsers = []
        guard let location = mapManager.locationManager.location else { return }
        
        DataHandler.instance.REF_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for user in userSnapshot {
                guard let userDict = user.value as? Dictionary<String,Any> else { return }
                guard let userFamily = userDict["family"] as? String else { return }
                guard let userName = userDict["name"] as? String else { return }
                
                if userName != self.user?.name && userFamily == "" {
                    guard let userCoordinates = userDict["coordinate"] as? [CLLocationDegrees] else { return }
                    let userLocation = CLLocation(latitude: userCoordinates[0], longitude: userCoordinates[1])
                    let distance = location.distance(from: userLocation)
                    
                    if distance <= 1800.0 {
                        guard let userName = userDict["name"] as? String else { return }
                        guard let userImageName = userDict["imageName"] as? String else { return }
                        guard let userLocation = userDict["location"] as? String else { return }
                        guard let userStatus = userDict["status"] as? Bool else { return }
                        
                        DataHandler.instance.REF_PROFILE_IMAGE.child("\(userImageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                            if let _ = error { return }
                            guard let userImageData = data else { return }
                            guard let userImage = UIImage(data: userImageData) else { return }
                            
                            let nearbyUser = User(icon: userImage, name: userName, location: userLocation, status: userStatus, uid: user.key)
                            self.nearbyUsers.append(nearbyUser)
                        })
                    }
                }
            }
        })
    }
    
    func createFirebaseFamily(with familyName: String) {
        guard let uid = DataHandler.instance.currentUserID else { return }
        let familyIdentifier = DataHandler.instance.createFamilyIDString(with: familyName)
        let userData: Dictionary<String,Any> = ["family" : familyName,
                                                "familyIdentifier" : familyIdentifier]
        let familyData: Dictionary<String,Any> = ["creator" : user?.name as Any,
                                                  "name" : familyName,
                                                  "users" : [user?.name]]
        
        user?.family = familyName
        DataHandler.instance.updateFirebaseUser(uid: uid, userData: userData)
        DataHandler.instance.updateFirebaseFamily(id: familyIdentifier, familyData: familyData)
    }
    
    func updateFirebaseFamilyWithSelectedUser() {
        guard let userFamilyName = user?.family else { return }
        guard let selectedUserName = userToAddToFamily?.name else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamilyName {
                    guard let familyUsers = family.childSnapshot(forPath: "users").value as? [String] else { return }
                    let familyID = family.key
                    var newFamilyUsers = familyUsers
                    newFamilyUsers.append(selectedUserName)
                    
                    DataHandler.instance.familyUsers.append(self.userToAddToFamily!)
                    DataHandler.instance.updateFirebaseFamily(id: familyID, familyData: ["users" : newFamilyUsers])
                    self.updateSelectedUserWithFamily(userFamilyName)
                }
            }
        }
    }
    
    func removeSelectedUserFromFirebaseFamily() {
        guard let selectedUserID = userToRemoveFromFamily?.uid else { return }
        var i = 0
        
        for user in DataHandler.instance.familyUsers {
            if user.uid == selectedUserID {
                let userData = ["family" : "", "familyIdentifier" : ""]
                
                DataHandler.instance.familyUsers.remove(at: i)
                DataHandler.instance.updateFirebaseUser(uid: selectedUserID, userData: userData)
                self.observeForNearbyUsers()
            } else {
                i += 1
            }
        }
    }
    
    func updateSelectedUserWithFamily(_ name: String) {
        guard let selectedUserUID = userToAddToFamily?.uid else { return }
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == name {
                    let familyID = family.key
                    let userData = ["family" : name,
                                    "familyIdentifier" : familyID]
                    
                    DataHandler.instance.updateFirebaseUser(uid: selectedUserUID, userData: userData)
                    self.observeForNearbyUsers()
                }
            }
        }
    }
}
