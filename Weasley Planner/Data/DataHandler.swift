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

/// A Singleton that serves as the access point to the Firebase database
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
    
    /// Creates a String that begins with a title and is appended with an NSUUID to serve as a unique
    /// identifier for Firebase data
    /// - parameter title: A String value that represents the title of whatever you wish
    /// - returns: A String value representing a uniquie identifier for a Firebase database child
    func createUniqueIDString(with title: String) -> String {
        var idString = title
        let idAppendage = NSUUID().uuidString
        idString += "-\(idAppendage)"
        return idString
    }
    
    //MARK: Firebase Family Methods
    /// Updates a specific Weasley Planner family child or creates a new family with the given id if
    /// one does not exist
    /// - parameter id: A String value that is the unique key for a specific family
    /// - parameter familyData: A Dictionary of type [String : Any] that represents the information for
    /// the specified family
    func updateFirebaseFamily(id: String, familyData: [String : Any]) {
        REF_FAMILY.child(id).updateChildValues(familyData)
    }
    
    /// Updates a specific Weasley Planner family recipe child or creates a new recipe with the given
    /// recipeID if one does not exist
    /// - parameter familyID: A String value that is the unique key for a specific family
    /// - parameter recipeID: A String value that is the unique key for a specific recipe
    /// - parameter recipeData: A Dictionary of type [String : Any] that represents the information for
    /// the specified recipe
    func updateFirebaseFamilyRecipe(familyID: String, recipeID: String, recipeData: [String : Any]) {
        REF_FAMILY.child(familyID).child("recipes").child(recipeID).updateChildValues(recipeData)
    }
    
    /// Removes a specific Weasley Planner family recipe child
    /// - parameter familyID: A String value that is the unique key for a specific family
    /// - parameter recipeID: A String value that is the unique key for a specific recipe
    func removeFirebaseFamilyRecipe(familyID: String, recipeID: String) {
        REF_FAMILY.child(familyID).child("recipes").child(recipeID).removeValue()
    }
    
    /// Updates a specific Weasley Planner family event child or creates a new event with the given
    /// eventID if one does not exist
    /// - parameter familyID: A String value that is the unique key for a specific family
    /// - parameter eventID: A String value that is the unique key for a specific event
    /// - parameter eventData: A Dictionary of type [String : Any] that represents the information for
    /// the specified event
    func updateFirebaseFamilyEvent(familyID: String, eventID: String, eventData: [String : Any]) {
        REF_FAMILY.child(familyID).child("events").child(eventID).updateChildValues(eventData)
    }
    
    /// Removes a specific Weasley Planner family event child
    /// - parameter familyID: A String value that is the unique key for a specific family
    /// - parameter recipeID: A String value that is the unique key for a specific event
    func removeFirebaseFamilyEvent(familyID: String, eventID: String) {
        REF_FAMILY.child(familyID).child("events").child(eventID).removeValue()
    }
    
    //MARK: Firebase Recipe Methods
    /// Updates a specific Weasley Planner recipe child or creates a new family with the given id if
    /// one does not exist
    /// - parameter id: A String value that is the unique key for a specific recipe
    /// - parameter recipeData: A Dictionary of type [String : Any] that represents the information for
    /// the specified recipe
    func updateFirebaseRecipe(id: String, recipeData: [String : Any]) {
        REF_RECIPE.child(id).updateChildValues(recipeData)
    }
    
    //MARK: Firebase User Methods
    /// Updates a specific Weasley Planner user child or creates a new user with the given uid if
    /// one does not exist
    /// - parameter uid: A String value that is the unique key for a specific user
    /// - parameter userData: A Dictionary of type [String : Any] that represents the information for
    /// the specified user
    func updateFirebaseUser(uid: String, userData: [String : Any]) {
        REF_USER.child(uid).updateChildValues(userData)
    }
}
