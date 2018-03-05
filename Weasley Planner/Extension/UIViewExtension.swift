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
    /// Adds a blur effect view to the given view
    func addBlurEffect(tag: Int) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.tag = tag
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
    
    /// Fades the alpha of the given view out in the span of 0.2 seconds and then removes it from the superview
    func fadeAlphaOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
    
    /// Fades the alpha of the given view to whatever value is designated
    /// - parameter alpha: A CGFloat value representing the desired transparency of the given view
    /// - parameter duration: A TimeInterval value representing the desired length of time for the fade to happen
    /// (defaults to 0.2 seconds)
    func fadeAlphaTo(_ alpha: CGFloat, withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
    //MARK: Layout methods
    /// Sets the given view's top, leading, trailing, bottom, centerX, centerY, width, and height constraints
    /// - parameter top: An NSLayoutYAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter leading: An NSLayoutXAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter trailing: An NSLayoutXAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter bottom: An NSLayoutYAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter centerX: An NSLayoutXAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter centerY: An NSLayoutYAxisAnchor to constrain the given view to (defaults to nil)
    /// - parameter padding: UIEdgeInsets representing the buffer between to top, leading, trailing, and
    /// bottom constraints (defaults to .zero)
    /// - parameter size: A CGSize value representing the desired size of the view (defaults to .zero)
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
    
    /// Constrains the given view to the top, leading, trailing, and bottom of the designated view with
    /// a designated amount of padding and size
    /// - parameter view: The view to constrain the given view to
    /// - parameter padding: UIEdgeInsets representing the buffer between the top, leading, trailing, and
    /// bottom edges of the given view and the edges of view constraining to (defaults to .zero)
    /// - parameter size: A CGSize value representing the desired size of the given view (defaults to .zero).
    /// If given a size, the view being constrained to should automatically adjust it's size
    func fillTo(_ view: UIView, withPadding padding: UIEdgeInsets = .zero, andSize size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.right).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
        
        if size.width != 0 { widthAnchor.constraint(equalToConstant: size.width).isActive = true }
        if size.height != 0 { heightAnchor.constraint(equalToConstant: size.height).isActive = true }
    }
    
    //MARK: UI element methods
    /// Adds a 1 pixel wide border of the primaryColor to the given view
    /// - parameter clipsToBounds: A Boolean value that determines whether subviews are confined to the bounds
    /// of the view (defaults to true). Should be set to false if used in conjuction with addDeepShadows(),
    /// addMidShadows() or addLightShadows().
    func addBorder(clipsToBounds: Bool = true) {
        self.clipsToBounds = clipsToBounds
        self.layer.borderColor = primaryColor.cgColor
        self.layer.borderWidth = 1
    }
    
    /// Adds a 10 pixel tall shadow to the bottom of the given view
    func addDeepShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.75
    }
    
    /// Adds a 5 pixel tall shadow to the bottom of the given view
    func addMidShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.75
    }
    
    /// Adds a 2 pixel tall shadow to the bottom of the given view
    func addLightShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.75
    }
    
    //MARK: Keyboard interaction methods
    /// Adds a UITapGestureRecognizer to the given view that dismisses the keyboard when activated
    func addTapToDismissKeyboard() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }
    
    /// Removes the UITapGestureRecognizer from the given view that dismisses the keyboard when activated
    func removeTapToDismissKeyboard() {
        for recognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }
    }
    
    /// Adds an observer to the given view for when the keyboard will show and when it will hide
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
    
    /// Removes observers from the given view for when the keyboard will show and when it will hide
    func detachFromKeyboard() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    /// Dismisses the keyboard when activtaed
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    /// Determines the height of the keyboard and moves the given view up when the keyboard will show
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let offset = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.frame.origin.y -= offset.height
    }
    
    /// Resets the given view's height when the keyboard will hide
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.frame.origin.y += keyboardSize.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.detachFromKeyboard()
        }
    }
}
