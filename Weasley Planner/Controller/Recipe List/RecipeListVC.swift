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
    var searchListHeight: NSLayoutConstraint!
    
    let searchField: InputView = {
        let field = InputView()
        field.addDeepShadows()
        field.inputField.delegate = textManager
        field.inputType = .search
        return field
    }()
    
    let recipeList: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "recipeCell")
        return tableView
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        return view
    }()
    
    let searchList: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()
    
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Recipe List"
        return bar
    }()
    
    //MARK: Data Variables
    var user: User?
    var isAddingFirebaseRecipe = false
    var matchingRecipes = [Recipe]() {
        didSet {
            searchList.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textManager.delegate = self
        titleBar.delegate = self
        
        observeFamilyRecipes()
        displayLoadingView(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.displayLoadingView(false) }
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
            var ingredientsToAdd = [[String : Any]]()
            let selectedRecipe = DataHandler.instance.familyRecipes[index]
            for ingredient in selectedRecipe.ingredients {
                let newShoppingItem = Item(quantity: ingredient.quantity,
                                           unitOfMeasurement: ingredient.unitOfMeasurement,
                                           name: ingredient.item,
                                           obtained: false)
                let shoppingItemAsDict = newShoppingItem.dictionary()
                ingredientsToAdd.append(shoppingItemAsDict)
            }
            self.addRecipeIngredientsToShoppingList(ingredientsToAdd)
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
