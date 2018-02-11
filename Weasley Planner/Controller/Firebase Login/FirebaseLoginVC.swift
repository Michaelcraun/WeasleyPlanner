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
    let firstNameField = InputView()
    let emailField = InputView()
    let iconPicker = UIImageView()
    let iconPickerButton = UIButton()
    let passwordField = InputView()
    let lastNameField = InputView()
    let loginRegisterButton = TextButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    @objc func registerButtonPressed(_ sender: UIButton?) {
        view.endEditing(true)
        loginWithFirebase()
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { iconPicker.image = image }
        
        iconPicker.contentMode = .scaleAspectFill
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerPressed(_ sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.sourceType = .camera
        imageController.cameraCaptureMode = .photo
        imageController.cameraDevice = .front
//        imageController.cameraOverlayView
        imageController.delegate = self
        imageController.allowsEditing = true

        present(imageController, animated: true, completion: nil)
    }
}
