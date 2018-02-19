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
            if let _ = delegate as? RecipeListVC {
                layoutAddButton()
            }
            
            layoutBackButton()
        }
    }
    
    func layoutAddButton() {
        let addButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
            button.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
            button.sizeToFit()
            return button
        }()
        
        self.addSubview(addButton)
        anchorButtonRight(addButton)
    }
    
    func layoutBackButton() {
        let backButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
            button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
            button.sizeToFit()
            return button
        }()
        
        self.addSubview(backButton)
        anchorButtonLeft(backButton)
    }
    
    func layoutSettingsButton() {
        let settingsButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
            button.setImage(#imageLiteral(resourceName: "settingsIcon"), for: .normal)
            button.sizeToFit()
            return button
        }()
        
        self.addSubview(settingsButton)
        anchorButtonLeft(settingsButton)
    }
    
    @objc func titleButtonPressed(_ sender: UIButton) {
        if let _ = delegate as? MainVC {
            delegate.performSegue(withIdentifier: "showSidePane", sender: nil)
        } else {
            switch sender.image(for: .normal)! {
            case #imageLiteral(resourceName: "backIcon"): delegate.dismiss(animated: true, completion: nil)
            case #imageLiteral(resourceName: "addIcon"):
                if let recipeVC = delegate as? RecipeListVC {
                    recipeVC.showAddRecipeActionSheet()
                } else if let _ = delegate as? CalendarVC {
                    delegate.performSegue(withIdentifier: "showAddEvent", sender: nil)
                }
            default: break
            }
        }
    }
    
    func anchorButtonLeft(_ button: UIButton) {
        button.anchor(leading: self.leadingAnchor,
                      bottom: self.bottomAnchor,
                      padding: .init(top: 0, left: 10, bottom: 5, right: 0),
                      size: .init(width: 30, height: 30))
    }
    
    func anchorButtonRight(_ button: UIButton) {
        button.anchor(trailing: self.trailingAnchor,
                      bottom: self.bottomAnchor,
                      padding: .init(top: 0, left: 10, bottom: 5, right: 10),
                      size: .init(width: 30, height: 30))
    }
}
