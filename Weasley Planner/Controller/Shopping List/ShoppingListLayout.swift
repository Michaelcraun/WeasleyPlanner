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
        
        addEntryField.anchor(top: titleBar.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
        
        shoppingList.backgroundColor = .clear
        shoppingList.dataSource = self
        shoppingList.delegate = self
        shoppingList.register(ShoppingCell.self, forCellReuseIdentifier: "shoppingCell")
        shoppingList.showsVerticalScrollIndicator = false
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
        
        loadPreviousEntries()
        observeFamilyShoppingList()
    }
}

extension ShoppingListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shoppingItems.count != 0 { return shoppingItems.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell") as! ShoppingCell
        switch shoppingItems.count {
        case 0: cell.layoutCellForNoItems()
        default: cell.layoutCellForItem(shoppingItems[indexPath.row])
        }
        return cell
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
        if tableView == shoppingList {
            let item = shoppingItems[indexPath.row]
            item.obtained = !item.obtained
            
            updateShoppingList()
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
        let newItem = createItemFromText(item)
        searchShoppingListForDuplicate(newItem)
        addEntryField.text = ""
    }
    
    @objc func addItemPressed(_ sender: TextButton) {
        
    }
    
    func layoutAddItemButton() {
        let addItemButton: TextButton = {
            let button = TextButton()
            button.addTarget(self, action: #selector(addItemPressed(_:)), for: .touchUpInside)
            button.bindToKeyboard()
            button.tag = 1004
            button.title = "ADD ITEM"
            return button
        }()
        
        view.addSubview(addItemButton)
        
        addItemButton.anchor(leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             bottom: view.bottomAnchor,
                             size: .init(width: 0, height: 50))
    }
    
    func removeAddItemButton() {
        for subview in view.subviews {
            if subview.tag == 1004 {
                subview.fadeAlphaOut()
            }
        }
    }
}
