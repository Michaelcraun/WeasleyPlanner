//
//  DictionaryExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func toRecipe() -> Recipe? {
        guard let title = self["title"] as? String else { return nil }
        let recipeIdentifier = DataHandler.instance.createRecipeIDString(with: title)
        
        let fetchedRecipe = Recipe(identifier: recipeIdentifier, title: title)
        if let activeHours = self["activeHours"] as? Int { fetchedRecipe.activeHours = activeHours }
        if let activeMinutes = self["activeMinutes"] as? Int { fetchedRecipe.activeMinutes = activeMinutes }
        if let description = self["description"] as? String { fetchedRecipe.description = description }
//        if let ingredients = self["ingredients"] as? String { fetchedRecipe.ingredients = ingredients }
//        if let instructions = self["instructions"] as? String { fetchedRecipe.instructions = instructions }
        if let isFavorite = self["isFavorite"] as? Bool { fetchedRecipe.isFavorite = isFavorite }
        if let notes = self["notes"] as? String { fetchedRecipe.notes = notes }
        if let source = self["source"] as? String { fetchedRecipe.source = source }
        if let totalHours = self["totalHours"] as? Int { fetchedRecipe.totalHours = totalHours }
        if let totalMinutes = self["totalMintes"] as? Int { fetchedRecipe.totalMinutes = totalMinutes }
        if let url = self["url"] as? String { fetchedRecipe.url = url }
        if let yield = self["yield"] as? String { fetchedRecipe.yield = yield }
        if let imageName = self["imageName"] as? String { fetchedRecipe.imageName = imageName }
        
        return fetchedRecipe
    }
}
