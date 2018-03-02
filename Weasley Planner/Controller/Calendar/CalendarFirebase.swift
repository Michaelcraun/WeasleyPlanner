//
//  CalendarFirebase.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import Firebase

extension CalendarVC {
    func observeFamilyEvents() {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    if family.hasChild("events") {
                        let familyEvents = family.childSnapshot(forPath: "events")
                        guard let eventsSnapshot = familyEvents.children.allObjects as? [FIRDataSnapshot] else { return }
                        if eventsSnapshot.count != DataHandler.instance.familyEvents.count {
                            DataHandler.instance.familyEvents = []
                            for event in eventsSnapshot {
                                guard let eventData = event.value as? [String : Any] else { return }
                                guard let familyEvent = eventData.toEvent() else { return }
                                familyEvent.identifier = event.key
                                DataHandler.instance.familyEvents.append(familyEvent)
                                self.calendarView.reloadData()
                                self.eventTable.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeFamilyEvent(_ event: Event) {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            for family in familySnapshot {
                guard let familyName = family.childSnapshot(forPath: "name").value as? String else { return }
                if familyName == userFamily {
                    DataHandler.instance.removeFirebaseFamilyEvent(familyID: family.key, eventID: event.identifier)
                    self.observeFamilyEvents()
                }
            }
        })
    }
}
