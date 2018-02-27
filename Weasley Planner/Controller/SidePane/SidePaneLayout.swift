//
//  SidePaneLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

enum Controller: String {
    case main = "Family Tracker"
    case calendar = "Calendar"
    case recipeList = "Recipe List"
    case shoppingList = "Shopping List"
    static var allControllers: [Controller] { return [.main, .calendar, .recipeList, .shoppingList] }
    
    var segueIdentifier: String {
        switch self {
        case .main: return "showMain"
        case .calendar: return "showCalendar"
        case .recipeList: return "showRecipeList"
        case .shoppingList: return "showShoppingList"
        }
    }
}

extension SidePaneVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(selfPane)
        view.addSubview(vcTable)
        
        vcTable.dataSource = self
        vcTable.delegate = self
        vcTable.backgroundColor = .clear
        vcTable.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: selfPane.topAnchor,
                       padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutUserElements() {
        let bottomPane: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let settingsButton: UIButton = {
                let button = UIButton()
                button.addTarget(self, action: #selector(familyButtonPressed(_:)), for: .touchUpInside)
                button.setImage(#imageLiteral(resourceName: "familyIcon"), for: .normal)
                button.sizeToFit()
                return button
            }()
            
            view.addSubview(settingsButton)
            view.addSubview(logOutButton)
            
            handleLogOutButtonVisibility()
            logOutButton.anchor(top: view.topAnchor,
                                trailing: view.trailingAnchor,
                                bottom: view.bottomAnchor,
                                padding: .init(top: 5, left: 0, bottom: 5, right: 5))
            
            settingsButton.anchor(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor,
                                  padding: .init(top: 5, left: 5, bottom: 5, right: 0))
            
            return view
        }()
        
        if DataHandler.instance.currentUserID == nil {
            selfPane.layoutForLogin()
            selfPane.loginPanel.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selfPaneTapped(_:)))
            
            if let user = user {
                selfPane.userIcon = user.icon
                selfPane.userLocation = user.location
                selfPane.userName = user.name
                selfPane.userStatus = user.status
            }
            
            selfPane.addGestureRecognizer(tapGesture)
            selfPane.layoutForUser(with: 60)
        }
        
        view.addSubview(bottomPane)
        bottomPane.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          size: .init(width: 0, height: 50))
        
        selfPane.anchor(leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        bottom: bottomPane.topAnchor,
                        padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                        size: .init(width: 0, height: 60))
    }
    
    func handleLogOutButtonVisibility() {
        if DataHandler.instance.currentUserID == nil {
            logOutButton.isHidden = true
        } else {
            logOutButton.isHidden = false
        }
    }
}

extension SidePaneVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Controller.allControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: fontName, size: largeFontSize)
        cell.textLabel?.textColor = secondaryTextColor
        cell.textLabel?.text = Controller.allControllers[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = Controller.allControllers[indexPath.row].segueIdentifier
        DataHandler.instance.segueIdentifier = identifier
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
