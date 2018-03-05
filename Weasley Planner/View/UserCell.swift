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
        userPane.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
