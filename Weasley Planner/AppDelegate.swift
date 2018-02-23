//
//  AppDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let fontFamilyNames = UIFont.familyNames
//        for familyName in fontFamilyNames {
//            print("------------------------------")
//            print("Font Family Name = [\(familyName)]")
//            let names = UIFont.fontNames(forFamilyName: familyName)
//            print("Font Names = [\(names)]")
//        }
        
        FIRApp.configure()
        mapManager.checkLocationAuthStatus()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {  }
    func applicationDidEnterBackground(_ application: UIApplication) {  }
    func applicationWillEnterForeground(_ application: UIApplication) {  }
    func applicationDidBecomeActive(_ application: UIApplication) {  }
    func applicationWillTerminate(_ application: UIApplication) {
        guard let uid = DataHandler.instance.currentUserID else { return }
        let userData = ["status" : false]
        
        DataHandler.instance.updateFirebaseUser(uid: uid, userData: userData)
    }
}

