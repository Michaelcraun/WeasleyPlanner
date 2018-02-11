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
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(iconPicker)
        view.addSubview(iconPickerButton)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(loginRegisterButton)
        
        emailField.inputField.delegate = self
        emailField.inputType = .email
        emailField.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                          size: .init(width: 0, height: 30))
        
        passwordField.inputField.delegate = self
        passwordField.inputType = .password
        passwordField.anchor(top: emailField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        iconPicker.layer.borderColor = primaryColor.cgColor
        iconPicker.layer.borderWidth = 1
        iconPicker.layer.cornerRadius = 65 / 2
        iconPicker.clipsToBounds = true
        iconPicker.image = #imageLiteral(resourceName: "defaultProfileImage")
        iconPicker.anchor(top: passwordField.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 0, bottom: 0, right: 5),
                          size: .init(width: 65, height: 65))
        
        iconPickerButton.addTarget(self, action: #selector(imagePickerPressed(_:)), for: .touchUpInside)
        iconPickerButton.anchor(top: iconPicker.topAnchor,
                                leading: iconPicker.leadingAnchor,
                                trailing: iconPicker.trailingAnchor,
                                bottom: iconPicker.bottomAnchor)
        
        firstNameField.inputField.delegate = self
        firstNameField.inputType = .firstName
        firstNameField.anchor(top: passwordField.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: iconPicker.leadingAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: 30))
        
        lastNameField.inputField.delegate = self
        lastNameField.inputType = .lastName
        lastNameField.anchor(top: firstNameField.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: iconPicker.leadingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        loginRegisterButton.title = "LOGIN"
        loginRegisterButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        loginRegisterButton.anchor(top: lastNameField.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: 30))
    }
}
