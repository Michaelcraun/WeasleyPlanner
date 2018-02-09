//
//  UserPane.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class UserPane: UIView {
    var userIcon: UIImage?
    var userName: String!
    var userLocation: String!
    var userStatus: Bool!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = secondaryColor
        
        let userIconView = layoutProfileIcon()
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
                            size: .init(width: self.frame.height - 10, height: 0))
        
        statusIconView.anchor(top: userIconView.topAnchor,
                              trailing: userIconView.trailingAnchor,
                              size: .init(width: 15, height: 15))
        
        userNameLabel.anchor(top: self.topAnchor,
                             leading: userIconView.trailingAnchor,
                             trailing: self.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        
        locationLabel.anchor(leading: userIconView.trailingAnchor,
                             trailing: self.trailingAnchor,
                             bottom: self.bottomAnchor,
                             padding: .init(top: 5, left: 5, bottom: 5, right: 0))
    }
    
    func layoutProfileIcon() -> UIImageView {
        let iconView = UIImageView()
        iconView.layer.cornerRadius = (self.frame.height - 10) / 2
        iconView.layer.borderColor = primaryColor.cgColor
        iconView.layer.borderWidth = 1
        
        if let image = userIcon {
            //TODO: Set iconView.image = image
        } else {
            //TODO: Set iconView.image = defaultProfileImage
        }
        
        return iconView
    }
    
    func layoutStatusIcon() -> UIView {
        let statusIcon = UIView()
        statusIcon.layer.cornerRadius = 7.5
        statusIcon.layer.borderColor = primaryColor.cgColor
        statusIcon.layer.borderWidth = 1
        
        if let status = userStatus {
            switch status {
            case true: statusIcon.backgroundColor = .green
            case false: statusIcon.backgroundColor = .red
            }
        }
        
        return statusIcon
    }
    
    func layoutUserNameLabel() -> UILabel {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont(name: fontName, size: mediumFontSize)
        userNameLabel.text = userName
        userNameLabel.textColor = secondaryTextColor
        userNameLabel.sizeToFit()
        
        return userNameLabel
    }
    
    func layoutLocationLabel() -> UILabel {
        let locationLabel = UILabel()
        locationLabel.font = UIFont(name: fontName, size: smallFontSize)
        locationLabel.text = userLocation
        locationLabel.textColor = primaryColor
        locationLabel.sizeToFit()
        
        return locationLabel
    }
}
