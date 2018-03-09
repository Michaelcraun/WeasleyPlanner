//
//  TextDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

/// Manager for UITextField and UITextView input
class TextDelegate: NSObject, UITextFieldDelegate, UITextViewDelegate {
    /// The UIViewController TextDelegate belongs to. Must be set before setting the delegates of any UITextField or UITextView is set
    var delegate: UIViewController!
    
    //------------------------------------
    // MARK: - TEXT FIELD DELEGATE METHODS
    //------------------------------------
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate.view.addTapToDismissKeyboard()
        
        if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                addEvent.view.removeTapToDismissKeyboard()
                addEvent.animateTableView(addEvent.locationList, shouldOpen: true)
                addEvent.locationField.inputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if textField == addEvent.titleField.inputField {
                if addEvent.eventType == .meal {
                    addEvent.view.removeTapToDismissKeyboard()
                    addEvent.animateTableView(addEvent.recipeList, shouldOpen: true)
                    addEvent.titleField.inputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                }
            }
        } else if let recipeList = delegate as? RecipeListVC {
            if textField == recipeList.searchField.inputField {
                recipeList.view.removeTapToDismissKeyboard()
                recipeList.animateTableView(recipeList.searchList, shouldOpen: true)
                recipeList.searchField.inputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let firebaseLogin = delegate as? FirebaseLoginVC {
            firebaseLogin.registerButtonPressed(nil)
        } else if let addRecipe = delegate as? AddRecipeVC {
            addRecipe.saveButtonPressed(nil)
        } else if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                guard let searchText = textField.text else { return false }
                addEvent.performLocationSearch(searchText: searchText)
            } else if textField == addEvent.titleField.inputField && addEvent.eventType == .meal {
                guard let searchText = textField.text else { return false }
                addEvent.performRecipeSearch(searchText: searchText)
            } else {
                addEvent.saveButtonPressed(nil)
            }
        } else if let recipeList = delegate as? RecipeListVC {
            if textField == recipeList.searchField.inputField {
                guard let searchText = textField.text else { return false }
                recipeList.performRecipeSearch(searchText: searchText)
            }
        }
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.view.removeTapToDismissKeyboard()
        
        if let addEvent = delegate as? AddEventVC {
            if textField == addEvent.locationField.inputField {
                addEvent.animateTableView(addEvent.locationList, shouldOpen: false)
            } else if textField == addEvent.recurrenceView.amountField {
                addEvent.recurrenceView.recurrenceField.isEnabled = true
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
                addEvent.performLocationSearch(searchText: searchText)
            } else if textField == addEvent.titleField.inputField {
                guard let searchText = textField.text else { return }
                addEvent.performRecipeSearch(searchText: searchText)
            }
        } else if let recipeList = delegate as? RecipeListVC {
            if textField == recipeList.searchField.inputField {
                guard let searchText = textField.text else { return }
                recipeList.performRecipeSearch(searchText: searchText)
            }
        }
    }
    
    //-----------------------------------
    // MARK: - TEXT VIEW DELEGATE METHODS
    //-----------------------------------
    
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate.view.endEditing(true)
        
        return true
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        delegate.view.addTapToDismissKeyboard()
        
        
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        delegate.view.removeTapToDismissKeyboard()
        
        
    }
}
