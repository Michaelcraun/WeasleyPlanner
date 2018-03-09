//
//  Recipe.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

/// Represents a single recipe to be created and stored on Firebase and displayed to the user.
/// - important: The recipe's identifier, and title must be declared at the time of initialization. All
/// other variables are given defaults.
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
    
    /// The initializer for the Recipe class
    /// - parameter identifier: The String value that represents the unique identifier for the given recipe
    /// - parameter title: The String value that represents the title of the given recipe
    /// - parameter description: The String value that represents the description of the given recipe
    /// (defaults to an empty String)
    /// - parameter yield: The String value that represents the yield of the given recipe (defaults to an
    /// empty String)
    /// - parameter activeHours: An Integer value that represents the number of hours that the specified recipe
    /// requires the user to be actively working on it (defaults to 0)
    /// - parameter activeMinutes: An Integer value that represents the number of minutes that the specified recipe
    /// requires the user to be actively working on it (defaults to 0)
    /// - parameter totalHours: An Integer value that represents the number of hours that the specified recipe
    /// ultimately requires to make (defaults to 0)
    /// - parameter totalMinutes: An Integer value that represents the number of hours that the specified recipe
    /// ultimately requires to make (defaults to 0)
    /// - parameter isFavorite: A Boolean value that represents if the recipe is a favorite of the family (defaults to
    /// false)
    /// - parameter source: The String value that represents the source of the specified recipe (defaults to an empty
    /// String)
    /// - parameter url: The String value that represents the url where the user found the specified recipe (defualts
    /// to an empty String)
    /// - parameter notes: The String value that represents the notes of the specified recipe (defaults to an empty
    /// String)
    /// - parameter image: A UIImage value that represents the image of the specified recipe (defaults to the
    /// defaultProfileImage)
    /// - parameter imageName: A String value that represents the name of the image of the specified recipe (defaults to
    /// an empty String)
    /// - parameter ingredients: An Array of type RecipeIngredient that represents a list of ingredients required by
    /// the specified recipe (defaults to an empty Array)
    /// - parameter instructions: An Array of type String that represents a list of instruction of how to complete the
    /// specified recipe
    init(identifier: String, title: String, description: String = "", yield: String = "", activeHours: Int = 0, activeMinutes: Int = 0,
         totalHours: Int = 0, totalMinutes: Int = 0, isFavorite: Bool = false, source: String = "", url: String = "", notes: String = "",
         image: UIImage = #imageLiteral(resourceName: "defaultProfileImage"), imageName: String = "", ingredients: [RecipeIngredient] = [], instructions: [String] = []) {
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
    
    /// Converts a specified Recipe to a Dictionary of type [String : Any] to store on Firebase
    /// - returns: A Dictionary of type [String : Any] that represents the specified Recipe
    func dictionary() -> [String : Any] {
        var pushedDictionary = [String : Any]()
        pushedDictionary["activeHours"] = self.activeHours
        pushedDictionary["activeMinutes"] = self.activeMinutes
        pushedDictionary["description"] = self.description
        pushedDictionary["imageName"] = self.imageName
        pushedDictionary["ingredients"] = {
            var ingredients = [String]()
            for ingredient in self.ingredients {
                let ingredientString = ingredient.stringRepresentation
                ingredients.append(ingredientString)
            }
            print("INGREDIENTS: \(ingredients)")
            return ingredients
        }()
        pushedDictionary["instructions"] = {
            var instructions = [[String : Any]]()
            for i in 0..<self.instructions.count {
                let instructionDict: [String : Any] = ["key" : i,
                                                       "instruction" : self.instructions[i]]
                instructions.append(instructionDict)
            }
            print("INSTRUCTIONS: \(instructions)")
            return instructions
        }()
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

/// The RecipeIngredient struct that represents a single recipe ingredient
struct RecipeIngredient {
    var quantity: String
    var unitOfMeasurement: UnitOfMeasurement
    var item: String
    var stringRepresentation: String {
        return "\(quantity)|\(unitOfMeasurement.rawValue)|\(item)"
    }
}

/// An enumeration that represents the possible units of measurement. Also contains short hand notations and
/// conversion functions.
enum UnitOfMeasurement: String {
    case cup
    case dash
    case pinch
    case pound
    case tablespoon
    case teaspoon
    case whole
    
    var pluralRepresentation: String {
        switch self {
        case .cup: return "cups"
        case .dash: return "dashes"
        case .pinch: return "pinches"
        case .pound: return "pounds"
        case .tablespoon: return "tablespoons"
        case .teaspoon: return "teaspoons"
        case .whole: return "whole"
        }
    }
    
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
    
    func toCup(quantity: String) -> String {
        let string = ""
        return string
    }
    
    func toPound(quantity: String) -> String {
        let string = ""
        return string
    }
    
    func toTablespoon(quantity: String) -> String {
        let string = ""
        return string
    }
}
