//
//  SidePaneVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import Firebase

class SidePaneVC: UIViewController {
    //MARK: UI Variables
    let vcTable = UITableView()
    let selfPane = UserPane()
    let settingsButton = UIButton()
    let logOutButton = TextButton()
    let bottomPane = UIView()
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    //MARK: Data Variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        layoutSelfPane()
        
        if DataHandler.instance.segueIdentifier == "dismiss" {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            if let destination = segue.destination as? FirebaseLoginVC {
                slideInTransitionManager.direction = .bottom
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
                
                if let sender = sender as? User { destination.user = sender }
                destination.view.bindToKeyboard()
            }
        } else if segue.identifier == "showSettings" {
            if let destination = segue.destination as? SettingsVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
                
                destination.user = user
            }
        }
    }
    
    @objc func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogin", sender: nil)
    }
    
    @objc func logoutPressed(_ sender: TextButton) {
        do {
            try FIRAuth.auth()?.signOut()
            if let uid = DataHandler.instance.currentUserID {
                DataHandler.instance.updateFirebaseUser(uid: uid, userData: ["status" : false])
            }
            DataHandler.instance.currentUserID = nil
            dismiss(animated: true, completion: nil)
        } catch {
            showAlert(.logoutError)
        }
    }
    
    @objc func familyButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @objc func selfPaneTapped(_ sender: UITapGestureRecognizer) {
        print("EDIT PROFILE: selfPane Tapped")
        performSegue(withIdentifier: "showLogin", sender: user)
    }
}
