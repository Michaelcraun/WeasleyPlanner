//
//  PhotoDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/19/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

/// Manager for selecting photos
class PhotoDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// The UIViewController that the PhotoDelegate belongs to
    var delegate: UIViewController!
    /// The UIImage that the user has selected
    var selectedImage: UIImage?
    
    /// Displays a controller for user to select an image, presented from the delegate
    func displayImageController() {
        let imageController: UIImagePickerController = {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
            if let _ = delegate as? FirebaseLoginVC {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    controller.sourceType = .camera
                    controller.cameraCaptureMode = .photo
                    controller.cameraDevice = .front
                    //TODO: Camera Overlay ?
                } else {
                    controller.sourceType = .photoLibrary
                }
            } else if let _ = delegate as? AddRecipeVC {
                controller.sourceType = .photoLibrary
            }
            return controller
        }()
        
        delegate.present(imageController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
        }
        
        if let firebaseLogin = delegate as? FirebaseLoginVC {
            if let selectedImage = selectedImage {
                firebaseLogin.setSelectedImage(selectedImage)
            }
        } else if let addRecipe = delegate as? AddRecipeVC {
            if let selectedImage = selectedImage {
                addRecipe.setSelectedImage(selectedImage)
            }
        }
        
        selectedImage = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
