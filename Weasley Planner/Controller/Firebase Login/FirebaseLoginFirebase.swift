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
            showAlert(.noEmail)
            return }
        
        guard let password = passwordField.inputField.text, password != "" else {
            showAlert(.noPassword)
            return
        }
        
        guard let firstName = firstNameField.inputField.text, firstName != "" else {
            showAlert(.noFirstName)
            return
        }
        
        guard let lastName = lastNameField.inputField.text, lastName != "" else {
            showAlert(.noLastName)
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let userData: Dictionary<String,Any> = ["imageName" : imageName,
                                                        "status" : true]
                
                guard let user = user else { return }
                DataHandler.instance.updateFirebaseUser(uid: user.uid, userData: userData)
                self.uploadImage(with: imageName)
            } else {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .errorCodeInvalidEmail: self.showAlert(.invalidEmail)
                    case .errorCodeNetworkError: self.showAlert(.networkError)
                    case .errorCodeUserDisabled: self.showAlert(.userDisabled)
                    case .errorCodeInternalError: self.showAlert(.internalError)
                    case .errorCodeWrongPassword: self.showAlert(.wrongPassword)
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
                                    case .errorCodeEmailAlreadyInUse: self.showAlert(.emailInUse)
                                    default: self.showAlert(.generalFirebaseError)
                                    }
                                }
                            }
                        })
                    default: break
                    }
                }
            }
            DataHandler.instance.currentUserID = FIRAuth.auth()?.currentUser?.uid
            DataHandler.instance.segueIdentifier = "dismiss"
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func uploadImage(with name: String) {
        let croppedImage = iconPicker.image?.cropSquare()
        let resizedImage = croppedImage?.resizeImage(CGSize(width: 100, height: 100))
        guard let uploadData = UIImagePNGRepresentation(resizedImage!) else {
            showAlert(.imageError)
            return
        }
        
        DataHandler.instance.REF_IMAGE.child("\(name).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
            if let _ = error {
                self.showAlert(.imageError)
                return
            }
        })
    }
}
