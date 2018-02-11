//
//  TextButton.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class TextButton: UIButton {
    private let label = UILabel()
    var title: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = primaryColor
        self.addSubview(label)
        
        label.font = UIFont(name: fontName, size: largeFontSize)
        label.text = title
        label.textColor = primaryTextColor
        label.textAlignment = .center
        label.anchor(top: self.topAnchor,
                     leading: self.leadingAnchor,
                     trailing: self.trailingAnchor,
                     bottom: self.bottomAnchor)
    }
}
