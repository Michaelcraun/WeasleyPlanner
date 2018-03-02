//
//  FirebaseLoginLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension FirebaseLoginVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        
        if user == nil {
            layoutForRegister()
        } else {
            layoutForUserUpdate()
        }
    }
    
    func layoutForLogin() {
        clearForm()
        
        view.addSubview(firebaseSegmentedControl)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginRegisterButton)
        
        firebaseSegmentedControl.anchor(top: view.topAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                        size: .init(width: 0, height: 30))
        
        emailField.anchor(top: firebaseSegmentedControl.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                          size: .init(width: 0, height: 30))
        
        passwordField.anchor(top: emailField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        loginRegisterButton.title = "LOGIN"
        loginRegisterButton.anchor(top: passwordField.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: 30))
    }
    
    func layoutForRegister() {
        clearForm()
        
        view.addSubview(firebaseSegmentedControl)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(iconPicker)
        view.addSubview(iconPickerButton)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(loginRegisterButton)
        
        firebaseSegmentedControl.anchor(top: view.topAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                        size: .init(width: 0, height: 30))
        
        emailField.anchor(top: firebaseSegmentedControl.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                          size: .init(width: 0, height: 30))
        
        passwordField.anchor(top: emailField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        iconPicker.anchor(top: passwordField.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 0, bottom: 0, right: 5),
                          size: .init(width: 65, height: 65))
        
        iconPickerButton.fillTo(iconPicker)
        
         firstNameField.anchor(top: passwordField.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: iconPicker.leadingAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: 30))
        
        lastNameField.anchor(top: firstNameField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: iconPicker.leadingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        loginRegisterButton.title = "REGISTER"
        loginRegisterButton.anchor(top: lastNameField.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: 30))
    }
    
    func layoutForUserUpdate() {
        view.addSubview(iconPicker)
        view.addSubview(iconPickerButton)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(loginRegisterButton)
        
        iconPicker.anchor(top: view.topAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 0, bottom: 0, right: 5),
                          size: .init(width: 65, height: 65))
        
        iconPickerButton.fillTo(iconPicker)
        
        firstNameField.anchor(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              trailing: iconPicker.leadingAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: 30))
        
        lastNameField.anchor(top: firstNameField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: iconPicker.leadingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        loginRegisterButton.title = "SAVE"
        loginRegisterButton.anchor(top: lastNameField.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: 30))
        
        loadUserInfo()
    }
    
    func clearForm() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
}
