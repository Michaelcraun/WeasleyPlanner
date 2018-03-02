//
//  AddEventFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/27/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Firebase

extension AddEventVC {
    func updateFamilyEvent(_ event: Event) {
        guard let userFamily = user?.family else {
            print("EVENT: Unable to determine user's family name...")
            return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            print("EVENT: Found family snapshot...")
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                print("EVENT: Found family name: \(familyName)...")
                if familyName == userFamily {
                    let eventData = event.dictionary()
                    DataHandler.instance.updateFirebaseFamilyEvent(familyID: family.key, eventID: event.identifier, eventData: eventData)
                    print("EVENT: Event saved!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
