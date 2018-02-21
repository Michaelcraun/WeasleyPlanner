//
//  AddRecipeLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/19/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension AddRecipeVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        if isAddingFirebaseRecipe {
            layoutForFirebaseRecipes()
        } else {
            let recipeForm = configureNewRecipeForm()
            
            view.addSubview(recipeForm)
            
            recipeForm.anchor(top: titleBar.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    func layoutForFirebaseRecipes() {
        
    }
    
    func configureNewRecipeForm() -> UIScrollView {
        let newRecipeScrollView: UIScrollView = {
            let textFieldHeight = 30
            let textViewHeight = 120
            let scrollView = UIScrollView()
            scrollView.alwaysBounceHorizontal = false
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.addSubview(titleField)
            scrollView.addSubview(isFavoriteButton)
            scrollView.addSubview(recipeImageView)
            scrollView.addSubview(recipeImageButton)
            scrollView.addSubview(descriptionView)
            scrollView.addSubview(notesView)
            scrollView.addSubview(yieldField)
            scrollView.addSubview(activeTimeField)
            scrollView.addSubview(totalTimeField)
            scrollView.addSubview(sourceField)
            scrollView.addSubview(urlField)
            scrollView.addSubview(ingredientsView)
            scrollView.addSubview(instructionsView)
            scrollView.addSubview(saveButton)
            scrollView.addSubview(shareOnFirebaseSwitcher)
            
            isFavoriteButton.anchor(top: scrollView.topAnchor,
                                    trailing: scrollView.trailingAnchor,
                                    padding: .init(top: 5, left: 0, bottom: 0, right: 5),
                                    size: .init(width: 30, height: 30))
            
            titleField.anchor(top: scrollView.topAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: isFavoriteButton.leadingAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: textFieldHeight))
            
            recipeImageView.anchor(top: titleField.bottomAnchor,
                                   leading: scrollView.leadingAnchor,
                                   trailing: scrollView.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: view.frame.width - 20, height: 150))
            
            recipeImageButton.anchor(top: recipeImageView.topAnchor,
                                     leading: recipeImageView.leadingAnchor,
                                     trailing: recipeImageView.trailingAnchor,
                                     bottom: recipeImageView.bottomAnchor)
            
            descriptionView.anchor(top: recipeImageView.bottomAnchor,
                                   leading: scrollView.leadingAnchor,
                                   trailing: scrollView.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: textViewHeight))
            
            notesView.anchor(top: descriptionView.bottomAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: textViewHeight))
            
            yieldField.anchor(top: notesView.bottomAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: scrollView.trailingAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: textFieldHeight))
            
            activeTimeField.inputField.inputView = activeDurationPicker
            activeTimeField.anchor(top: yieldField.bottomAnchor,
                                   leading: scrollView.leadingAnchor,
                                   trailing: scrollView.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: textFieldHeight))
            
            totalTimeField.inputField.inputView = totalDurationPicker
            totalTimeField.anchor(top: activeTimeField.bottomAnchor,
                                  leading: scrollView.leadingAnchor,
                                  trailing: scrollView.trailingAnchor,
                                  padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                  size: .init(width: 0, height: textFieldHeight))
            
            sourceField.anchor(top: totalTimeField.bottomAnchor,
                               leading: scrollView.leadingAnchor,
                               trailing: scrollView.trailingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                               size: .init(width: 0, height: textFieldHeight))
            
            urlField.anchor(top: sourceField.bottomAnchor,
                            leading: scrollView.leadingAnchor,
                            trailing: scrollView.trailingAnchor,
                            padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                            size: .init(width: 0, height: textFieldHeight))
            
            ingredientsView.anchor(top: urlField.bottomAnchor,
                                   leading: scrollView.leadingAnchor,
                                   trailing: scrollView.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                   size: .init(width: 0, height: textViewHeight))
            
            instructionsView.anchor(top: ingredientsView.bottomAnchor,
                                    leading: scrollView.leadingAnchor,
                                    trailing: scrollView.trailingAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                    size: .init(width: 0, height: textViewHeight))
            
            shareOnFirebaseSwitcher.anchor(trailing: scrollView.trailingAnchor,
                                           centerY: saveButton.centerYAnchor,
                                           padding: .init(top: 0, left: 0, bottom: 0, right: 5),
                                           size: .init(width: 0, height: textFieldHeight))
            
            saveButton.anchor(top: instructionsView.bottomAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: shareOnFirebaseSwitcher.leadingAnchor,
                              bottom: scrollView.bottomAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: 40))
            
            return scrollView
        }()
        return newRecipeScrollView
    }
}

extension AddRecipeVC: ModernSearchBarDelegate {
    func getSearchableData() -> [String] {
        var searchableData: [String] {
            var _searchableData = [String]()
            for recipe in firebaseRecipes {
                _searchableData.append(recipe.title)
            }
            return _searchableData
        }
        return searchableData
    }
    
    func onClickItemSuggestionsView(item: String) {
        
    }
}

extension AddRecipeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firebaseRecipeCell") as! RecipeCell
        cell.layoutCellForRecipe(firebaseRecipes[indexPath.row])
        return cell
    }
}

extension AddRecipeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 25
        case 1: return 1
        case 2: return 13
        case 3: return 1
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: smallFontSize)
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            label.text = {
                switch component {
                case 0: return "\(row)"
                case 1: return "HH"
                case 2: return "\(row * 5)"
                case 3: return "mm"
                default: return ""
                }
            }()
            return label
        }()
        return rowLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == activeDurationPicker.dataPicker {
            switch component {
            case 0: activeTime[0] = row
            case 2: activeTime[1] = row * 5
            default: break
            }
        } else {
            switch component {
            case 0: totalTime[0] = row
            case 2: totalTime[1] = row * 5
            default: break
            }
        }
    }
    
    @objc func pickerButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        if sender.title(for: .normal) == "Done" {
            if sender == activeDurationPicker.doneButton {
                let activeTimeString = "\(activeTime[0]):\(activeTime[1])"
                activeTimeField.inputField.text = activeTimeString
            } else {
                let totalTimeString = "\(totalTime[0]):\(totalTime[1])"
                totalTimeField.inputField.text = totalTimeString
            }
        }
    }
}

extension AddRecipeVC: UITextFieldDelegate {
    //TODO: TextField Delegate... Duh!
}
