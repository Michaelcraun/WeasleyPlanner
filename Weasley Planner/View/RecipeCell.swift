//
//  RecipeCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    var recipe: Recipe?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    func layoutCellForRecipe(_ recipe: Recipe) {
        clearCell()
        
        self.recipe = recipe
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            view.clipsToBounds = true
            view.layer.borderColor = primaryColor.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowOpacity = 0.75
            
            let recipeImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.clipsToBounds = true
                imageView.image = recipe.image
                imageView.layer.borderColor = primaryColor.cgColor
                imageView.layer.borderWidth = 1
                imageView.layer.cornerRadius = 5
                return imageView
            }()
            
            let sourceLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.text = recipe.source
                label.textColor = primaryTextColor
                return label
            }()
            
            let recipeTitle: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = recipe.title
                label.textColor = primaryTextColor
                return label
            }()
            
            view.addSubview(recipeImageView)
            view.addSubview(sourceLabel)
            view.addSubview(recipeTitle)
            
            recipeImageView.anchor(top: view.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                   size: .init(width: 90, height: 0))
            
            sourceLabel.anchor(top: view.topAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            recipeTitle.anchor(top: sourceLabel.bottomAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.bottomAnchor,
                               padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        
        cellView.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor,
                        padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForNoRecipes() {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            
            let defaultImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.clipsToBounds = true
                imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                imageView.layer.borderColor = primaryColor.cgColor
                imageView.layer.borderWidth = 1
                imageView.layer.cornerRadius = 25
                return imageView
            }()
            
            let defaultTitle: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = "No Recipes..."
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(defaultImageView)
            view.addSubview(defaultTitle)
            
            defaultImageView.anchor(top: view.topAnchor,
                                    leading: view.leadingAnchor,
                                    bottom: view.bottomAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                    size: .init(width: 50, height: 0))
            
            defaultTitle.anchor(top: view.topAnchor,
                                leading: defaultImageView.trailingAnchor,
                                trailing: view.trailingAnchor,
                                bottom: view.bottomAnchor,
                                padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        
        cellView.anchor(top: self.topAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        bottom: self.bottomAnchor,
                        padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
