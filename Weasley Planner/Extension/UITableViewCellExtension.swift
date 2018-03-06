//
//  UITableViewCellExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Clears cell of all subviews. Should be used before layout of cell.
    func clearCell() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// Used to layout cell for cancelling user input
    func layoutCancelCell() {
        //TODO: Layout for cell
        let cancelLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Cancel"
            label.textAlignment = .center
            label.textColor = primaryTextColor
            return label
        }()
        
        self.addSubview(cancelLabel)
        cancelLabel.fillTo(self)
    }
    
    /// Used to layout cell when no items of a specific type are present.
    /// - parameter item: The singular item to display to the user (i.e, "Item" or "User" will display as "Items" or "Users"
    func layoutCellForNo(_ item: String) {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.backgroundColor = secondaryColor
            view.layer.cornerRadius = 5
            
            let noEventsImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.addBorder()
                imageView.contentMode = .scaleAspectFit
                imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                imageView.layer.cornerRadius = 15
                return imageView
            }()
            
            let noEventsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.text = "No \(item)s..."
                label.textAlignment = .center
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(noEventsLabel)
            view.addSubview(noEventsImageView)
            
            noEventsLabel.anchor(leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 bottom: view.bottomAnchor)
            
            noEventsImageView.anchor(top: view.topAnchor,
                                     centerX: view.centerXAnchor,
                                     padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                                     size: .init(width: 30, height: 30))
            
            return view
        }()
        
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
