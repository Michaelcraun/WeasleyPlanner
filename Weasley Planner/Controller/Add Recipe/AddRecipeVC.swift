//
//  AddRecipeVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/16/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class AddRecipeVC: UIViewController {
    //MARK: UI Variables
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Add Recipe"
        return bar
    }()
    
    //------------------//
    // FIREBASE RECIPES //
    //------------------//
    
    let firebaseRecipeList = UITableView()
    let searchBar: ModernSearchBar = {
        let bar = ModernSearchBar()
        bar.searchLabel_font = UIFont(name: fontName, size: smallFontSize)
        bar.searchLabel_textColor = primaryTextColor
        bar.searchLabel_backgroundColor = primaryColor
        bar.suggestionsView_maxHeight = 180
        bar.suggestionsView_separatorStyle = .none
        bar.suggestionsView_contentViewColor = primaryColor
        return bar
    }()
    
    let activeDurationPicker: DataPicker = {
        let picker = DataPicker()
        picker.anchor()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    let measurementPicker: DataPicker = {
        let picker = DataPicker()
        picker.anchor()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    let totalDurationPicker: DataPicker = {
        let picker = DataPicker()
        picker.anchor()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    //----------------------//
    // NEW/EDIT RECIPE FORM //
    //----------------------//
    
    var ingredientsListHeight: NSLayoutConstraint!
    var instructionsListHeight: NSLayoutConstraint!
    let ingredientsList = UITableView()
    let instructionsList = UITableView()
    let titleField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .title
        return field
    }()
    
    let isFavoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(isFavoriteButtonPressed(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "isNotFavoriteIcon"), for: .normal)
        return button
    }()
    
    let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        imageView.addBorder()
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let recipeImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(imageButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let descriptionView: InputView = {
        let field = InputView()
        field.inputTextView.delegate = textManager
        field.inputType = .description
        return field
    }()
    
    let yieldField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .yield
        return field
    }()
    
    let activeTimeField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .activeTime
        return field
    }()
    
    let totalTimeField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .totalTime
        return field
    }()
    
    let notesView: InputView = {
        let field = InputView()
        field.inputTextView.delegate = textManager
        field.inputType = .notes
        return field
    }()
    
    let sourceField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .source
        return field
    }()
    
    let urlField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .url
        return field
    }()
    
    let shareOnFirebaseSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(saveToFirebaseSwitchPressed(_:)), for: .valueChanged)
        switcher.onTintColor = primaryColor
        switcher.setOn(true, animated: false)
        switcher.tintColor = primaryColor
        return switcher
    }()
    
    let saveButton: TextButton = {
        let button = TextButton()
        button.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        button.title = "SAVE AND SHARE RECIPE"
        return button
    }()
    
    //MARK: DataVariables
    var user: User?
    
    //------------------//
    // FIREBASE RECIPES //
    //------------------//
    var isAddingFirebaseRecipe = false
    var firebaseRecipes = [Recipe]() {
        didSet {
            firebaseRecipeList.reloadData()
            searchBar.setDatas(datas: getSearchableData())
        }
    }
    
    //-----------------//
    // NEW/EDIT RECIPE //
    //-----------------//
    var recipeToEdit: Recipe?
    var recipeIsFavorite = false
    var shareToFirebase = true
    var activeTime = [0,30]
    var totalTime = [1,0]
    var ingredientCount = 0
    var instructionCount = 0
    var recipeIngredients = [RecipeIngredient]() {
        didSet {
            ingredientCount = recipeIngredients.count
            ingredientsList.reloadData()
        }
    }
    
    var recipeInstructions = [String]() {
        didSet {
            instructionCount = recipeInstructions.count
            instructionsList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeDurationPicker.dataPicker.dataSource = self
        activeDurationPicker.dataPicker.delegate = self
        measurementPicker.dataPicker.dataSource = self
        measurementPicker.dataPicker.delegate = self
        totalDurationPicker.dataPicker.dataSource = self
        totalDurationPicker.dataPicker.delegate = self

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textManager.delegate = self
        titleBar.delegate = self
    }
    
    func loadRecipeData() {
        guard let recipe = recipeToEdit else { return }
        
        recipeIsFavorite = recipe.isFavorite
        activeTime = [recipe.activeHours, recipe.activeMinutes]
        totalTime = [recipe.totalHours, recipe.totalMinutes]
        
        activeTimeField.inputField.text = "\(activeTime[0]):\(activeTime[1])"
        titleField.inputField.text = recipe.title
        descriptionView.inputTextView.text = recipe.description
        recipeImageView.image = recipe.image
//        ingredientsView.inputTextView.text = recipe.ingredients
//        instructionsView.inputTextView.text = recipe.instructions
        notesView.inputTextView.text = recipe.notes
        sourceField.inputField.text = recipe.source
        totalTimeField.inputField.text = "\(totalTime[0]):\(totalTime[1])"
        urlField.inputField.text = recipe.url
        yieldField.inputField.text = recipe.yield
        
        switch recipeIsFavorite {
        case true: isFavoriteButton.setImage(#imageLiteral(resourceName: "isFavoriteIcon"), for: .normal)
        case false: isFavoriteButton.setImage(#imageLiteral(resourceName: "isNotFavoriteIcon"), for: .normal)
        }
    }
    
    @objc func isFavoriteButtonPressed(_ sender: UIButton) {
        recipeIsFavorite = !recipeIsFavorite
        
        switch sender.image(for: .normal)! {
        case #imageLiteral(resourceName: "isNotFavoriteIcon"): sender.setImage(#imageLiteral(resourceName: "isFavoriteIcon"), for: .normal)
        case #imageLiteral(resourceName: "isFavoriteIcon"): sender.setImage(#imageLiteral(resourceName: "isNotFavoriteIcon"), for: .normal)
        default: break
        }
    }
    
    @objc func imageButtonPressed(_ sender: UIButton) {
        photoManager.delegate = self
        photoManager.displayImageController()
    }
    
    func setSelectedImage(_ image: UIImage) {
        recipeImageView.image = image
    }
    
    @objc func saveToFirebaseSwitchPressed(_ sender: UISwitch) {
        shareToFirebase = !shareToFirebase
        if shareToFirebase {
            saveButton.title = "SAVE AND SHARE RECIPE"
        } else {
            saveButton.title = "SAVE RECIPE"
        }
    }
    
    @objc func saveButtonPressed(_ sender: TextButton?) {
        view.endEditing(true)
        
        guard let recipe = recipeToEdit else {
            guard let title = titleField.inputField.text, title != "" else {
                showAlert(.missingTitle)
                return
            }
            
            let recipeIdentifier = DataHandler.instance.createRecipeIDString(with: title)
            let newRecipe = Recipe(identifier: recipeIdentifier, title: title)
            newRecipe.activeHours = activeTime[0]
            newRecipe.activeMinutes = activeTime[1]
            newRecipe.totalHours = totalTime[0]
            newRecipe.totalMinutes = totalTime[1]
            newRecipe.isFavorite = recipeIsFavorite
            newRecipe.imageName = NSUUID().uuidString
            if let description = descriptionView.inputTextView.text { newRecipe.description = description }
            if let image = recipeImageView.image { newRecipe.image = image }
//            if let instructions = instructionsView.inputTextView.text { newRecipe.instructions = instructions }
            if let notes = notesView.inputTextView.text { newRecipe.notes = notes }
            if let source = sourceField.inputField.text { newRecipe.source = source }
            if let url = urlField.inputField.text { newRecipe.url = url }
            if let yield = yieldField.inputField.text { newRecipe.yield = yield }
            updateFamilyRecipe(newRecipe)
            if shareToFirebase { uploadRecipeToFirebase(newRecipe) }
            
            return
        }
        
        guard let title = titleField.inputField.text, title != "" else {
            showAlert(.missingTitle)
            return
        }
        
        recipe.title = title
        recipe.activeHours = activeTime[0]
        recipe.activeMinutes = activeTime[1]
        recipe.totalHours = totalTime[0]
        recipe.totalMinutes = totalTime[1]
        recipe.isFavorite = recipeIsFavorite
        recipe.imageName = NSUUID().uuidString
        if let description = descriptionView.inputTextView.text { recipe.description = description }
        if let image = recipeImageView.image { recipe.image = image }
//        if let instructions = instructionsView.inputTextView.text { recipe.instructions = instructions }
        if let notes = notesView.inputTextView.text { recipe.notes = notes }
        if let source = sourceField.inputField.text { recipe.source = source }
        if let url = urlField.inputField.text { recipe.url = url }
        if let yield = yieldField.inputField.text { recipe.yield = yield }
        updateFamilyRecipe(recipe)
        if shareToFirebase { uploadRecipeToFirebase(recipe) }
    }
}
