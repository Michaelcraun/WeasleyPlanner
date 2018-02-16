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
    let subtitleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = primaryColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.5
        
        subtitleLabel.font = UIFont(name: fontName, size: smallFontSize)
        subtitleLabel.text = "Family"
        subtitleLabel.textColor = primaryTextColor
        subtitleLabel.sizeToFit()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: fontName, size: largeFontSize)
        titleLabel.text = "Weasley Planner"
        titleLabel.textColor = primaryTextColor
        titleLabel.sizeToFit()
        
        self.addSubview(subtitleLabel)
        self.addSubview(titleLabel)
        
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
