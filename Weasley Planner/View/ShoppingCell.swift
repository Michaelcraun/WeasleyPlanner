//
//  ShoppingCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell {
    var item: Item?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    func layoutCellForNoItems() {
        clearCell()
        
        let noItemsImage: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
            imageView.layer.cornerRadius = 20
            imageView.layer.borderColor = primaryColor.cgColor
            imageView.layer.borderWidth = 1
            return imageView
        }()
        
        let noItemsLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.sizeToFit()
            label.text = "No Items..."
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        
        self.addSubview(noItemsImage)
        self.addSubview(noItemsLabel)
        
        noItemsImage.anchor(top: self.topAnchor,
                            centerX: self.centerXAnchor,
                            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                            size: .init(width: 40, height: 40))
        
        noItemsLabel.anchor(leading: self.leadingAnchor,
                            trailing: self.trailingAnchor,
                            bottom: self.bottomAnchor,
                            padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForAddItem() {
        clearCell()
        
        let addButton: TextButton = {
            let button = TextButton()
            button.title = "ADD ITEM"
            return button
        }()
        
        self.addSubview(addButton)
        
        addButton.anchor(top: self.topAnchor,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         bottom: self.bottomAnchor,
                         padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForItem(_ item: Item) {
        clearCell()
        
        self.item = item
        let obtainedIndicator: UIView = {
            let indicator = UIView()
            indicator.layer.cornerRadius = 5
            indicator.layer.borderColor = primaryColor.cgColor
            indicator.layer.borderWidth = 1
            indicator.backgroundColor = {
                switch item.obtained {
                case true: return UIColor.green
                case false: return UIColor.red
                }
            }()
            return indicator
        }()
        
        let itemLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.text = {
                if item.quantity == 0 {
                    return item.name
                } else {
                    return "\(item.quantity) \(item.name)"
                }
            }()
            label.textColor = secondaryTextColor
            return label
        }()
        
        self.addSubview(obtainedIndicator)
        self.addSubview(itemLabel)
        
        obtainedIndicator.anchor(top: self.topAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 padding: .init(top: 10, left: 5, bottom: 10, right: 0),
                                 size: .init(width: 10, height: 0))
        
        itemLabel.anchor(top: self.topAnchor,
                         leading: obtainedIndicator.trailingAnchor,
                         trailing: self.trailingAnchor,
                         bottom: self.bottomAnchor,
                         padding: .init(top: 0, left: 5, bottom: 0, right: 0))
    }
    
    func layoutCellForPrevious(entry: String) {
        clearCell()
        
        let itemLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.text = entry
            label.textColor = secondaryTextColor
            return label
        }()
        
        self.addSubview(itemLabel)
        
        itemLabel.anchor(top: self.topAnchor,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         bottom: self.bottomAnchor)
    }
}
