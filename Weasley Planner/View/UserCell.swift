//
//  UserCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    private let userPane = UserPane()
    private let defaultIconView = UIImageView()
    private let noUserLabel = UILabel()
    var user: User?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    func layoutCellForUser(_ user: User) {
        clearCell()
        
        self.user = user
        self.addSubview(userPane)
        
        userPane.userIcon = user.icon
        userPane.userLocation = user.location
        userPane.userName = user.name
        userPane.userStatus = user.status
        userPane.layoutForUser(with: 60)
        userPane.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor,
                        padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutNoUserCell() {
        clearCell()
        
        self.addSubview(defaultIconView)
        self.addSubview(noUserLabel)
        
        defaultIconView.clipsToBounds = true
        defaultIconView.contentMode = .scaleAspectFit
        defaultIconView.image = #imageLiteral(resourceName: "defaultProfileImage")
        defaultIconView.layer.borderColor = primaryColor.cgColor
        defaultIconView.layer.borderWidth = 1
        defaultIconView.layer.cornerRadius = 15
        defaultIconView.anchor(top: self.topAnchor,
                               centerX: self.centerXAnchor,
                               padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                               size: .init(width: 30, height: 30))
        
        noUserLabel.font = UIFont(name: fontName, size: smallFontSize)
        noUserLabel.text = "No Users..."
        noUserLabel.textColor = secondaryTextColor
        noUserLabel.textAlignment = .center
        noUserLabel.anchor(leading: self.leadingAnchor,
                           trailing: self.trailingAnchor,
                           bottom: self.bottomAnchor,
                           padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }
}
