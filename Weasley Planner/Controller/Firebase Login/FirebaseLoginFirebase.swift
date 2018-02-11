//
//  FirebaseLoginFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import Firebase

extension FirebaseLoginVC {
    func loginWithFirebase() {
        view.endEditing(true)
        
        let imageName = NSUUID().uuidString
        
        guard let email = emailField.inputField.text, email != "" else {
            print("FIREBASE: No email")
            return }
        
        guard let password = passwordField.inputField.text, password != "" else {
            print("FIREBASE: No password")
            return
        }
        
        guard let firstName = firstNameField.inputField.text, firstName != "" else {
            print("FIREBASE: No first name")
            return
        }
        
        guard let lastName = lastNameField.inputField.text, lastName != "" else {
            print("FIREBASE: No last name")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let userData: Dictionary<String,Any> = ["imageName" : imageName,
                                                        "status" : true]
                
                guard let user = user else {
                    print("FIREBASE: Unknown user...")
                    return
                }
                
                DataHandler.instance.updateFirebaseUser(uid: user.uid, userData: userData)
                self.uploadImage(with: imageName)
            } else {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .errorCodeUserNotFound:
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error == nil {
                                let userData: Dictionary<String,Any> = ["family" : "",
                                                                        "name" : "\(firstName) \(lastName)",
                                                                        "imageName" : imageName,
                                                                        "status" : true]
                                
                                guard let user = user else { return }
                                DataHandler.instance.updateFirebaseUser(uid: user.uid, userData: userData)
                                self.uploadImage(with: imageName)
                            } else {
                                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    default: print("An unexpected Firebase error occured. Please try again.")
                                    }
                                }
                            }
                        })
                    default: break
                    }
                }
            }
            DataHandler.instance.currentUserID = FIRAuth.auth()?.currentUser?.uid
            self.dismiss(animated: true, completion: nil)
        })
        dismiss(animated: true, completion: nil)
        
//                switch errorCode {
//                case .errorCodeEmailAlreadyInUse: self.showAlert(.emailAlreadyInUse)
//                case .errorCodeWrongPassword:
//                    self.wrongPasswordCount += 1
//                    if self.wrongPasswordCount >= 3 {
//                        GameHandler.instance.userEmail = email
//                        self.showAlert(.resetPassword)
//                    } else {
//                        self.showAlert(.wrongPassword)
//                    }
//                case .errorCodeInvalidEmail: self.showAlert(.invalidEmail)
//                case .errorCodeUserNotFound:
//                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
//                        if error != nil {
//                            guard let errorCode = FIRAuthErrorCode(rawValue: error!._code) else { return }
//                            switch errorCode {
//                            case .errorCodeInvalidEmail: self.showAlert(.invalidEmail)
//                            default: self.showAlert(.firebaseError)
//                            }
//                        } else {
//                            guard let user = user else { return }
//                            let userData: Dictionary<String,Any> = ["provider" : user.providerID,
//                                                                    "username" : username,
//                                                                    "mostManaGainedInOneTurn" : 0,
//                                                                    "mostVPGainedInOneTurn" : 0,
//                                                                    "gamesPlayed" : 0,
//                                                                    "gamesWon" : 0,
//                                                                    "gamesLost" : 0,
//                                                                    "mostVPGainedInOneGame" : 0]
//                            GameHandler.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
//                            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
//                            self.defaults.set(username, forKey: "username")
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    })
//                default: self.showAlert(.firebaseError)
//                }
        
    }
    
    func uploadImage(with name: String) {
        guard let uploadData = UIImagePNGRepresentation(iconPicker.image!) else {
            print("FIREBASE: There was an error converting image to data...")
            return
        }
        
        DataHandler.instance.REF_IMAGE.child("\(name).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("FIREBASE: Cannot store image on Firebase...", error)
                return
            }
        })
        print("FIREBASE: Successfully uploaded image to Firebase!")
    }
}
