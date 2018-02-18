//
//  Recipe.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class Recipe {
    var title: String
    var description: String
    var yield: String
    var activeHours: Int
    var activeMinutes: Int
    var totalHours: Int
    var totalMinutes: Int
    //var categories: [RecipeCategory]
    var isFavorite: Bool
    var source: String
    var url: String
    var notes: String
    var image: UIImage
    var ingredients: String
    var instructions: String
    
    init(title: String, description: String = "", yield: String = "", activeHours: Int = 0, activeMinutes: Int = 0, totalHours: Int = 0,
         totalMinutes: Int = 0, isFavorite: Bool = false, source: String = "", url: String = "", notes: String = "", image: UIImage = #imageLiteral(resourceName: "defaultProfileImage"),
         ingredients: String = "", instructions: String = "") {
        self.title = title
        self.description = description
        self.yield = yield
        self.activeHours = activeHours
        self.activeMinutes = activeMinutes
        self.totalHours = totalHours
        self.totalMinutes = totalMinutes
        self.isFavorite = isFavorite
        self.source = source
        self.url = url
        self.notes = notes
        self.image = image
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    //function for getting list of ingredients?
    //function for getting list of instructions
}
