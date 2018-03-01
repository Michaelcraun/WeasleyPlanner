//
//  UIViewExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: Animation methods
    func addBlurEffect(tag: Int) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.tag = tag
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
    
    func fadeAlphaOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
    
    func fadeAlphaTo(_ alpha: CGFloat, withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
    //MARK: Layout methods
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true }
        if let leading = leading { leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true }
        if let trailing = trailing { trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true }
        
        if let centerX = centerX { centerXAnchor.constraint(equalTo: centerX).isActive = true }
        if let centerY = centerY { centerYAnchor.constraint(equalTo: centerY).isActive = true }
        
        if size.width != 0 { widthAnchor.constraint(equalToConstant: size.width).isActive = true }
        if size.height != 0 { heightAnchor.constraint(equalToConstant: size.height).isActive = true }
    }
    
    func fillToView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: UI element methods
    func addBorder() {
        self.layer.borderColor = primaryColor.cgColor
        self.layer.borderWidth = 1
    }
    
    func addDeepShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.75
    }
    
    func addMidShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.75
    }
    
    func addLightShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.75
    }
    
    //MARK: Keyboard interaction methods
    func addTapToDismissKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }
    
    func removeTapToDismissKeyboard() {
        for recognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }
    }
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func detachFromKeyboard() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let offset = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.frame.origin.y -= offset.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.frame.origin.y += keyboardSize.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.detachFromKeyboard()
        }
    }
}
