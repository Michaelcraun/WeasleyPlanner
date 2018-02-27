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
    func observeFamilyForEvents() {
        guard let userFamily = user?.family else { return }
        
        DataHandler.instance.REF_FAMILY.observe(.value) { (snapshot) in
            guard let familySnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }
            
        }
    }
}
