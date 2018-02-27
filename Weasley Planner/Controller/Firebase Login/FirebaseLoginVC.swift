//
//  FirebaseLoginVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import Firebase

class FirebaseLoginVC: UIViewController {
    //MARK: UI Variables
    let firebaseSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.addTarget(self, action: #selector(firebaseSegmentChanged(_:)), for: .valueChanged)
        segment.insertSegment(withTitle: "Register", at: 0, animated: false)
        segment.insertSegment(withTitle: "Login", at: 1, animated: false)
        segment.selectedSegmentIndex = 0
        segment.tintColor = primaryColor
        return segment
    }()
    
    let firstNameField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .firstName
        return field
    }()
    
    let emailField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .email
        return field
    }()
    
    let iconPicker: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        imageView.addBorder()
        imageView.layer.cornerRadius = 65 / 2
        return imageView
    }()
    
    let iconPickerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(imagePickerPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let passwordField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .password
        return field
    }()
    
    let lastNameField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .lastName
        return field
    }()
    
    let loginRegisterButton: TextButton = {
        let button = TextButton()
        button.title = "REGISTER"
        button.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: Data Variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textManager.delegate = self
        
    }
    
    func loadUserInfo() {
        if let userImage = user?.icon { iconPicker.image = userImage }
        if let userName = user?.name {
            let nameSegments = userName.split(separator: " ")
            let firstName = nameSegments[0]
            let lastName = nameSegments[1]
            
            firstNameField.inputField.text = "\(firstName)"
            lastNameField.inputField.text = "\(lastName)"
        }
    }
    
    @objc func registerButtonPressed(_ sender: TextButton?) {
        view.endEditing(true)
        if let title = sender?.title {
            switch title {
            case "LOGIN": loginWithFirebase()
            case "REGISTER": registerWithFirebase()
            case "SAVE": updateUser()
            default: break
            }
        }
    }
    
    @objc func firebaseSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: layoutForRegister()
        case 1: layoutForLogin()
        default: break
        }
    }
    
    @objc func imagePickerPressed(_ sender: UIButton) {
        photoManager.delegate = self
        photoManager.displayImageController()
    }
    
    func setSelectedImage(_ image: UIImage) {
        iconPicker.image = image
    }
}
