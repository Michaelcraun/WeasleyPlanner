//
//  RecipeListLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension RecipeListVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(recipeList)
        view.addSubview(shadowView)
        view.addSubview(titleBar)
        view.addSubview(searchField)
        view.addSubview(searchList)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        shadowView.fillTo(view)
        
        searchField.anchor(top: titleBar.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .init(width: 0, height: 30))
        
        searchListHeight = NSLayoutConstraint(item: searchList,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 0)
        
        searchList.addConstraint(searchListHeight)
        searchList.backgroundColor = primaryColor
        searchList.dataSource = self
        searchList.delegate = self
        searchList.separatorStyle = .none
        searchList.anchor(top: searchField.bottomAnchor,
                          leading: searchField.leadingAnchor,
                          trailing: searchField.trailingAnchor,
                          padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        recipeList.backgroundColor = .clear
        recipeList.dataSource = self
        recipeList.delegate = self
        recipeList.separatorStyle = .none
        recipeList.anchor(top: searchField.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }
}

//-------------------------------------------
// MARK: - TABLE VIEW DATASOURCE AND DELEGATE
//-------------------------------------------
extension RecipeListVC: UITableViewDataSource, UITableViewDelegate {
    func animateTableView(_ tableView: UITableView, shouldOpen: Bool) {
        var heightConstant: CGFloat {
            switch shouldOpen {
            case true: return 180
            case false: return 0
            }
        }
        
        var heightConstraint: NSLayoutConstraint {
            tableView.removeConstraint(searchListHeight)
            searchListHeight = NSLayoutConstraint(item: tableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: heightConstant)
            return searchListHeight
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            tableView.frame.size.height = heightConstant
        }, completion: { (finished) in
            tableView.addConstraint(heightConstraint)
            tableView.updateConstraints()
            
            if shouldOpen {
                self.shadowView.isHidden = false
                tableView.reloadData()
            } else {
                self.shadowView.isHidden = true
                self.searchField.inputField.text = ""
                self.matchingRecipes = []
                self.view.endEditing(true)
            }
        })
    }
    
    func performRecipeSearch(searchText: String) {
        matchingRecipes.removeAll()
        matchingRecipes = DataHandler.instance.familyRecipes.filterByTitle(searchText: searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recipeList {
            switch DataHandler.instance.familyRecipes.count {
            case 0: return 1
            default: return DataHandler.instance.familyRecipes.count
            }
        } else {
            return matchingRecipes.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recipeList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
            switch DataHandler.instance.familyRecipes.count {
            case 0: cell.layoutCellForNo("Recipe")
            default: cell.layoutCellForRecipe(DataHandler.instance.familyRecipes[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! RecipeCell
            switch indexPath.row {
            case 0: cell.layoutCancelCell()
            default: cell.layoutCellForRecipe(matchingRecipes[indexPath.row - 1])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recipeList {
            switch DataHandler.instance.familyRecipes.count {
            case 0: return 70
            default: return 100
            }
        } else {
            switch indexPath.row {
            case 0: return 40
            default: return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! RecipeCell
        if tableView == recipeList {
            view.endEditing(true)
            animateTableView(searchList, shouldOpen: false)
            searchField.inputField.text = ""
            if let selectedRecipe = selectedCell.recipe { showOptionSheetForFamilyRecipe(selectedRecipe, atIndex: indexPath.row) }
        } else {
            switch indexPath.row {
            case 0: animateTableView(searchList, shouldOpen: false)
            default:
                if let selectedRecipe = selectedCell.recipe { showOptionSheetForFamilyRecipe(selectedRecipe, atIndex: indexPath.row) }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == recipeList {
            let delete = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
                let cell = tableView.cellForRow(at: indexPath) as! RecipeCell
                guard let recipeToDelete = cell.recipe else { return }
                
                self.removeRecipeFromFamily(recipeToDelete)
            }
            delete.image = #imageLiteral(resourceName: "deleteIcon")
            
            let configuration = UISwipeActionsConfiguration.init(actions: [delete])
            return configuration
        } else {
            return nil
        }
    }
}
