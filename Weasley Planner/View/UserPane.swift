//
//  UserPane.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class UserPane: UIView {
    var loginPanel = UIButton()
    
    var userIcon: UIImage?
    var userName: String!
    var userLocation: String!
    var userStatus: Bool!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addBorder(clipsToBounds: false)
        self.addLightShadows()
        self.backgroundColor = secondaryColor
        self.layer.cornerRadius = 5
    }
    
    func layoutForUser(with height: CGFloat) {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let userIconView = layoutProfileIcon(with: height)
        let statusIconView = layoutStatusIcon()
        let userNameLabel = layoutUserNameLabel()
        let locationLabel = layoutLocationLabel()
        
        self.addSubview(userIconView)
        self.addSubview(statusIconView)
        self.addSubview(userNameLabel)
        self.addSubview(locationLabel)
        
        userIconView.anchor(top: self.topAnchor,
                            leading: self.leadingAnchor,
                            bottom: self.bottomAnchor,
                            padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                            size: .init(width: height - 10, height: 0))
        
        statusIconView.anchor(top: userIconView.topAnchor,
                              trailing: userIconView.trailingAnchor,
                              size: .init(width: 15, height: 15))
        
        userNameLabel.anchor(top: self.topAnchor,
                             leading: userIconView.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        
        locationLabel.anchor(top: userNameLabel.bottomAnchor,
                             leading: userIconView.trailingAnchor,
                             trailing: self.trailingAnchor,
                             bottom: self.bottomAnchor,
                             padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }
    
    func layoutForLogin() {
        loginPanel = layoutLoginPanel()
        self.addSubview(loginPanel)
        loginPanel.fillTo(self)
    }
    
    private func layoutProfileIcon(with height: CGFloat) -> UIImageView {
        let iconView = UIImageView()
        iconView.layer.cornerRadius = (height - 10) / 2
        iconView.addBorder()
        iconView.contentMode = .scaleAspectFill
        
        guard let image = userIcon else {
            iconView.image = #imageLiteral(resourceName: "defaultProfileImage")
            return iconView
        }
        
        iconView.image = image
        return iconView
    }
    
    private func layoutStatusIcon() -> UIView {
        let statusIcon = UIView()
        statusIcon.layer.cornerRadius = 7.5
        statusIcon.addBorder()
        
        if let status = userStatus {
            switch status {
            case true: statusIcon.backgroundColor = .green
            case false: statusIcon.backgroundColor = .red
            }
        }
        
        return statusIcon
    }
    
    private func layoutUserNameLabel() -> UILabel {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont(name: secondaryFontName, size: smallFontSize)
        userNameLabel.text = userName
        userNameLabel.textColor = secondaryTextColor
        userNameLabel.sizeToFit()
        
        return userNameLabel
    }
    
    private func layoutLocationLabel() -> UILabel {
        let locationLabel = UILabel()
        locationLabel.font = UIFont(name: secondaryFontName, size: smallestFontSize)
        locationLabel.numberOfLines = 0
        locationLabel.text = userLocation
        locationLabel.textColor = primaryColor
        locationLabel.sizeToFit()
        
        return locationLabel
    }
    
    private func layoutLoginPanel() -> UIButton {
        let loginButton = UIButton()
        let loginLabel = UILabel()
        
        loginButton.backgroundColor = primaryColor
        loginButton.addSubview(loginLabel)
        
        loginLabel.font = UIFont(name: fontName, size: largeFontSize)
        loginLabel.text = "LOGIN / SIGN UP"
        loginLabel.textAlignment = .center
        loginLabel.textColor = primaryTextColor
        loginLabel.fillTo(loginButton)
        
        return loginButton
    }
}
