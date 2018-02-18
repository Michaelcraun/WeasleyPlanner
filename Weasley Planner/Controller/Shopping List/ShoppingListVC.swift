//
//  ShoppingListVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    private let identifier = "showShoppingList"
    
    //MARK: UI Variables
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Shopping List"
        return bar
    }()
    
//    let addEntryField: UISearchBar()
    let addEntryField: ModernSearchBar = {
        let bar = ModernSearchBar()

        //TODO: Create a better image for this
        bar.searchImage = #imageLiteral(resourceName: "defaultProfileImage")
        bar.searchLabel_font = UIFont(name: fontName, size: smallFontSize)
        bar.searchLabel_textColor = primaryTextColor
        bar.searchLabel_backgroundColor = primaryColor

        bar.suggestionsView_maxHeight = 180
        bar.suggestionsView_separatorStyle = .none
        bar.suggestionsView_contentViewColor = primaryColor

        return bar
    }()
    
    let shoppingList = UITableView()
    let previousEntriesTable = UITableView()
    
    //MARK: Data Variables
    var user: User?
    var previousEntries = [String]()
    var shoppingItems = [Item]() {
        didSet {
            shoppingList.reloadData()
        }
    }
    
    var filteredEntries = [String]() {
        didSet {
            previousEntriesTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPreviousEntries()
        observeFamilyShoppingList()
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        addEntryField.delegateModernSearchBar = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func loadPreviousEntries() {
        let defaults = UserDefaults.standard
        if let previousEntries = defaults.array(forKey: "previousEntries") as? [String] {
            self.previousEntries = previousEntries
        }
    }
    
    func saveNewPreviousEntry(withText text: String) {
        var shouldSave = true
        
        for entry in previousEntries {
            if text == entry {
                shouldSave = false
                break
            }
        }
        
        if shouldSave {
            let defaults = UserDefaults.standard
            
            previousEntries.append(text)
            defaults.set(previousEntries, forKey: "previousEntries")
        }
    }
    
    func searchPreviousEntries(withSearchText text: String) {
        filteredEntries = []
        
        let plainText = text.lowercased()
        for entry in previousEntries {
            let plainEntry = entry.lowercased()
            if plainEntry.contains(plainText) {
                filteredEntries.append(entry)
            }
        }
    }
    
    func searchShoppingListForDuplicate(_ item: Item) {
        var i = 0
        var itemToEdit: Item? {
            let itemName = item.name
            
            for _ in shoppingItems {
                let index = IndexPath(row: i, section: 0)
                let cell = shoppingList.cellForRow(at: index) as! ShoppingCell
                if let cellItemName = cell.item?.name {
                    if itemName == cellItemName {
                        return cell.item
                    } else {
                        i += 1
                    }
                }
            }
            return nil
        }
        
        if itemToEdit == nil {
            shoppingItems.append(item)
            updateShoppingList()
        } else {
            if item.quantity == 0 {
                if shoppingItems[i].quantity == 0 {
                    shoppingItems[i].quantity += 2
                } else {
                    shoppingItems[i].quantity += 1
                }
            } else {
                shoppingItems[i].quantity += item.quantity
            }
            updateShoppingList()
        }
    }
    
    func clearList() {
        shoppingItems = []
        updateShoppingList()
    }
    
    @objc func clearListPressed(_ sender: TextButton?) {
        showAlert(.clearShoppingList)
    }
    
    @objc func addItemPressed(_ sender: TextButton) {
        
    }
}
