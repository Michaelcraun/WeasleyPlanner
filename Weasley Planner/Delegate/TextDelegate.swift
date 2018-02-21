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
    
    //-----------------------------//
    // TEXT FIELD DELEGATE METHODS //
    //-----------------------------//
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate.view.addTapToDismissKeyboard()
        
        if let addRecipe = delegate as? AddRecipeVC {
            var needsBoundToKeyboard: Bool {
                switch textField {
                case addRecipe.yieldField.inputField: return true
                case addRecipe.activeTimeField.inputField: return true
                case addRecipe.totalTimeField.inputField: return true
                case addRecipe.sourceField.inputField: return true
                case addRecipe.urlField.inputField: return true
                default: return false
                }
            }
            
            if needsBoundToKeyboard && !addRecipe.isBoundToKeyboard {
                addRecipe.view.bindToKeyboard()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let firebaseLogin = delegate as? FirebaseLoginVC {
            firebaseLogin.registerButtonPressed(nil)
        } else if let addRecipe = delegate as? AddRecipeVC {
            addRecipe.saveButtonPressed(nil)
        }
        
        return true
    }
    
    //----------------------------//
    // TEXT VIEW DELEGATE METHODS //
    //----------------------------//
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.view.removeTapToDismissKeyboard()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate.view.addTapToDismissKeyboard()
        
        if let addRecipe = delegate as? AddRecipeVC {
            var needsBoundToKeyboard: Bool {
                switch textView {
                case addRecipe.ingredientsView.inputTextView: return true
                case addRecipe.instructionsView.inputTextView: return true
                default: return false
                }
            }
            
            if needsBoundToKeyboard && !addRecipe.isBoundToKeyboard {
                addRecipe.view.bindToKeyboard()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate.view.removeTapToDismissKeyboard()
    }
}
