//
//  MainLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension MainVC {
    func layoutView() {
        let familyView = UIView()
        
        familyView.addSubview(familyMap)
        familyView.addSubview(centerButton)
        familyView.addSubview(familyTable)
        view.addSubview(familyView)
        view.addSubview(titleBar)
        view.backgroundColor = secondaryColor
        
        centerButton.anchor(trailing: familyMap.trailingAnchor,
                            bottom: familyMap.bottomAnchor,
                            padding: .init(top: 0, left: 0, bottom: 5, right: 5),
                            size: .init(width: 50, height: 50))
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        familyView.anchor(top: titleBar.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          padding: .init(top: -5, left: 5, bottom: 5, right: 5))
        
        familyMap.anchor(top: familyView.topAnchor,
                       leading: familyView.leadingAnchor,
                       trailing: familyView.trailingAnchor,
                       padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                       size: .init(width: 0, height: view.frame.width - 20))
        
        familyTable.dataSource = self
        familyTable.delegate = self
        familyTable.backgroundColor = .clear
        familyTable.anchor(top: familyMap.bottomAnchor,
                           leading: familyView.leadingAnchor,
                           trailing: familyView.trailingAnchor,
                           bottom: familyView.bottomAnchor,
                           padding: .init(top: 0, left: 5, bottom: 5, right: 5))
        
        displayLoadingView(true)
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.instance.familyUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.clearCell()
        cell.layoutCellForUser(DataHandler.instance.familyUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let familyName = selfUser.family, familyName != "" else { return nil }
        let headerLabel = UILabel()
        headerLabel.backgroundColor = primaryColor
        headerLabel.font = UIFont(name: fontName, size: largeFontSize)
        headerLabel.textAlignment = .center
        headerLabel.textColor = primaryTextColor
        headerLabel.text = familyName
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapIsCenteredOnCurrentUser = false
        mapIsCenteredOnFamily = false
        userToCenterMapOn = DataHandler.instance.familyUsers[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let familyName = selfUser.family, familyName != "" else { return 0 }
        return 40
    }
}

