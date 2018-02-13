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
        view.backgroundColor = secondaryColor
        
        let familyView = UIView()
        //TODO: Add blur effect to background ?
        
        familyView.addSubview(mapView)
        familyView.addSubview(familyTable)
        view.addSubview(familyView)
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        familyView.anchor(top: titleBar.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          padding: .init(top: -5, left: 5, bottom: 5, right: 5))
        
        mapView.delegate = mapManager
        mapView.anchor(top: familyView.topAnchor,
                       leading: familyView.leadingAnchor,
                       trailing: familyView.trailingAnchor,
                       padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                       size: .init(width: 0, height: view.frame.width - 20))
        
        familyTable.dataSource = self
        familyTable.delegate = self
        familyTable.backgroundColor = .clear
        familyTable.separatorStyle = .none
        familyTable.register(UserCell.self, forCellReuseIdentifier: "userCell")
        familyTable.anchor(top: mapView.bottomAnchor,
                           leading: familyView.leadingAnchor,
                           trailing: familyView.trailingAnchor,
                           bottom: familyView.bottomAnchor,
                           padding: .init(top: 5, left: 5, bottom: 5, right: 5))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

