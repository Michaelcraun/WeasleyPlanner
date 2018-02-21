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
        recipes = []
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            print("ADD RECIPE: familySnapshot found!")
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                print("ADDRECIPE: familyName: \(familyName)")
                if familyName == userFamily {
                    guard let familyRecipes = family.childSnapshot(forPath: "recipes").value as? [Dictionary<String,Any>] else { return }
                    for recipe in familyRecipes {
                        guard let familyRecipe = recipe.toRecipe() else { return }
                        self.downloadImage(forRecipe: familyRecipe)
                        print("ADD RECIPE: familyRecipe.title: \(familyRecipe.title)")
                    }
                }
            }
        })
    }
    
    func downloadImage(forRecipe recipe: Recipe) {
        print("ADD RECIPE: imageName: \(recipe.imageName)")
        if recipe.imageName != "" {
            DataHandler.instance.REF_RECIPE_IMAGE.child("\(recipe.imageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                if let _ = error { return }
                guard let recipeImageData = data else { return }
                guard let recipeImage = UIImage(data: recipeImageData) else { return }
                print("ADD RECIPE: no errors encountered while downloading recipe image!")
                
                recipe.image = recipeImage
                self.recipes.append(recipe)
            })
        }
    }
}
