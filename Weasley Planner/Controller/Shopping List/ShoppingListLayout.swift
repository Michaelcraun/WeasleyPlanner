//
//  ShoppingListLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension ShoppingListVC {
    func layoutView() {
        let bottomPanel: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            return view
        }()
        
        let clearListButton: TextButton = {
            let button = TextButton()
            button.addTarget(self, action: #selector(clearListPressed(_:)), for: .touchUpInside)
            button.title = "CLEAR LIST"
            return button
        }()
        
        view.backgroundColor = secondaryColor
        view.addSubview(shoppingList)
        view.addSubview(shadowView)
        view.addSubview(titleBar)
        view.addSubview(searchField)
        view.addSubview(searchList)
        view.addSubview(bottomPanel)
        bottomPanel.addSubview(clearListButton)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        searchField.anchor(top: titleBar.bottomAnchor,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                           size: .init(width: 0, height: 30))
        
        shadowView.fillTo(view)
        
        searchListHeight = NSLayoutConstraint(item: searchList,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 0)
        
        searchList.addConstraint(searchListHeight)
        searchList.backgroundColor = primaryColor
        searchList.dataSource = self
        searchList.delegate = self
        searchList.separatorStyle = .none
        searchList.anchor(top: searchField.bottomAnchor,
                          leading: searchField.leadingAnchor,
                          trailing: searchField.trailingAnchor,
                          padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        shoppingList.backgroundColor = .clear
        shoppingList.dataSource = self
        shoppingList.delegate = self
        shoppingList.separatorStyle = .none
        shoppingList.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        shoppingList.anchor(top: searchField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            bottom: bottomPanel.topAnchor,
                            padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        bottomPanel.anchor(leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           size: .init(width: 0, height: 50))
        
        clearListButton.anchor(top: bottomPanel.topAnchor,
                               trailing: bottomPanel.trailingAnchor,
                               bottom: bottomPanel.bottomAnchor,
                               padding: .init(top: 5, left: 0, bottom: 5, right: 5))
    }
}

extension ShoppingListVC: UITableViewDataSource, UITableViewDelegate {
    func performEntrySearch(searchText: String) {
        matchingEntries.removeAll()
        let searchableText = searchText.lowercased()
        for entry in previousEntries {
            let searchableEntry = entry.lowercased()
            if searchableEntry.contains(searchableText) {
                matchingEntries.append(entry)
            }
        }
    }
    
    func animateTableView(_ tableView: UITableView, shouldOpen: Bool) {
        shadowView.isHidden = !shouldOpen
        var heightConstant: CGFloat {
            switch shouldOpen {
            case true: return 180
            case false: return 0
            }
        }
        
        var heightConstraint: NSLayoutConstraint {
            tableView.removeConstraint(searchListHeight)
            searchListHeight = NSLayoutConstraint(item: tableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: heightConstant)
            return searchListHeight
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            tableView.frame.size.height = heightConstant
        }, completion: { (finished) in
            tableView.addConstraint(heightConstraint)
            tableView.updateConstraints()
            
            if shouldOpen {
                tableView.reloadData()
            } else {
                self.searchField.inputField.text = ""
                self.matchingEntries = []
                self.view.endEditing(true)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchList {
            return matchingEntries.count + 1
        } else {
            if shoppingItems.count == 0 { return 1 }
            return shoppingItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! ShoppingCell
            switch indexPath.row {
            case 0: cell.layoutCancelCell()
            default: cell.layoutCellForPrevious(entry: matchingEntries[indexPath.row - 1])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell") as! ShoppingCell
            switch shoppingItems.count {
            case 0: cell.layoutCellForNo("Item")
            default: cell.layoutCellForItem(shoppingItems[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchList {
            return 40
        } else {
            switch shoppingItems.count {
            case 0: return 70
            default: return 50
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchList {
            switch indexPath.row {
            case 0: animateTableView(searchList, shouldOpen: false)
            default: break  //TODO: Add selected item to list
            }
        } else {
            let item = shoppingItems[indexPath.row]
            item.obtained = !item.obtained
            updateShoppingList()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == searchList {
            return nil
        } else {
            let delete = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
                self.shoppingItems.remove(at: indexPath.row)
                self.updateShoppingList()
            }
            delete.image = #imageLiteral(resourceName: "deleteIcon")
            
            let configuration = UISwipeActionsConfiguration.init(actions: [delete])
            return configuration
        }
    }
}
