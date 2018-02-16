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
        view.backgroundColor = secondaryColor
        view.addSubview(addEntryField)
        view.addSubview(shoppingList)
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        //TODO: Finish layout of addItemView
//        addEntryField.barStyle = .blackOpaque
        addEntryField.barTintColor = secondaryColor
        addEntryField.delegate = self
        addEntryField.returnKeyType = .done
        addEntryField.showsCancelButton = true
        addEntryField.showsSearchResultsButton = false
        addEntryField.tintColor = primaryColor
        addEntryField.anchor(top: titleBar.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        shoppingList.backgroundColor = .clear
        shoppingList.dataSource = self
        shoppingList.delegate = self
        shoppingList.register(ShoppingCell.self, forCellReuseIdentifier: "shoppingCell")
        shoppingList.separatorColor = primaryColor
        shoppingList.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        shoppingList.anchor(top: addEntryField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}

extension ShoppingListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == shoppingList {
            if shoppingItems.count == 0 {
                return 1
            } else {
                return shoppingItems.count
            }
        } else {
            if filteredEntries.count == 0 {
                return 1
            } else {
                return filteredEntries.count + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == shoppingList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell") as! ShoppingCell
            
            if shoppingItems.count == 0 {
                cell.layoutCellForNoItems()
            } else {
                cell.layoutCellForItem(shoppingItems[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "previousItemCell") as! ShoppingCell
            
            if indexPath.row == 0 {
                cell.layoutCellForAddItem()
            } else {
                cell.layoutCellForPrevious(entry: filteredEntries[indexPath.row - 1])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == shoppingList {
            if shoppingItems.count == 0 {
                return 70
            } else {
                return 30
            }
        } else {
            if indexPath.row == 0 {
                return 50
            } else {
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == shoppingList {
            //TODO: Mark item as obtained and update Firebase
        } else {
            //TODO: Add item to shopping list
            if indexPath.row == 0 {
                if let text = addEntryField.text {
                    let itemQuantity = text.quantity()
                    let itemName = text.trimmingQunatity(itemQuantity)
                    
                    let newItem = Item(quanity: itemQuantity, name: itemName, obtained: false)
                    searchShoppingListForDuplicate(newItem)
//                    shoppingItems.append(newItem)
//                    updateShoppingList()
                    
                    saveNewPreviousEntry(withText: text)
                    loadPreviousEntries()
                }
            } else {
                
            }
            dismissAddEntryView()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShoppingListVC: UISearchBarDelegate {
    //TODO: Handle TextFeilds
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        layoutPreviousEntriesTable()
        
        if let searchText = searchBar.text {
            searchPreviousEntries(withSearchText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPreviousEntries(withSearchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissAddEntryView()
    }
    
    func layoutPreviousEntriesTable() {
        let addEntryView = UIView()
        
        view.addSubview(addEntryView)
        addEntryView.addBlurEffect(tag: 1002)
        addEntryView.addSubview(previousEntriesTable)
        
        addEntryView.alpha = 0
        addEntryView.clipsToBounds = true
        addEntryView.layer.borderColor = primaryColor.cgColor
        addEntryView.layer.borderWidth = 1
        addEntryView.layer.cornerRadius = 10
        addEntryView.tag = 1003
        addEntryView.anchor(top: addEntryField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 5, left: 30, bottom: 0, right: 5),
                            size: .init(width: 0, height: 180))
        
        previousEntriesTable.backgroundColor = .clear
        previousEntriesTable.dataSource = self
        previousEntriesTable.delegate = self
        previousEntriesTable.register(ShoppingCell.self, forCellReuseIdentifier: "previousItemCell")
        previousEntriesTable.separatorColor = primaryColor
        previousEntriesTable.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        previousEntriesTable.anchor(top: addEntryView.topAnchor,
                                    leading: addEntryView.leadingAnchor,
                                    trailing: addEntryView.trailingAnchor,
                                    bottom: addEntryView.bottomAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        addEntryView.fadeAlphaTo(1)
    }
    
    func dismissAddEntryView() {
        for subview in view.subviews {
            if subview.tag == 1003 {
                subview.fadeAlphaOut()
            }
        }
        
        addEntryField.text = ""
        addEntryField.resignFirstResponder()
    }
}
