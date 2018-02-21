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
        DataHandler.instance.REF_RECIPE.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let recipeSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for recipe in recipeSnapshot {
                guard let recipeData = recipe.value as? Dictionary<String,Any> else { return }
                if let firebaseRecipe = recipeData.toRecipe() {
                    if firebaseRecipe.imageName == "" {
                        self.firebaseRecipes.append(firebaseRecipe)
                    } else {
                        self.downloadImage(withRecipe: firebaseRecipe)
                    }
                }
            }
        })
    }
    
    func updateFamilyRecipe(_ recipe: Recipe) {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    let recipeData = recipe.dictionary()
                    self.uploadImage(withName: recipe.imageName, andImage: recipe.image)
                    DataHandler.instance.updateFirebaseFamilyRecipe(familyID: family.key, recipeID: recipe.identifier, recipeData: recipeData)
                }
            }
        })
    }
    
    func uploadRecipeToFirebase(_ recipe: Recipe) {
        let recipeData = recipe.dictionary()
        DataHandler.instance.updateFirebaseRecipe(id: recipe.identifier, recipeData: recipeData)
    }
    
    func downloadImage(withRecipe recipe: Recipe) {
        DataHandler.instance.REF_RECIPE_IMAGE.child("\(recipe.imageName).png").data(withMaxSize: 1000000, completion: { (data, error) in
            if let _ = error { return }
            guard let recipeImageData = data else { return }
            guard let recipeImage = UIImage(data: recipeImageData) else { return }
            
            recipe.image = recipeImage
            self.firebaseRecipes.append(recipe)
        })
    }
    
    func uploadImage(withName name: String, andImage image: UIImage) {
        let croppedImage = image.cropSquare()
        let resizedImage = croppedImage.resizeImage(CGSize(width: 500, height: 500))
        guard let uploadData = UIImagePNGRepresentation(resizedImage) else {
            showAlert(.imageError)
            return
        }
        
        DataHandler.instance.REF_RECIPE_IMAGE.child("\(name).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
            if let _ = error {
                self.showAlert(.imageError)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
