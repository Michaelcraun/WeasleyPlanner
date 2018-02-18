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
        view.addSubview(addEntryField)
        view.addSubview(shoppingList)
        view.addSubview(titleBar)
        view.addSubview(bottomPanel)
        bottomPanel.addSubview(clearListButton)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        addEntryField.setDatas(datas: previousEntries)
        addEntryField.anchor(top: titleBar.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        shoppingList.backgroundColor = .clear
        shoppingList.dataSource = self
        shoppingList.delegate = self
        shoppingList.register(ShoppingCell.self, forCellReuseIdentifier: "shoppingCell")
        shoppingList.separatorStyle = .none
        shoppingList.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        shoppingList.anchor(top: addEntryField.bottomAnchor,
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == shoppingList {
            if shoppingItems.count != 0 { return shoppingItems.count }
        } else {
            if filteredEntries.count != 0 { return filteredEntries.count + 1 }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == shoppingList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell") as! ShoppingCell
            switch shoppingItems.count {
            case 0: cell.layoutCellForNoItems()
            default: cell.layoutCellForItem(shoppingItems[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "previousItemCell") as! ShoppingCell
            switch indexPath.row {
            case 0: cell.layoutCellForAddItem()
            default: cell.layoutCellForPrevious(entry: filteredEntries[indexPath.row - 1])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == shoppingList {
            if shoppingItems.count == 0 { return 70 }
        } else {
            if indexPath.row == 0 { return 50 }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SEARCH: in tableView(_:didSelectRowAt:)")
        let suggestionsView = addEntryField.getSuggestionsView()
        
        if tableView == shoppingList {
            let item = shoppingItems[indexPath.row]
            item.obtained = !item.obtained
            
            updateShoppingList()
        } else {
            if indexPath.row == 0 {
                if let text = addEntryField.text, text != "" {
                    let newItem = createItemFromText(text)
                    searchShoppingListForDuplicate(newItem)
                    
                    saveNewPreviousEntry(withText: text)
                    loadPreviousEntries()
                }
            } else {
                let text = filteredEntries[indexPath.row - 1]
                let newItem = createItemFromText(text)
                searchShoppingListForDuplicate(newItem)
            }
            dismissAddEntryView()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //TODO: Make an image for this action
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
            self.shoppingItems.remove(at: indexPath.row)
            self.updateShoppingList()
        }
        delete.image = #imageLiteral(resourceName: "familyIcon")
        
        let configuration = UISwipeActionsConfiguration.init(actions: [delete])
        return configuration
    }
    
    func createItemFromText(_ text: String) -> Item {
        let itemQuantity = text.quantity()
        let itemName = text.trimmingQunatity(itemQuantity)
        
        let newItem = Item(quanity: itemQuantity, name: itemName, obtained: false)
        return newItem
    }
}

extension ShoppingListVC: ModernSearchBarDelegate {
    func onClickItemSuggestionsView(item: String) {
        print("SEARCH: User clicked item: \(item)")
    }
    
    func onClickShadowView(shadowView: UIView) {
        print("SEARCH: User clicked shadowView. Dismissing...")
    }
}

extension ShoppingListVC: UISearchBarDelegate {
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
        let addEntryView: UIView = {
            let view = UIView()
            view.addBlurEffect(tag: 1002)
            view.alpha = 0
            view.clipsToBounds = true
            view.layer.borderColor = primaryColor.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 10
            view.tag = 1003
            
            let addButton: TextButton = {
                let button = TextButton()
                button.addTarget(self, action: #selector(addItemPressed(_:)), for: .touchUpInside)
                button.title = "ADD ITEM"
                return button
            }()
            
            view.addSubview(previousEntriesTable)
            view.addSubview(addButton)
            
            previousEntriesTable.backgroundColor = .clear
            previousEntriesTable.dataSource = self
            previousEntriesTable.delegate = self
            previousEntriesTable.register(ShoppingCell.self, forCellReuseIdentifier: "previousItemCell")
            previousEntriesTable.separatorStyle = .none
            previousEntriesTable.anchor(top: view.topAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        bottom: view.bottomAnchor,
                                        padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            
            addButton.anchor(leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             bottom: view.bottomAnchor,
                             size: .init(width: 0, height: 30))
            
            return view
        }()
        
        view.addSubview(addEntryView)
        
        addEntryView.anchor(leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                            size: .init(width: 0, height: 200))
        
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
