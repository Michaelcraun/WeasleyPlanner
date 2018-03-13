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
            label.fillTo(view, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        self.addSubview(addButton)
        addButton.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForPrevious(entry: String) {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.backgroundColor = secondaryColor
            view.layer.cornerRadius = 5
            
            let itemLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallerFontSize)
                label.text = entry
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(itemLabel)
            itemLabel.fillTo(view, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
            return view
        }()
        
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForItem(_ item: Item) {
        clearCell()
        self.item = item
        
        let itemView: UIView = {
            let view = UIView()
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.backgroundColor = secondaryColor
            view.layer.cornerRadius = 5
            
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
                label.text = item.stringRepresentation()
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
        itemView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
