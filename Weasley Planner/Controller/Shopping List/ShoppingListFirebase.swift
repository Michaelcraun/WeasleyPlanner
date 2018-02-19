//
//  ShoppingListFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import Firebase

extension ShoppingListVC {
    func observeFamilyShoppingList() {
        guard let familyName = user?.family, familyName != "" else { return }
        
        DataHandler.instance.REF_FAMILY.observe(.value, with: { (snapshot) in
            self.shoppingItems = []
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let name = family.childSnapshot(forPath: "name").value as? String else { return }
                if name == familyName {
                    guard let shoppingList = family.childSnapshot(forPath: "shoppingList").value as? [Dictionary<String,Any>] else { return }
                    for item in shoppingList {
                        guard let quantity = item["quantity"] as? Int else { return }
                        guard let name = item["name"] as? String else { return }
                        guard let obtained = item["obtained"] as? Bool else { return }
                        
                        let newItem = Item(quanity: quantity, name: name, obtained: obtained)
                        self.shoppingItems.append(newItem)
                    }
                }
            }
        })
    }
    
    func updateShoppingList() {
        guard let familyName = user?.family, familyName != "" else { return }
        var shoppingList: [Dictionary<String,Any>] {
            var _shoppingList = [Dictionary<String,Any>]()
            for item in shoppingItems {
                let itemAsDict: Dictionary<String,Any> = ["quantity" : item.quantity, "name" : item.name, "obtained" : item.obtained]
                _shoppingList.append(itemAsDict)
            }
            return _shoppingList
        }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let name = family.childSnapshot(forPath: "name").value as? String else { return }
                if name == familyName {
                    DataHandler.instance.updateFirebaseFamily(id: family.key, familyData: ["shoppingList" : shoppingList])
                }
            }
        })
    }
}