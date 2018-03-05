//
//  ArrayExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/21/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

//----------------------------
// MARK: - [Recipe] extensions
//----------------------------
extension Array where Array == [Recipe] {
    /// Searches the title of a given Array of Recipe, filtering the ones that contain the given String
    /// - parameter searchText: The String value to search the Array of Recipe for
    /// - returns: A filtered Array of Recipe where the title of those Recipes contains the given searchText
    func filterByTitle(searchText: String) -> [Recipe] {
        var filteredRecipes = [Recipe]()
        for recipe in self {
            if recipe.title.contains(searchText) {
                filteredRecipes.append(recipe)
            }
        }
        return filteredRecipes
    }
    
    /// Sorts a given Array of Recipe by title
    /// - returns: An Array of Recipe sorted by title
    func sortByTitle() -> [Recipe] {
        let sortedArray = self.sorted { (recipe1, recipe2) -> Bool in
            if recipe1.title == recipe2.title {
                return recipe1.title < recipe2.title
            } else {
                return recipe1.title < recipe2.title
            }
        }
        return sortedArray
    }
    
    /// Sorts a given Array of Recipe by active time
    /// - returns: An Array of Recipe sorted by active time
    func sortByActiveTime() -> [Recipe] {
        let sortedArray = self.sorted { (recipe1, recipe2) -> Bool in
            let recipe1Time = (recipe1.activeHours * 60) + recipe1.activeMinutes
            let recipe2Time = (recipe2.activeHours * 60) + recipe2.activeMinutes
            if recipe1Time < recipe2Time {
                return recipe1.title < recipe2.title
            } else {
                return recipe1.title < recipe2.title
            }
        }
        return sortedArray
    }
    
    /// Sorts a given Array of Recipe by total time
    /// - returns: An Array of Recipe sorted by total time
    func sortByTotalTime() -> [Recipe] {
        let sortedArray = self.sorted { (recipe1, recipe2) -> Bool in
            let recipe1Time = (recipe1.totalHours * 60) + recipe1.totalMinutes
            let recipe2Time = (recipe2.totalHours * 60) + recipe2.totalMinutes
            if recipe1Time < recipe2Time {
                return recipe1.title < recipe2.title
            } else {
                return recipe1.title < recipe2.title
            }
        }
        return sortedArray
    }
    
    /// Sorts a given Array of Recipe by title to return an alphebetized list of Recipe titles
    /// - returns: An Array of String where each item represents the title of a Recipe
    func getTitles() -> [String] {
        let sortedRecipes = self.sortByTitle()
        var recipeTitles = [String]()
        for recipe in sortedRecipes {
            let recipeTitle = recipe.title
            recipeTitles.append(recipeTitle)
        }
        return recipeTitles
    }
}

//---------------------------
// MARK: - [Event] extensions
//---------------------------
extension Array where Array == [Event] {
    /// Searches the date of a given Array of Event, filtering the ones that match the given Date
    /// - parameter selectedDay: The Date value to filter for
    /// - returns: An Array of Event that have a date matching the given selectedDay
    func filterForDay(_ selectedDay: Date) -> [Event] {
        var dayEvents = [Event]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let selectedDate = formatter.string(from: selectedDay)
        
        for event in self {
            let eventDate = formatter.string(from: event.date)
            
            if eventDate == selectedDate {
                dayEvents.append(event)
            }
        }
        return dayEvents
    }
    
    /// Searches a given Array of Event, filtering the events that are appointments
    /// - returns: An Array of Events that have a type of .appointment
    func filterAppointments() -> [Event] {
        var appointmentsArray = [Event]()
        for event in self {
            if event.type == .appointment {
                appointmentsArray.append(event)
            }
        }
        return appointmentsArray
    }
    
    /// Searches a given Array of Event, filtering the events that are chores
    /// - returns: An Array of Events that have a type of .chore
    func filterChores() -> [Event] {
        var choresArray = [Event]()
        for event in self {
            if event.type == .chore {
                choresArray.append(event)
            }
        }
        return choresArray
    }
    
    /// Searches a given Array of Event, filtering the events that are meals
    /// - returns: An Array of Events that have a type of .meal
    func filterMeals() -> [Event] {
        var mealsArray = [Event]()
        for event in self {
            if event.type == .meal {
                mealsArray.append(event)
            }
        }
        return mealsArray
    }
    
    /// Sorts a given Array of Event in order of date
    /// - returns: An Array of Event sorted by the day and time they are due
    func sortByTime() -> [Event] {
        let sortedArray = self.sorted { (event1, event2) -> Bool in
            if event1.date == event2.date {
                return event1.date < event2.date
            } else {
                return event1.date < event2.date
            }
        }
        return sortedArray
    }
}
