//
//  RecipeListFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import Firebase

extension RecipeListVC {
    func observeFamilyRecipes() {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    if family.hasChild("recipes") {
                        let familyRecipes = family.childSnapshot(forPath: "recipes")
                        guard let recipeSnapshot = familyRecipes.children.allObjects as? [FIRDataSnapshot] else { return }
                        if recipeSnapshot.count != DataHandler.instance.familyRecipes.count {
                            DataHandler.instance.familyRecipes = []
                            for recipe in recipeSnapshot {
                                guard let recipeData = recipe.value as? Dictionary<String,Any> else { return }
                                guard let familyRecipe = recipeData.toRecipe() else { return }
                                familyRecipe.identifier = recipe.key
                                self.downloadImage(forRecipe: familyRecipe)
                            }
                        }
                    }
                }
            }
        })
    }
    
    func downloadImage(forRecipe recipe: Recipe) {
        if recipe.imageName != "" {
            DataHandler.instance.REF_RECIPE_IMAGE.child("\(recipe.imageName).png").data(withMaxSize: 1000000, completion: { (data, error) in
                if let _ = error { return }
                guard let recipeImageData = data else { return }
                guard let recipeImage = UIImage(data: recipeImageData) else { return }
                
                recipe.image = recipeImage
                DataHandler.instance.familyRecipes.append(recipe)
                self.recipeList.reloadData()
            })
        }
    }
    
    func removeRecipeFromFamily(_ recipe: Recipe) {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    DataHandler.instance.removeFirebaseFamilyRecipe(familyID: family.key, recipeID: recipe.identifier)
                    self.observeFamilyRecipes()
                }
            }
        })
    }
    
    func addRecipeIngredientsToShoppingList(_ ingredients: [[String : Any]]) {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    var shoppingList = ingredients
                    guard let currentShoppingList = family.childSnapshot(forPath: "shoppingList").value as? [[String : Any]] else {
                        DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["shoppingList" : shoppingList])
                        return
                    }
                    
                    for item in currentShoppingList { shoppingList.append(item) }
                    DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["shoppingList" : shoppingList])
                }
            }
        }
    }
}
