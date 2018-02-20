//
//  TextButton.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/10/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class TextButton: UIButton {
    var title: String? {
        didSet {
            updateTitle()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = primaryColor
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.tag = 1005
            label.text = title
            label.textColor = primaryTextColor
            label.textAlignment = .center
            return label
        }()
        
        self.addSubview(label)
        
        label.anchor(top: self.topAnchor,
                     leading: self.leadingAnchor,
                     trailing: self.trailingAnchor,
                     bottom: self.bottomAnchor)
    }
    
    func updateTitle() {
        for subview in self.subviews {
            if subview.tag == 1005 {
                guard let label = subview as? UILabel else { return }
                label.text = title
            }
        }
    }
}
