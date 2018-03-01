//
//  RecipeListVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecipeListVC: UIViewController {
    //MARK: UI Variables
    let recipeList = UITableView()
    
    let searchBar: ModernSearchBar = {
        let bar = ModernSearchBar()
        bar.searchLabel_font = UIFont(name: fontName, size: smallFontSize)
        bar.searchLabel_textColor = primaryTextColor
        bar.searchLabel_backgroundColor = primaryColor
        bar.suggestionsView_maxHeight = 180
        bar.suggestionsView_separatorStyle = .none
        bar.suggestionsView_contentViewColor = primaryColor
        return bar
    }()
    
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Recipe List"
        return bar
    }()
    
    //MARK: Data Variables
    var user: User?
    var recipeSearched: Recipe?
    var isAddingFirebaseRecipe = false
    
//    var recipes = [Recipe]() {
//        didSet {
//            recipes = recipes.sortByTitle()
//            recipeList.reloadData()
//            searchBar.setDatas(datas: getSearchableData())
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        searchBar.delegateModernSearchBar = self
        
        observeFamilyRecipes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddRecipe" {
            if let destination = segue.destination as? AddRecipeVC {
                destination.transitioningDelegate = transitioningDelegate
                destination.modalPresentationStyle = .custom
                
                destination.isAddingFirebaseRecipe = isAddingFirebaseRecipe
                destination.user = user
                
                if let recipeToEdit = sender as? Recipe {
                    destination.recipeToEdit = recipeToEdit
                }
            }
        }
    }
    
    func showAddRecipeActionSheet() {
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let newRecipeAction = UIAlertAction(title: "New Recipe", style: .default) { (action) in
            self.isAddingFirebaseRecipe = false
            self.performSegue(withIdentifier: "showAddRecipe", sender: nil)
        }
        
        let firebaseRecipeAction = UIAlertAction(title: "From Firebase", style: .default) { (aciont) in
            self.isAddingFirebaseRecipe = true
            self.performSegue(withIdentifier: "showAddRecipe", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            optionSheet.dismiss(animated: true, completion: nil)
        }
        
        optionSheet.addAction(newRecipeAction)
        optionSheet.addAction(firebaseRecipeAction)
        optionSheet.addAction(cancelAction)
        
        present(optionSheet, animated: true, completion: nil)
    }
    
    func showOptionSheetForFamilyRecipe(_ recipe: Recipe, atIndex index: Int) {
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editRecipe = UIAlertAction(title: "Edit Recipe", style: .default) { (action) in
            self.isAddingFirebaseRecipe = false
            self.performSegue(withIdentifier: "showAddRecipe", sender: recipe)
        }
        
        let addIngredientsAction = UIAlertAction(title: "Add To Shopping List", style: .default) { (action) in
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.removeRecipeFromFamily(recipe)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            optionSheet.dismiss(animated: true, completion: nil)
        }
        
        optionSheet.addAction(editRecipe)
        optionSheet.addAction(addIngredientsAction)
        optionSheet.addAction(deleteAction)
        optionSheet.addAction(cancelAction)
        
        present(optionSheet, animated: true, completion: nil)
    }
}
