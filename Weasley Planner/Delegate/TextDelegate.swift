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
        
        if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                addEvent.view.removeTapToDismissKeyboard()
                addEvent.animateLocationTable(shouldOpen: true)
                addEvent.locationField.inputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let firebaseLogin = delegate as? FirebaseLoginVC {
            firebaseLogin.registerButtonPressed(nil)
        } else if let addRecipe = delegate as? AddRecipeVC {
            addRecipe.saveButtonPressed(nil)
        } else if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                guard let searchText = textField.text else { return false }
                addEvent.performSearch(searchText: searchText)
            } else {
                addEvent.saveButtonPressed(nil)
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.view.removeTapToDismissKeyboard()
        
        if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                addEvent.animateLocationTable(shouldOpen: false)
            } else if textField == addEvent.recurrenceView.amountField {
                addEvent.recurrenceView.recurrenceTypePicker.dataPicker.reloadAllComponents()
                addEvent.recurrenceView.updateRecurrenceView(true)
            } else if textField == addEvent.recurrenceView.recurrenceField {
                addEvent.recurrenceView.updateRecurrenceView(true)
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                guard let searchText = textField.text else { return }
                addEvent.performSearch(searchText: searchText)
            }
        }
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
