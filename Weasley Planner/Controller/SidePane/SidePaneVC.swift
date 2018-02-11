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
    let logOutButton = UIButton()
    let bottomPane = UIView()
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    //MARK: Data Variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        layoutSelfPane()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            if let destination = segue.destination as? FirebaseLoginVC {
                slideInTransitionManager.direction = .bottom
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
                
                destination.view.bindToKeyboard()
            }
        }
    }
    
    @objc func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogin", sender: nil)
    }
    
    @objc func sidePaneButtonPressed(_ sender: UIButton) {
        switch sender.title(for: .normal)! {
        case "Log Out":
            do {
                try FIRAuth.auth()?.signOut()
                DataHandler.instance.currentUserID = nil
                dismiss(animated: true, completion: nil)
            } catch {
                print("FIREBASE: Error logging out!")
            }
        default: break
        }
    }
}
