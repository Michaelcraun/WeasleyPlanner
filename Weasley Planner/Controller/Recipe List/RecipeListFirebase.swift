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
        
        DataHandler.instance.REF_FAMILY.observe(.value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    guard let familyRecipes = family.childSnapshot(forPath: "recipes").value as? [Dictionary<String,Any>] else { return }
                    for recipe in familyRecipes {
                        self.convertFirebaseRecipeDictionaryIntoRecipe(recipe)
                    }
                }
            }
        })
    }
    
    func updateFamilyRecipes() {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    var recipeDictionaries = [Dictionary<String,Any>]()
                    for recipe in self.recipes {
                        let recipeDict = recipe.convertIntoFirebaseRecipeDictionary()
                        recipeDictionaries.append(recipeDict)
                    }
                    DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["recipes" : recipeDictionaries])
                }
            }
        })
    }
    
    func convertFirebaseRecipeDictionaryIntoRecipe(_ dictionary: Dictionary<String,Any>) {
        guard let title = dictionary["title"] as? String else { return }
        
        let fetchedRecipe = Recipe(title: title)
        if let activeHours = dictionary["activeHours"] as? Int { fetchedRecipe.activeHours = activeHours }
        if let activeMinutes = dictionary["activeMinutes"] as? Int { fetchedRecipe.activeMinutes = activeMinutes }
        if let description = dictionary["description"] as? String { fetchedRecipe.description = description }
        if let ingredients = dictionary["ingredients"] as? String { fetchedRecipe.ingredients = ingredients }
        if let instructions = dictionary["instructions"] as? String { fetchedRecipe.instructions = instructions }
        if let isFavorite = dictionary["isFavorite"] as? Bool { fetchedRecipe.isFavorite = isFavorite }
        if let notes = dictionary["notes"] as? String { fetchedRecipe.notes = notes }
        if let source = dictionary["source"] as? String { fetchedRecipe.source = source }
        if let totalHours = dictionary["totalHours"] as? Int { fetchedRecipe.totalHours = totalHours }
        if let totalMinutes = dictionary["totalMintes"] as? Int { fetchedRecipe.totalMinutes = totalMinutes }
        if let url = dictionary["url"] as? String { fetchedRecipe.url = url }
        if let imageName = dictionary["imageName"] as? String {
            fetchedRecipe.imageName = imageName
            DataHandler.instance.REF_RECIPE_IMAGE.child("\(imageName).png").data(withMaxSize: 50000, completion: { (data, error) in
                if let _ = error { return }
                guard let recipeImageData = data else { return }
                guard let recipeImage = UIImage(data: recipeImageData) else { return }
                
                fetchedRecipe.image = recipeImage
                self.recipes.append(fetchedRecipe)
            })
        }
    }
}
