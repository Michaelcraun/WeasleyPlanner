//
//  Alertable.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

protocol Alertable {  }

enum Alert {
    case defaultError
    case generalFirebaseError
    
    case addUserToFamily
    case emailInUse
    case imageError
    case internalError
    case invalidEmail
    case invalidFamilyName
    case logoutError
    case networkError
    case noEmail
    case noFirstName
    case noLastName
    case noNearbyUsers
    case noPassword
    case startFamily
    case userDisabled
    case weakPassword
    case wrongPassword
    
    var title: String {
        switch self {
        case .generalFirebaseError: return "Firebase Error:"
        case .addUserToFamily: return "Add User?"
        case .emailInUse: return Alert.generalFirebaseError.title
        case .imageError: return Alert.generalFirebaseError.title
        case .internalError: return Alert.generalFirebaseError.title
        case .logoutError: return Alert.generalFirebaseError.title
        case .networkError: return Alert.generalFirebaseError.title
        case .noEmail: return "No Email!"
        case .noFirstName: return "No First Name!"
        case .noLastName: return "No Last Name!"
        case .noNearbyUsers: return "No Nearby Users!"
        case .noPassword: return "No Password!"
        case .startFamily: return "Start a Family"
        case .weakPassword: return Alert.generalFirebaseError.title
        case .wrongPassword: return Alert.generalFirebaseError.title
        default: return "Error:"
        }
    }
    
    var message: String {
        switch self {
        case .generalFirebaseError: return "An unexpected error occured in Firebase. Please try again."
        case .addUserToFamily: return "Are you sure you want to add this user to your family?"
        case .emailInUse: return "The email you've entered is already in use. Please try again."
        case .imageError: return "There was an error storing your image on Firebase. Please try again, later."
        case .internalError: return Alert.generalFirebaseError.message
        case .invalidFamilyName: return "The name you have entered is invalid. Please try again."
        case .logoutError: return "There was an error logging out. Please try again."
        case .networkError: return "The network seems to have timed out. Please try again."
        case .noEmail: return "Please input a valid email and try again."
        case .noFirstName: return "Please input your first name and try again."
        case .noLastName: return "Please input your last name and try again."
        case .noNearbyUsers: return "We couldn't find any Weasley Planner users within 1 mile of you. Would you like to try again?"
        case .noPassword: return "Please input a valid password and try again."
        case .startFamily: return "You're starting a family. Please enter your family's name:"
        case .weakPassword: return "Your password must be at least 6 characters long. Please try again."
        case .wrongPassword: return "The password you've entered is incorrect. Please try again."
        default: return "An unexpected error occured. Please try again."
        }
    }
    
    var notificationType: NotificationType {
        switch self {
        case .addUserToFamily: return .warning
        case .startFamily: return .warning
        default: return .error
        }
    }
    
    var needsOptions: Bool {
        switch self {
        case .addUserToFamily: return true
        case .noNearbyUsers: return true
        default: return false
        }
    }
    
    var needsTextField: Bool {
        switch self {
        case .startFamily: return true
        default: return false
        }
    }
}

enum NotificationDevice {
    case haptic
    case vibrate
    case none
}

enum NotificationType {
    case error
    case success
    case warning
}

extension Alertable where Self: UIViewController {
    func showAlert(_ alert: Alert) {
        var defaultActionTitle: String {
            switch alert.needsOptions {
            case true: return "No"
            case false: return "OK"
            }
        }
        
        view.addBlurEffect(tag: 1001)
        addVibration(withNotificationType: alert.notificationType)
        
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: defaultActionTitle, style: .default) { (action) in
            self.dismissAlert()
            
            if alert.needsTextField {
                if let settings = self as? SettingsVC {
                    if let familyName = alertController.textFields![0].text, familyName != "" {
                        settings.createFirebaseFamily(with: familyName)
                    } else {
                        self.showAlert(.invalidFamilyName)
                    }
                }
            }
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.dismissAlert()
            
            if alert == .addUserToFamily {
                if let settings = self as? SettingsVC {
                    settings.updateFirebaseFamilyWithSelectedUser()
                }
            } else if alert == .noNearbyUsers {
                if let settings = self as? SettingsVC {
                    settings.familyButtonPressed(nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismissAlert()
        }
        
        if alert.needsTextField {
            alertController.addTextField(configurationHandler: { (familyNameField) in
                
            })
        }
        
        alertController.addAction(defaultAction)
        if alert.needsOptions { alertController.addAction(yesAction) }
        if alert.needsTextField { alertController.addAction(cancelAction) }
        
        present(alertController, animated: false, completion: nil)
    }
    
    private func dismissAlert() {
        for subview in self.view.subviews {
            if subview.tag == 1001 {
                subview.fadeAlphaOut()
            }
        }
    }
    
    private func addVibration(withNotificationType type: NotificationType) {
        var notificationDevice: NotificationDevice {
            switch UIDevice.current.modelName {
            case "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPhone 8", "iPhone 8 Plus", "iPhone X": return .haptic
            case "iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE": return .vibrate
            default: return .none
            }
        }
        
        switch notificationDevice {
        case .haptic:
            let notification = UINotificationFeedbackGenerator()
            switch type {
            case .error: notification.notificationOccurred(.error)
            case .success: notification.notificationOccurred(.success)
            case .warning: notification.notificationOccurred(.warning)
            }
        case .vibrate:
            let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
            switch type {
            case .error: AudioServicesPlaySystemSound(vibrate)
            default: break
            }
        default: break
        }
    }
}
