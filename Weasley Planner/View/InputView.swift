//
//  InputField.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class InputView: UIView {
    let inputField: InputField = {
        let field = InputField()
        field.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        field.textColor = secondaryTextColor
        return field
    }()
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        textView.textColor = secondaryTextColor
        return textView
    }()
    
    enum InputType: String {
        case none
        
        case activeTime = "Active Time"
        case date = "Date"
        case description = "Description"
        case email = "Email"
        case firstName = "First Name"
        case ingredients = "Ingredients"
        case instructions = "Instructions"
        case lastName = "Last Name"
        case location = "Location"
        case notes = "Notes"
        case password = "Password"
        case source = "Source"
        case title = "Title"
        case url = "URL"
        case user = "User"
        case totalTime = "Total Time"
        case yield = "Yield"
    }
    
    var inputType: InputType = .none
    
    override func layoutSubviews() {
        self.backgroundColor = secondaryColor
        self.addBorder()
        
        let placeHolderLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = primaryColor
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.text = inputType.rawValue
            label.textAlignment = .center
            label.textColor = primaryTextColor
            return label
        }()
        
        switch inputType {
        case .activeTime, .date, .email, .firstName, .lastName, .location, .password, .source, .title, .totalTime, .url, .user, .yield:
            if inputType == .email {
                inputField.autocapitalizationType = .none
            } else if inputType == .password {
                inputField.autocapitalizationType = .none
                inputField.isSecureTextEntry = true
            }
            
            self.addSubview(inputField)
            self.addSubview(placeHolderLabel)
            
            placeHolderLabel.anchor(top: self.topAnchor,
                                    leading: self.leadingAnchor,
                                    bottom: self.bottomAnchor,
                                    size: .init(width: 100, height: 0))
            
            inputField.anchor(top: self.topAnchor,
                              leading: placeHolderLabel.trailingAnchor,
                              trailing: self.trailingAnchor,
                              bottom: self.bottomAnchor)
        default:
            self.addSubview(inputTextView)
            self.addSubview(placeHolderLabel)
            
            placeHolderLabel.anchor(top: self.topAnchor,
                                    leading: self.leadingAnchor,
                                    trailing: self.trailingAnchor,
                                    size: .init(width: 0, height: 30))
            
            inputTextView.anchor(top: placeHolderLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 bottom: self.bottomAnchor)
        }
    }
}

class InputField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX + 5,
                      y: bounds.minY,
                      width: bounds.width - 10,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
