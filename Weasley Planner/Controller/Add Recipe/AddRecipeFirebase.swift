//
//  AddRecipeFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/19/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import Firebase

extension AddRecipeVC {
    func observeFirebaseRecipes() {
        
    }
    
    func uploadRecipeToFamily(_ recipe: Recipe) {
        guard let userFamily = user?.family else { return }
        print("ADD RECIPE: found userFamily: \(userFamily)")
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                print("ADD RECIPE: found familyName: \(familyName)")
                if familyName == userFamily {
                    let recipeDictionary = recipe.dictionary()
                    self.uploadImage(withName: recipe.imageName, andImage: recipe.image)
                    if var familyRecipes = family.childSnapshot(forPath: "recipes").value as? [Dictionary<String,Any>] {
                        print("ADD RECIPE: Found existing recipes! Adding new one...")
                        familyRecipes.append(recipeDictionary)
                        DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["recipes" : familyRecipes])
                    } else {
                        print("ADD RECIPE: Couldn't find any existing recipes. Adding new one...")
                        DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["recipes" : [recipeDictionary]])
                    }
                }
            }
        })
    }
    
    func uploadRecipeToFirebase(_ recipe: Recipe) {
        let recipeData = recipe.dictionary()
        DataHandler.instance.updateFirebaseRecipe(id: recipe.identifier, recipeData: recipeData)
    }
    
    func uploadImage(withName name: String, andImage image: UIImage) {
        let croppedImage = image.cropSquare()
        let resizedImage = croppedImage.resizeImage(CGSize(width: 100, height: 100))
        guard let uploadData = UIImagePNGRepresentation(resizedImage) else {
            showAlert(.imageError)
            return
        }
        
        DataHandler.instance.REF_RECIPE_IMAGE.child("\(name).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
            if let _ = error {
                self.showAlert(.imageError)
                return
            }
        })
    }
}
