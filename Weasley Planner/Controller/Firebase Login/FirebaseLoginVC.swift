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
    let firebaseSegmentedControl = UISegmentedControl()
    let firstNameField = InputView()
    let emailField = InputView()
    let iconPicker = UIImageView()
    let iconPickerButton = UIButton()
    let passwordField = InputView()
    let lastNameField = InputView()
    let loginRegisterButton = TextButton()
    
    //MARK: Data Variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
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
}

extension FirebaseLoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerButtonPressed(nil)
        return true
    }
}

extension FirebaseLoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            iconPicker.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            iconPicker.image = image
        }
        
        iconPicker.contentMode = .scaleAspectFill
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerPressed(_ sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imageController.sourceType = .camera
            imageController.cameraCaptureMode = .photo
            imageController.cameraDevice = .front
//            imageController.cameraOverlayView
        } else {
            imageController.sourceType = .photoLibrary
        }

        present(imageController, animated: true, completion: nil)
    }
}
