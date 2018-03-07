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
            view.addSubview(searchBar)
            view.addSubview(firebaseRecipeList)
            
            searchBar.delegateModernSearchBar = self
            searchBar.anchor(top: titleBar.bottomAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                             size: .init(width: 0, height: 30))
            
            firebaseRecipeList.backgroundColor = .clear
            firebaseRecipeList.dataSource = self
            firebaseRecipeList.delegate = self
            firebaseRecipeList.register(RecipeCell.self, forCellReuseIdentifier: "firebaseRecipeCell")
            firebaseRecipeList.separatorStyle = .none
            firebaseRecipeList.anchor(top: searchBar.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      padding: .init(top: 0, left: 5, bottom: 5, right: 5))
            
            observeFirebaseRecipes()
        } else {
            let recipeForm = configureNewRecipeForm()
            
            view.addSubview(recipeForm)
            
            recipeForm.anchor(top: titleBar.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            if recipeToEdit != nil { loadRecipeData() }
        }
    }
    
    func configureNewRecipeForm() -> UIScrollView {
        let newRecipeScrollView: UIScrollView = {
            ingredientsListHeight = NSLayoutConstraint(item: ingredientsList,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1,
                                                             constant: CGFloat(53 + (recipeIngredients.count + 1) * 40))
            
            instructionsListHeight = NSLayoutConstraint(item: instructionsList,
                                                              attribute: .height,
                                                              relatedBy: .equal,
                                                              toItem: nil,
                                                              attribute: .notAnAttribute,
                                                              multiplier: 1,
                                                              constant: CGFloat(93 + (recipeInstructions.count) * 120))
            
            let textFieldHeight = 30
            let textViewHeight = 120
            let scrollView = UIScrollView()
            scrollView.alwaysBounceHorizontal = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.tag = 1006
            
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
            scrollView.addSubview(ingredientsList)
            scrollView.addSubview(instructionsList)
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
            
            recipeImageButton.fillTo(recipeImageView)
            
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
            
            ingredientsList.addBorder()
            ingredientsList.backgroundColor = secondaryColor
            ingredientsList.dataSource = self
            ingredientsList.delegate = self
            ingredientsList.register(RecipeCell.self, forCellReuseIdentifier: "ingredientsCell")
            ingredientsList.separatorStyle = .none
            ingredientsList.addConstraint(ingredientsListHeight)
            ingredientsList.anchor(top: urlField.bottomAnchor,
                                   leading: scrollView.leadingAnchor,
                                   trailing: scrollView.trailingAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            instructionsList.addBorder()
            instructionsList.backgroundColor = secondaryColor
            instructionsList.dataSource = self
            instructionsList.delegate = self
            instructionsList.register(RecipeCell.self, forCellReuseIdentifier: "instructionsCell")
            instructionsList.separatorStyle = .none
            instructionsList.addConstraint(instructionsListHeight)
            instructionsList.anchor(top: ingredientsList.bottomAnchor,
                                    leading: scrollView.leadingAnchor,
                                    trailing: scrollView.trailingAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            shareOnFirebaseSwitcher.anchor(trailing: scrollView.trailingAnchor,
                                           centerY: saveButton.centerYAnchor,
                                           padding: .init(top: 0, left: 0, bottom: 0, right: 5),
                                           size: .init(width: 0, height: textFieldHeight))
            
            saveButton.anchor(top: instructionsList.bottomAnchor,
                              leading: scrollView.leadingAnchor,
                              trailing: shareOnFirebaseSwitcher.leadingAnchor,
                              bottom: scrollView.bottomAnchor,
                              padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                              size: .init(width: 0, height: 40))
            
            return scrollView
        }()
        return newRecipeScrollView
    }
    
    func updateIngredientsandInstructionsConstraints() {
        ingredientsList.removeConstraint(ingredientsListHeight)
        instructionsList.removeConstraint(instructionsListHeight)
        
        ingredientsListHeight = NSLayoutConstraint(item: ingredientsList,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: CGFloat(53 + (recipeIngredients.count + 1) * 40))
        
        instructionsListHeight = NSLayoutConstraint(item: instructionsList,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1,
                                                    constant: CGFloat(93 + (recipeInstructions.count) * 120))
        
        ingredientsList.addConstraint(ingredientsListHeight)
        instructionsList.addConstraint(instructionsListHeight)
        view.updateConstraints()
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
        //TODO: Filter firebaseRecipeList on click
    }
}

//-------------------------------------------
// MARK: - TABLE VIEW DATASOURCE AND DELEGATE
//-------------------------------------------
extension AddRecipeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firebaseRecipeList {
            return firebaseRecipes.count
        } else if tableView == ingredientsList {
            return recipeIngredients.count + 1
        } else {
            return recipeInstructions.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == firebaseRecipeList {
            
        } else if tableView == ingredientsList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell") as! RecipeCell
            return cell.layoutIngredientCellHeader()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionsCell") as! RecipeCell
            return cell.layoutInstructionCellHeader()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firebaseRecipeList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firebaseRecipeCell") as! RecipeCell
            cell.layoutCellForRecipe(firebaseRecipes[indexPath.row])
            return cell
        } else if tableView == ingredientsList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell") as! RecipeCell
            switch indexPath.row {
            case recipeIngredients.count: cell.layoutIngredientAddCell()
            default: cell.layoutIngredientCell(withIngredient: recipeIngredients[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionsCell") as! RecipeCell
            switch indexPath.row {
            case recipeInstructions.count: cell.layoutInstructionAddCell()
            default: cell.layoutInstructionCell(withInstruction: recipeInstructions[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let buffersHeight: CGFloat = 12.0
        let primaryLabelHeight: CGFloat = 30.5
        let secondaryLabelHeight: CGFloat = 10.5
        let totalHeight = buffersHeight + primaryLabelHeight + secondaryLabelHeight
        return totalHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == firebaseRecipeList {
            return 100
        } else if tableView == ingredientsList {
            return 40
        } else {
            switch indexPath.row {
            case recipeInstructions.count: return 40
            default: return 120
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == firebaseRecipeList {
            let cell = tableView.cellForRow(at: indexPath) as! RecipeCell
            guard let recipeToView = cell.recipe else { return }
            
            performSegue(withIdentifier: "showFirebaseRecipe", sender: recipeToView)
        } else if tableView == ingredientsList {
            if indexPath.row == recipeIngredients.count {
                let newIngredient = RecipeIngredient(quantity: "", unitOfMeasurement: .cup, item: "")
                recipeIngredients.append(newIngredient)
                ingredientsList.reloadData()
                updateIngredientsandInstructionsConstraints()
            }
        } else {
            if indexPath.row == recipeInstructions.count {
                let newInstruction = ""
                recipeInstructions.append(newInstruction)
                instructionsList.reloadData()
                updateIngredientsandInstructionsConstraints()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//---------------------------------------------
// MARK: - PICKER VIEW DATA SOURCE AND DELEGATE
//---------------------------------------------
extension AddRecipeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 4 }
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
//        if sender.title(for: .normal) == "Done" {
            if sender == activeDurationPicker.doneButton {
                let activeTimeString = "\(activeTime[0]):\(activeTime[1])"
                activeTimeField.inputField.text = activeTimeString
            } else if sender == totalDurationPicker.doneButton {
                let totalTimeString = "\(totalTime[0]):\(totalTime[1])"
                totalTimeField.inputField.text = totalTimeString
            }
//        }
        view.endEditing(true)
    }
}
