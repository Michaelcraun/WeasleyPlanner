//
//  ViewFirebaseRecipeVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/21/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class ViewFirebaseRecipeVC: UIViewController {
    
    // ----------------------
    // MARK: - Data Variables
    // ----------------------
    var firebaseRecipeToView: Recipe?
    
    override var previewActionItems: [UIPreviewActionItem] {
        var actionItems = [UIPreviewActionItem]()
        
        let likeAction = UIPreviewAction(title: "Like Recipe", style: .default) { (action, controller) in
            //TODO: Allow for liking Firebase recipe
        }
        
        let reportAction = UIPreviewAction(title: "Delete", style: .destructive) { (action, controller) in
            //TODO: Allow for deletion of recipe
        }
        
        let suggestEditAction = UIPreviewAction(title: "Add to Shopping List", style: .default) { (action, controller) in
            //TODO: Allow for adding
        }
        
//        for i in 0..<subToDos.count {
//            if let title = subToDos[i].title {
//                let action = UIPreviewAction(title: "Toggle \(title)", style: .default, handler: { (action, controller) in
//                    self.subToDos[i].completed = !self.subToDos[i].completed
//                    self.savePressed(sender: nil)
//                    CoreDataHandler.instance.attemptFetch()
//
//                    guard let mainVC = DataHandler.instance.owningVC as? MainVC else { return }
//                    mainVC.toDoTable.reloadData()
//                    mainVC.animateProgressBars()
//                })
//
//                actionItems.append(action)
//            }
//        }
        return actionItems
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
}
