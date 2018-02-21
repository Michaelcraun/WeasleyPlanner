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
        view.addSubview(searchBar)
        view.addSubview(recipeList)
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        searchBar.anchor(top: titleBar.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                         size: .init(width: 0, height: 30))
        
        recipeList.backgroundColor = .clear
        recipeList.dataSource = self
        recipeList.delegate = self
        recipeList.register(RecipeCell.self, forCellReuseIdentifier: "recipeCell")
        recipeList.separatorStyle = .none
        recipeList.anchor(top: searchBar.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }
}

extension RecipeListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipes.count > 0 {
            return recipes.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
        if recipes.count > 0 {
            cell.layoutCellForRecipe(recipes[indexPath.row])
        } else {
            cell.layoutCellForNoRecipes()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recipes.count > 0 {
            return 100
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! RecipeCell
        if let selectedRecipe = selectedCell.recipe {
            showOptionSheetForFamilyRecipe(selectedRecipe, atIndex: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //TODO: Make an image for this action
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
            let cell = tableView.cellForRow(at: indexPath) as! RecipeCell
            guard let recipeToDelete = cell.recipe else { return }
            
            self.removeRecipeFromFamily(recipeToDelete)
        }
        delete.image = #imageLiteral(resourceName: "familyIcon")
        
        let configuration = UISwipeActionsConfiguration.init(actions: [delete])
        return configuration
    }
}

extension RecipeListVC: ModernSearchBarDelegate {
    func getSearchableData() -> [String] {
        var searchableData: [String] {
            var _searchableData = [String]()
            for recipe in recipes {
                _searchableData.append(recipe.title)
            }
            return _searchableData
        }
        return searchableData
    }
    
    func onClickItemSuggestionsView(item: String) {
        //TODO: Implement a filter
    }
}
