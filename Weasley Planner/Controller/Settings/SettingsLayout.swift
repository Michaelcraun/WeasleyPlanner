//
//  SettingsLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension SettingsVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(titleBar)
        view.addSubview(familyButton)
        view.addSubview(creditsView)
        
        if let family = user?.family, family != "" {
            familyButton.title = "Edit Family"
        } else {
            familyButton.title = "Start Family"
        }
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        familyButton.addTarget(self, action: #selector(familyButtonPressed(_:)), for: .touchUpInside)
        familyButton.anchor(leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                            size: .init(width: 0, height: 50))
    }
    
    func layoutFamilyView() {
        view.addBlurEffect(tag: 1002)
        view.addSubview(familyView)
        familyView.addSubview(familyTable)
        familyView.addSubview(saveButton)
        
        familyView.alpha = 0
        familyView.layer.borderColor = primaryColor.cgColor
        familyView.layer.borderWidth = 2
        familyView.layer.cornerRadius = 10
        familyView.backgroundColor = secondaryColor
        familyView.clipsToBounds = true
        familyView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        familyTable.backgroundColor = .clear
        familyTable.dataSource = self
        familyTable.delegate = self
        familyTable.register(UserCell.self, forCellReuseIdentifier: "userCell")
        familyTable.separatorStyle = .none
        familyTable.anchor(top: familyView.topAnchor,
                           leading: familyView.leadingAnchor,
                           trailing: familyView.trailingAnchor,
                           bottom: saveButton.topAnchor,
                           padding: .init(top: 0, left: 0, bottom: 5, right: 0))
        
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveButton.title = "Save Family"
        saveButton.anchor(leading: familyView.leadingAnchor,
                          trailing: familyView.trailingAnchor,
                          bottom: familyView.bottomAnchor,
                          size: .init(width: 0, height: 50))
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.backgroundColor = primaryColor
        headerLabel.font = UIFont(name: fontName, size: largeFontSize)
        headerLabel.textAlignment = .center
        headerLabel.textColor = primaryTextColor
        if section == 0 {
            headerLabel.text = "Users in Family"
        } else {
            headerLabel.text = "Nearby Users"
        }
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if familyUsers.count > 0 {
                return familyUsers.count
            }
        } else {
            if nearbyUsers.count > 0 {
                return nearbyUsers.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        if indexPath.section == 0 {
            if familyUsers.count > 0 {
                cell.layoutCellForUser(familyUsers[indexPath.row])
            } else {
                cell.layoutNoUserCell()
            }
        } else {
            if nearbyUsers.count > 0 {
                cell.layoutCellForUser(nearbyUsers[indexPath.row])
            } else {
                cell.layoutNoUserCell()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if user?.family == "" {
                showAlert(.startFamily)
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! UserCell
                userToAddToFamily = cell.user
                showAlert(.addUserToFamily)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
