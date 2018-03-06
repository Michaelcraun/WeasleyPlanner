//
//  NotificationDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 3/5/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var notificationAccessAllowed = true
    var shouldLoadToDo = false
    
    /// Removes all notifications that have been presented to the user to keep things clean and storage space minimal,
    /// then checks if user has allowed notifications access or not. Must be called before application(_:didFinishLaunchingWithOptions)
    /// has finished.
    func checkAtStartup() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if accepted {
                self.setNotificationCategories()
            } else {
                self.notificationAccessAllowed = false
            }
        }
    }
    
    private func setNotificationCategories() {
//        let completeAction = UNNotificationAction(identifier: "complete", title: "Make it a ToDone!", options: [.foreground])
//        let toDoCategory = UNNotificationCategory(identifier: "toDo", actions: [completeAction], intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([toDoCategory])
    }
    
    /// Schedules a once-only or recurring reminder with a specified date and ToDo
//    func scheduleNotification(at date: Date?, with reminderType: ReminderType, and toDo: ToDo) {
//        guard let title = toDo.title, let identifier = toDo.reminderIdentifier, let date = date else {
//            print("NOTIFICATION: Unable to schedule reminder...")
//            return
//        }
//
//        var isRepeating: Bool {
//            if reminderType == .recurring { return true }
//            return false
//        }
//
//        let dateComponents = configureComponents(from: date, with: reminderType)
//        let content = configureNotificationContent(withToDo: toDo, reminderType: reminderType, andTitle: title)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isRepeating)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) {(error) in
//            if let error = error {
//                print("NOTIFICATION: Encountered error while adding notification request: \n\(error)")
//                return
//            }
//            print("NOTIFICATION: Scheduled notification successfully!")
//        }
//    }
//
//    private func configureComponents(from date: Date, with reminderType: ReminderType) -> DateComponents {
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents(in: .current, from: date)
//
//        var newComponents = DateComponents()
//        newComponents.calendar = calendar
//
//        switch reminderType {
//        case .once:
//            newComponents.month = components.month
//            newComponents.day = components.day
//            newComponents.hour = components.hour
//            newComponents.minute = components.minute
//        case .recurring:
//            newComponents.hour = components.hour
//            newComponents.minute = components.minute
//        default: break
//        }
//
//        return newComponents
//    }
//
//    private func configureNotificationContent(withToDo toDo: ToDo, reminderType: ReminderType, andTitle title: String) -> UNMutableNotificationContent {
//        var bodyString: String {
//            if reminderType == .once {
//                guard let deadline = toDo.deadline else {
//                    return "You are \(toDo.completed)% done with this ToDo! Let's make it a ToDone!"
//                }
//                let deadlineString = deadline.format()
//                return "You are \(toDo.completed)% done with this ToDo and it's due \(deadlineString)! Let's make it a ToDone!"
//            }
//            return "It's time to work on \(toDo.title!)! Let's make it a ToDone!"
//        }
//
//        let content = UNMutableNotificationContent()
//        content.attachments = []
//        content.body = bodyString
//        content.categoryIdentifier = "toDo"
//        content.sound = UNNotificationSound.default()
//        content.title = title
//        content.userInfo = ["toDoTitle" : title]
//
//        return content
//    }
//
//    /// Method that is called to remove notifications attached to a deleted reminder
//    func removeNotification(withToDo toDo: ToDo) {
//        guard let identifier = toDo.reminderIdentifier else {
//            print("Unable to remove reminder...")
//            return
//        }
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
//    }
    
    //MARK: Method that is called when the delivered notification is interacted with by the user
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        if response.actionIdentifier == "complete" {
//            guard let toDoTitle = response.notification.request.content.userInfo["toDoTitle"] as? String else { return }
//            
//            for toDo in CoreDataHandler.instance.toDoLibrary {
//                guard let title = toDo.title else { return }
//                if title == toDoTitle {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let toDoController = storyboard.instantiateViewController(withIdentifier: "AddEditVC") as! AddEditVC
//                    toDoController.type = .toDo
//                    
//                    CoreDataHandler.instance.toDoToSave = toDo
//                    DataHandler.instance.currentVC?.present(toDoController, animated: true, completion: nil)
//                }
//            }
//        }
//        completionHandler()
    }
    
    //MARK: Method that is called when the notification is delivered and the application state is active
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
