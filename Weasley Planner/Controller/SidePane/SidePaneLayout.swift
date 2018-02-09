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
    case mealPlanner = "Meal Planner"
    case shoppingList = "Shopping List"
    case choreChart = "Chore Chart"
    static var allControllers: [Controller] { return [.main, .calendar, .mealPlanner, .shoppingList, .choreChart] }
    
    var segueIdentifier: String {
        switch self {
        case .main: return "showMain"
        case .calendar: return "showCalendar"
        case .mealPlanner: return "showMealPlanner"
        case .shoppingList: return "showShoppingList"
        case .choreChart: return "showChoreChart"
        }
    }
}

extension SidePaneVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(bottomPane)
        view.addSubview(selfPane)
        view.addSubview(vcTable)
        bottomPane.addSubview(settingsButton)
        bottomPane.addSubview(familyButton)
        
        //TODO: Finish layout of bottomPane ?
        bottomPane.backgroundColor = primaryColor
        bottomPane.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          size: .init(width: 0, height: 50))
        
        //MARK: Test variables
        selfPane.userLocation = "770 N State Road 9, Columbia City, IN, 46725"
        selfPane.userName = "Michael Craun"
        selfPane.userStatus = true
        selfPane.anchor(leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        bottom: bottomPane.topAnchor,
                        size: .init(width: 0, height: 60))
        
        //TODO: Finish layout of vcTable
        vcTable.dataSource = self
        vcTable.delegate = self
        vcTable.backgroundColor = .clear
        vcTable.isScrollEnabled = false
        vcTable.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: selfPane.topAnchor,
                       padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        //TODO: Create an image for this button
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(sidePaneButtonPressed(_:)), for: .touchUpInside)
        settingsButton.anchor(top: bottomPane.topAnchor,
                              leading: bottomPane.leadingAnchor,
                              bottom: bottomPane.bottomAnchor,
                              padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                              size: .init(width: 40, height: 0))
        
        //TODO: Create an image for this button
        familyButton.setTitle("Family", for: .normal)
        familyButton.addTarget(self, action: #selector(sidePaneButtonPressed(_:)), for: .touchUpInside)
        familyButton.anchor(top: bottomPane.topAnchor,
                            trailing: bottomPane.trailingAnchor,
                            bottom: bottomPane.bottomAnchor,
                            padding: .init(top: 5, left: 0, bottom: 5, right: 5),
                            size: .init(width: 40, height: 0))
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
