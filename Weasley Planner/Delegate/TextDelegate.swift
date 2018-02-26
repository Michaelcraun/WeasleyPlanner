//
//  TextDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class TextDelegate: NSObject, UITextFieldDelegate, UITextViewDelegate {
    var delegate: UIViewController!
    
    //------------------------------------
    // MARK: - TEXT FIELD DELEGATE METHODS
    //------------------------------------
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate.view.addTapToDismissKeyboard()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let firebaseLogin = delegate as? FirebaseLoginVC {
            firebaseLogin.registerButtonPressed(nil)
        } else if let addRecipe = delegate as? AddRecipeVC {
            addRecipe.saveButtonPressed(nil)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.view.removeTapToDismissKeyboard()
        
        
    }
    
    //-----------------------------------
    // MARK: - TEXT VIEW DELEGATE METHODS
    //-----------------------------------
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate.view.addTapToDismissKeyboard()
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate.view.removeTapToDismissKeyboard()
        
        
    }
}
