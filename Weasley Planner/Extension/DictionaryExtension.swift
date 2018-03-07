//
//  DictionaryExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import CoreLocation

extension Dictionary where Key == String {
    /// Instruction struct to allow ordering instructions
    private struct Instruction {
        var key: Int
        var instruction: String
    }
    
    /// Converst a dictionary fetched from Firebase into an Event
    /// - returns: An Event that contains the information stored on Firebase
    func toEvent() -> Event? {
        guard let dateString = self["date"] as? String else { return nil }
        guard let title = self["title"] as? String else { return nil }
        guard let type = self["type"] as? String else { return nil }
        guard let date = dateString.date() else { return nil }
        let eventIdentifier = DataHandler.instance.createUniqueIDString(with: title)
        
        let eventType: EventType = {
            switch type {
            case "appointment": return .appointment
            case "chore": return .chore
            default: return .meal
            }
        }()
        
        let fetchedEvent = Event(date: date, title: title, type: eventType, identifier: eventIdentifier)
        
        if let fetchedUser = self["user"] as? String {
            for familyUser in DataHandler.instance.familyUsers {
                if familyUser.name == fetchedUser {
                    fetchedEvent.assignedUser = familyUser
                }
            }
        }
        
        if let fetchedCoordinate = self["location"] as? [CLLocationDegrees] {
            let location = CLLocation(latitude: fetchedCoordinate[0], longitude: fetchedCoordinate[1])
            fetchedEvent.location = location
        }
        
        if let fetchedLocationString = self["locationString"] as? String {
            fetchedEvent.locationString = fetchedLocationString
        }
        
        if let fetchedRecurrenceString = self["recurrenceString"] as? String {
            fetchedEvent.recurrenceString = fetchedRecurrenceString
        }
        
        return fetchedEvent
    }
    
    /// Converts a dictionary fetched from Firebase into a Recipe
    /// - returns: A Recipe that contains the information stored on Firebase
    func toRecipe() -> Recipe? {
        guard let title = self["title"] as? String else { return nil }
        let recipeIdentifier = DataHandler.instance.createUniqueIDString(with: title)
        
        let fetchedRecipe = Recipe(identifier: recipeIdentifier, title: title)
        if let activeHours = self["activeHours"] as? Int { fetchedRecipe.activeHours = activeHours }
        if let activeMinutes = self["activeMinutes"] as? Int { fetchedRecipe.activeMinutes = activeMinutes }
        if let description = self["description"] as? String { fetchedRecipe.description = description }
        if let isFavorite = self["isFavorite"] as? Bool { fetchedRecipe.isFavorite = isFavorite }
        if let notes = self["notes"] as? String { fetchedRecipe.notes = notes }
        if let source = self["source"] as? String { fetchedRecipe.source = source }
        if let totalHours = self["totalHours"] as? Int { fetchedRecipe.totalHours = totalHours }
        if let totalMinutes = self["totalMintes"] as? Int { fetchedRecipe.totalMinutes = totalMinutes }
        if let url = self["url"] as? String { fetchedRecipe.url = url }
        if let yield = self["yield"] as? String { fetchedRecipe.yield = yield }
        if let imageName = self["imageName"] as? String { fetchedRecipe.imageName = imageName }
        if let ingredients = self["ingredients"] as? [String] {
            var recipeIngredients = [RecipeIngredient]()
            for ingredient in ingredients {
                let ingredientParts = ingredient.split(separator: "|")
                let ingredientQuantity = String(ingredientParts[0])
                let ingredientMeasurement = UnitOfMeasurement(rawValue: String(ingredientParts[1]))
                let ingredientItem = String(ingredientParts[2])
                
                let recipeIngredient = RecipeIngredient(quantity: ingredientQuantity, unitOfMeasurement: ingredientMeasurement!, item: ingredientItem)
                recipeIngredients.append(recipeIngredient)
            }
            fetchedRecipe.ingredients = recipeIngredients
        }
        if let instructions = self["instructions"] as? [[String : Any]] {
            var fetchedInstructions = [Instruction]()
            var instructionsToReturn = [String]()
            
            for instruction in instructions {
                if let key = instruction["key"] as? Int, let instruction = instruction["instruction"] as? String {
                    let instruction = Instruction(key: key, instruction: instruction)
                    fetchedInstructions.append(instruction)
                }
            }
            
            let orderedInstructions = fetchedInstructions.sorted(by: { (instruction0, instruction1) -> Bool in
                if instruction0.key < instruction1.key {
                    return instruction0.key < instruction1.key
                } else {
                    return instruction0.key < instruction1.key
                }
            })
            
            for instruction in orderedInstructions {
                instructionsToReturn.append(instruction.instruction)
            }
            fetchedRecipe.instructions = instructionsToReturn
        }
        return fetchedRecipe
    }
}
