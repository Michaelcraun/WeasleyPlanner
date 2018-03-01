//
//  DataHandler.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataHandler {
    static let instance = DataHandler()
    
    var familyUsers = [User]()
    var segueIdentifier: String!
    
    var familyEvents = [Event]() {
        didSet {
            familyEvents = familyEvents.sortByTime()
        }
    }
    
    var familyRecipes = [Recipe]() {
        didSet {
            familyRecipes = familyRecipes.sortByTitle()
        }
    }
    
    //MARK: Firebase Variables
    var currentUserID = FIRAuth.auth()?.currentUser?.uid
    
    private var _REF_BASE = DB_BASE
    private var _REF_FAMILY = DB_BASE.child("family")
    private var _REF_RECIPE = DB_BASE.child("recipe")
    private var _REF_USER = DB_BASE.child("user")
    private var _REF_STORAGE = STORAGE_BASE
    private var _REF_PROFILE_IMAGE = STORAGE_BASE.child("profileImage")
    private var _REF_RECIPE_IMAGE = STORAGE_BASE.child("recipeImage")
    
    var REF_BASE: FIRDatabaseReference { return _REF_BASE }
    var REF_FAMILY: FIRDatabaseReference { return _REF_FAMILY }
    var REF_RECIPE: FIRDatabaseReference { return _REF_RECIPE }
    var REF_USER: FIRDatabaseReference { return _REF_USER }
    var REF_STORAGE: FIRStorageReference { return _REF_STORAGE }
    var REF_PROFILE_IMAGE: FIRStorageReference { return _REF_PROFILE_IMAGE }
    var REF_RECIPE_IMAGE: FIRStorageReference { return _REF_RECIPE_IMAGE }
    
    func createUniqueIDString(with title: String) -> String {
        var idString = title
        let idAppendage = NSUUID().uuidString
        idString += "-\(idAppendage)"
        return idString
    }
    
    //MARK: Firebase Family Methods
    func updateFirebaseFamily(id: String, familyData: [String : Any]) {
        REF_FAMILY.child(id).updateChildValues(familyData)
    }
    
    func updateFirebaseFamilyRecipe(familyID: String, recipeID: String, recipeData: [String : Any]) {
        REF_FAMILY.child(familyID).child("recipes").child(recipeID).updateChildValues(recipeData)
    }
    
    func removeFirebaseFamilyRecipe(familyID: String, recipeID: String) {
        REF_FAMILY.child(familyID).child("recipes").child(recipeID).removeValue()
    }
    
    func updateFirebaseFamilyEvent(familyID: String, eventID: String, eventData: [String : Any]) {
        REF_FAMILY.child(familyID).child("events").child(eventID).updateChildValues(eventData)
    }
    
    func removeFirebaseFamilyEvent(familyID: String, eventID: String) {
        REF_FAMILY.child(familyID).child("events").child(eventID).removeValue()
    }
    
    //MARK: Firebase Recipe Methods
    func updateFirebaseRecipe(id: String, recipeData: [String : Any]) {
        REF_RECIPE.child(id).updateChildValues(recipeData)
    }
    
    //MARK: Firebase User Methods
    func updateFirebaseUser(uid: String, userData: [String : Any]) {
        REF_USER.child(uid).updateChildValues(userData)
    }
}
