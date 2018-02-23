//
//  Recipe.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class Recipe {
    var identifier: String
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
    var imageName: String
    var ingredients: [RecipeIngredient]
    var instructions: [String]
    
    init(identifier: String, title: String, description: String = "", yield: String = "", activeHours: Int = 0, activeMinutes: Int = 0,
         totalHours: Int = 0, totalMinutes: Int = 0, isFavorite: Bool = false, source: String = "", url: String = "", notes: String = "",
         image: UIImage = #imageLiteral(resourceName: "defaultProfileImage"), imageName: String = "", ingredients: [RecipeIngredient] = [], instructions: [String] = [""]) {
        self.identifier = identifier
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
        self.imageName = imageName
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    func dictionary() -> Dictionary<String,Any> {
        var pushedDictionary = Dictionary<String,Any>()
        pushedDictionary["activeHours"] = self.activeHours
        pushedDictionary["activeMinutes"] = self.activeMinutes
        pushedDictionary["description"] = self.description
        pushedDictionary["imageName"] = self.imageName
        pushedDictionary["ingredients"] = self.ingredients
        pushedDictionary["instructions"] = self.instructions
        pushedDictionary["isFavorite"] = self.isFavorite
        pushedDictionary["notes"] = self.notes
        pushedDictionary["source"] = self.source
        pushedDictionary["title"] = self.title
        pushedDictionary["totalHours"] = self.totalHours
        pushedDictionary["totalMinutes"] = self.totalMinutes
        pushedDictionary["url"] = self.url
        pushedDictionary["yield"] = self.yield
        return pushedDictionary
    }
}

struct RecipeIngredient {
    var quantity: String
    var unitOfMeasurement: UnitOfMeasurement
    var item: String
    var stringRepresentation: String {
        return "\(quantity) \(unitOfMeasurement.rawValue) \(item)"
    }
}

enum UnitOfMeasurement: String {
    case cup
    case dash
    case pinch
    case pound
    case tablespoon
    case teaspoon
    case whole
    static var allUnits: [UnitOfMeasurement] = [.cup, .dash, .pinch, .pound, .tablespoon, .teaspoon, .whole]
    
    var shortHandNotation: String {
        switch self {
        case .cup: return "c."
        case .dash: return "dash"
        case .pinch: return "pinch"
        case .pound: return "lb."
        case .tablespoon: return "tbsp."
        case .teaspoon: return "tsp."
        case .whole: return "whole"
        }
    }
}
