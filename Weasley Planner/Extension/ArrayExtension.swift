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
