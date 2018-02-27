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
            imageView.addBorder()
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
        
        let addButton: UIView = {
            let view = UIView()
            let label = UILabel()
            
            view.addSubview(label)
            view.backgroundColor = primaryColor
            
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "ADD ITEM"
            label.textAlignment = .center
            label.textColor = primaryTextColor
            label.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.bottomAnchor,
                         padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(addButton)
        
        addButton.anchor(top: self.topAnchor,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         bottom: self.bottomAnchor,
                         padding: .init(top: 5, left: 5, bottom: 5, right: 5))
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
    
    func layoutCellForItem(_ item: Item) {
        clearCell()
        self.item = item
        
        let itemView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            view.addBorder()
            view.layer.cornerRadius = 5
            view.addLightShadows()
            
            let obtainedIndicator: UIView = {
                let indicator = UIView()
                indicator.addBorder()
                indicator.layer.cornerRadius = 5
                indicator.backgroundColor = {
                    switch item.obtained {
                    case true: return .green
                    case false: return .red
                    }
                }()
                return indicator
            }()
            
            let itemLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.textColor = secondaryTextColor
                label.text = {
                    if item.quantity == "" {
                        return item.name
                    } else {
                        return "\(item.quantity) \(item.name)"
                    }
                }()
                return label
            }()
            
            view.addSubview(obtainedIndicator)
            view.addSubview(itemLabel)
            
            obtainedIndicator.anchor(leading: view.leadingAnchor,
                                     centerY: view.centerYAnchor,
                                     padding: .init(top: 0, left: 5, bottom: 0, right: 0),
                                     size: .init(width: 15, height: 15))
            
            itemLabel.anchor(top: view.topAnchor,
                             leading: obtainedIndicator.trailingAnchor,
                             trailing: view.trailingAnchor,
                             bottom: view.bottomAnchor,
                             padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(itemView)
        
        itemView.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor,
                        padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
