//
//  TitleBar.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class TitleBar: UIView {
    var delegate: UIViewController!
    var subtitle: String!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.text = subtitle
            label.textColor = primaryTextColor
            label.sizeToFit()
            return label
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Weasley Planner"
            label.textColor = primaryTextColor
            label.sizeToFit()
            return label
        }()
        
        self.addSubview(subtitleLabel)
        self.addSubview(titleLabel)
        self.backgroundColor = primaryColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.5
        
        subtitleLabel.anchor(bottom: self.bottomAnchor,
                             centerX: self.centerXAnchor)
        
        titleLabel.anchor(bottom: subtitleLabel.topAnchor,
                          centerX: self.centerXAnchor)
        
        if let _ = delegate as? MainVC {
            layoutSettingsButton()
        } else {
            layoutBackButton()
        }
    }
    
    func layoutBackButton() {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        
        self.addSubview(backButton)
        
        backButton.anchor(leading: self.leadingAnchor,
                          bottom: self.bottomAnchor,
                          padding: .init(top: 0, left: 10, bottom: 5, right: 0),
                          size: .init(width: 30, height: 30))
    }
    
    func layoutSettingsButton() {
        let settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settingsIcon"), for: .normal)
        settingsButton.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
        settingsButton.sizeToFit()
        
        self.addSubview(settingsButton)
        
        settingsButton.anchor(leading: self.leadingAnchor,
                              bottom: self.bottomAnchor,
                              padding: .init(top: 0, left: 10, bottom: 5, right: 0),
                              size: .init(width: 30, height: 30))
    }
    
    @objc func titleButtonPressed(_ sender: UIButton) {
        if let _ = delegate as? MainVC {
            delegate.performSegue(withIdentifier: "showSidePane", sender: nil)
        } else {
            delegate.dismiss(animated: true, completion: nil)
        }
    }
}
