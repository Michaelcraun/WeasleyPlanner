//
//  ArrayExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/21/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Array where Array == [Recipe] {
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
}

extension Array where Array == [Event] {
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
    
    func filterAppointments() -> [Event] {
        var appointmentsArray = [Event]()
        for event in self {
            if event.type == .appointment {
                appointmentsArray.append(event)
            }
        }
        return appointmentsArray
    }
    
    func filterChores() -> [Event] {
        var choresArray = [Event]()
        for event in self {
            if event.type == .chore {
                choresArray.append(event)
            }
        }
        return choresArray
    }
    
    func filterMeals() -> [Event] {
        var mealsArray = [Event]()
        for event in self {
            if event.type == .meal {
                mealsArray.append(event)
            }
        }
        return mealsArray
    }
    
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
