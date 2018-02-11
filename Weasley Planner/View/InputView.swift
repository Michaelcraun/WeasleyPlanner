//
//  InputField.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class InputView: UIView {
    let inputField = InputField()
    enum InputType: String {
        case none
        
        case email = "Email"
        case firstName = "First Name"
        case lastName = "Last Name"
        case password = "Password"
    }
    
    var inputType: InputType = .none
    
    override func layoutSubviews() {
        let placeHolderLabel = UILabel()
        
        self.backgroundColor = secondaryColor
        self.layer.borderColor = primaryColor.cgColor
        self.layer.borderWidth = 1
        
        self.addSubview(inputField)
        self.addSubview(placeHolderLabel)
        
        placeHolderLabel.backgroundColor = primaryColor
        placeHolderLabel.font = UIFont(name: fontName, size: smallFontSize)
        placeHolderLabel.text = inputType.rawValue
        placeHolderLabel.textAlignment = .center
        placeHolderLabel.textColor = primaryTextColor
        placeHolderLabel.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: self.bottomAnchor,
                                size: .init(width: 100, height: 0))
        
        if inputType == .email || inputType == .password { inputField.autocapitalizationType = .none }
        if inputType == .password { inputField.isSecureTextEntry = true }
        inputField.font = UIFont(name: fontName, size: smallFontSize)
        inputField.textColor = secondaryTextColor
        inputField.anchor(top: self.topAnchor,
                          leading: placeHolderLabel.trailingAnchor,
                          trailing: self.trailingAnchor,
                          bottom: self.bottomAnchor)
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
