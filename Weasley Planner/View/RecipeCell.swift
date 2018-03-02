//
//  RecipeCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    var recipe: Recipe?
    var recipeIngredient: RecipeIngredient?
    var selectedMeasurement: UnitOfMeasurement = .cup
    let measurementPicker: DataPicker = {
        let picker = DataPicker()
//        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
//        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    let quantityField: UITextField = {
        let field = UITextField()
        field.anchor(size: .init(width: 50, height: 0))
        field.delegate = textManager
        field.font = UIFont(name: fontName, size: smallFontSize)
        field.addBorder()
        field.textAlignment = .center
        field.textColor = secondaryTextColor
        return field
    }()
    
    let measurementField: UITextField = {
        let field = UITextField()
        field.anchor(size: .init(width: 50, height: 0))
        field.delegate = textManager
        field.font = UIFont(name: fontName, size: smallFontSize)
        field.addBorder()
        field.textAlignment = .center
        field.textColor = secondaryTextColor
        return field
    }()
    
    let itemField: UITextField = {
        let field = UITextField()
        field.anchor()
        field.delegate = textManager
        field.font = UIFont(name: fontName, size: smallFontSize)
        field.addBorder()
        field.textColor = secondaryTextColor
        return field
    }()
    
    let instructionView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = secondaryColor
        textView.delegate = textManager
        textView.font = UIFont(name: fontName, size: smallFontSize)
        textView.addBorder()
        textView.textColor = secondaryTextColor
        return textView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    //---------------------------
    // MARK: - LAYOUT FOR RECIPES
    //---------------------------
    
    func layoutCellForRecipe(_ recipe: Recipe) {
        clearCell()
        
        self.recipe = recipe
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            view.addBorder()
            view.addLightShadows()
            view.layer.cornerRadius = 5
            
            let recipeImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = recipe.image
                imageView.addBorder()
                imageView.layer.cornerRadius = 5
                return imageView
            }()
            
            let sourceLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.text = recipe.source
                label.textColor = primaryColor
                return label
            }()
            
            let recipeTitle: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: smallFontSize)
                label.numberOfLines = 0
                label.text = recipe.title
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(recipeImageView)
            view.addSubview(sourceLabel)
            view.addSubview(recipeTitle)
            
            recipeImageView.anchor(top: view.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                   size: .init(width: 90, height: 0))
            
            sourceLabel.anchor(top: view.topAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            recipeTitle.anchor(top: sourceLabel.bottomAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.bottomAnchor,
                               padding: .init(top: 0, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutCellForNoRecipes() {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            
            let defaultImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
                imageView.addBorder()
                imageView.layer.cornerRadius = 25
                return imageView
            }()
            
            let defaultTitle: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = "No Recipes..."
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(defaultImageView)
            view.addSubview(defaultTitle)
            
            defaultImageView.anchor(top: view.topAnchor,
                                    leading: view.leadingAnchor,
                                    bottom: view.bottomAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                    size: .init(width: 50, height: 0))
            
            defaultTitle.anchor(top: view.topAnchor,
                                leading: defaultImageView.trailingAnchor,
                                trailing: view.trailingAnchor,
                                bottom: view.bottomAnchor,
                                padding: .init(top: 5, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //-------------------------------
    // MARK: - LAYOUT FOR INGREDIENTS
    //-------------------------------
    
    func layoutIngredientCellHeader() -> UIView {
        clearCell()
        
        let ingredientHeaderView: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let ingredientsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.sizeToFit()
                label.text = "Ingredients"
                label.textAlignment = .center
                label.textColor = primaryTextColor
                return label
            }()
            
            let promptStack: UIStackView = {
                let stackView = UIStackView()
                stackView.alignment = .fill
                stackView.axis = .horizontal
                stackView.distribution = .fillProportionally
                stackView.spacing = 5
                
                let quantityLabel: UILabel = {
                    let label = UILabel()
                    label.anchor(size: .init(width: 50, height: 0))
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "QTY."
                    label.textAlignment = .center
                    label.textColor = primaryTextColor
                    return label
                }()
                
                let measurementLabel: UILabel = {
                    let label = UILabel()
                    label.anchor(size: .init(width: 50, height: 0))
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "MEAS."
                    label.textAlignment = .center
                    label.textColor = primaryTextColor
                    return label
                }()
                
                let itemLabel: UILabel = {
                    let label = UILabel()
                    label.anchor()
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "ITEM"
                    label.textColor = primaryTextColor
                    return label
                }()
                
                stackView.addArrangedSubview(quantityLabel)
                stackView.addArrangedSubview(measurementLabel)
                stackView.addArrangedSubview(itemLabel)
                
                return stackView
            }()
            
            view.addSubview(ingredientsLabel)
            view.addSubview(promptStack)
            
            ingredientsLabel.anchor(top: view.topAnchor,
                                    leading: view.leadingAnchor,
                                    trailing: view.trailingAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            promptStack.anchor(top: ingredientsLabel.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.bottomAnchor,
                               padding: .init(top: 2, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        return ingredientHeaderView
    }
    
    func layoutIngredientCell(withPicker picker: DataPicker) {
        clearCell()
        
        let ingredientStack: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.spacing = 5
            
            stackView.addArrangedSubview(quantityField)
            stackView.addArrangedSubview(measurementField)
            stackView.addArrangedSubview(itemField)
            
            return stackView
        }()
        
        measurementField.inputView = picker
        
        self.addSubview(ingredientStack)
        ingredientStack.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutIngredientAddCell() {
        clearCell()
        
        let addLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Add Ingredient"
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        self.addSubview(addLabel)
        addLabel.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //--------------------------------
    // MARK: - LAYOUT FOR INSTRUCTIONS
    //--------------------------------
    
    func layoutInstructionCellHeader() -> UIView {
        let instructionsView: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let instructionsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = "Instructions"
                label.textAlignment = .center
                label.textColor = primaryTextColor
                return label
            }()
            
            view.addSubview(instructionsLabel)
            instructionsLabel.fillTo(view, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
            return view
        }()
        return instructionsView
    }
    
    func layoutInstructionCell() {
        clearCell()
        
        self.addSubview(instructionView)
        instructionView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5), andSize: .init(width: 0, height: 60))
    }
    
    func layoutInstructionAddCell() {
        clearCell()
        
        let addLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Add Instruction"
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        self.addSubview(addLabel)
        addLabel.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //---------------------
    // MARK: - DATA METHODS
    //---------------------
    
    func getRecipeIngredient() -> RecipeIngredient? {
        guard let quantity = quantityField.text, quantity != "" else { return recipeIngredient }
        guard let item = itemField.text, item != "" else { return recipeIngredient }
        
        recipeIngredient = RecipeIngredient(quantity: quantity, unitOfMeasurement: selectedMeasurement, item: item)
        return recipeIngredient
    }
    
    func getInstruction() -> String? {
        guard let instruction = instructionView.text else { return nil }
        return instruction
    }
}

//-------------------------------------------
// MARK: - PICKERVIEW DATASOURCE AND DELEGATE
//-------------------------------------------

//extension RecipeCell: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return UnitOfMeasurement.allUnits.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickerLabel: UILabel = {
//            let label = UILabel()
//            label.font = UIFont(name: fontName, size: largeFontSize)
//            label.text = UnitOfMeasurement.allUnits[row].rawValue
//            label.textAlignment = .center
//            label.textColor = secondaryTextColor
//            return label
//        }()
//
//        return pickerLabel
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedMeasurement = UnitOfMeasurement.allUnits[row]
//        print("MEASUREMENT: selectedMeasurement: \(selectedMeasurement)")
//    }
//
//    @objc func pickerButtonPressed(_ sender: UIButton) {
//        endEditing(true)
//
//        if sender.title(for: .normal) == "Done" {
//            print("MEASUREMENT: in RecipeCell")
//            if sender == measurementPicker.doneButton {
//                print("MEASUREMENT: assigning TextField...")
//                measurementField.text = selectedMeasurement.shortHandNotation
//            }
//        }
//    }
//}

