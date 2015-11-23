//
//  NotificationHandler.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/18/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Magic


class NotificationHandler {
    
    class func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        if (notificationSettings.types == UIUserNotificationType.None){
            // Specify the notification types.
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
            // Specify the notification actions.
            let justInformAction = UIMutableUserNotificationAction()
            justInformAction.identifier = "justInform"
            justInformAction.title = "OK, got it"
            justInformAction.activationMode = UIUserNotificationActivationMode.Background
            justInformAction.destructive = false
            justInformAction.authenticationRequired = false
            
            let modifyListAction = UIMutableUserNotificationAction()
            modifyListAction.identifier = "takesurvey"
            modifyListAction.title = "Take Survey"
            modifyListAction.activationMode = UIUserNotificationActivationMode.Foreground
            modifyListAction.destructive = false
            modifyListAction.authenticationRequired = true
            
            let trashAction = UIMutableUserNotificationAction()
            trashAction.identifier = "snooze"
            trashAction.title = "Snooze 30 min"
            trashAction.activationMode = UIUserNotificationActivationMode.Background
            trashAction.destructive = true
            trashAction.authenticationRequired = true
            
            let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
            let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
            
            // Specify the category related to the above actions.
            let smartCfNotificationCategory = UIMutableUserNotificationCategory()
            smartCfNotificationCategory.identifier = "cfsmartNotification"
            smartCfNotificationCategory.setActions(actionsArray as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
            smartCfNotificationCategory.setActions(actionsArrayMinimal as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
            
            
            let categoriesForSettings = NSSet(objects: smartCfNotificationCategory)
            
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
    }
    
    
    
    class func scheduleInitialAlarm(fireDate : NSDate) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.alertBody = "Survey Available"
        localNotification.alertAction = "Survey"
        
        localNotification.category = "cfsmartNotification"
        localNotification.userInfo           = ["alarmUser" : "cfFirst", "UUID" : "cfsmart"]

        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    class func rescheduleAlarm(uuid : String) {
        let counter  = Settings.sharedInstance.getDelayCounter()
        if (counter < 5){
            Settings.sharedInstance.setDelayCounter(counter + 1)
            let notification                = UILocalNotification()
            notification.alertBody          = "Survey Available"
             notification.alertAction = "Survey"
            notification.fireDate           = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
            notification.soundName          = UILocalNotificationDefaultSoundName
            notification.userInfo           = ["alarmUser" : "cf", "UUID" : uuid + "\(counter)"]
            notification.category           = "cfsmartNotification"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            magic("current counter : \(counter)")
            
            
        }
        else {
            Settings.sharedInstance.setDelayCounter(0)
            
        }
    }
    
    
    class func cancelNotification(uuid : String ) {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for item in notifications {
                if let userInfo = item.userInfo {
                    if userInfo["UUID"] as! String == uuid {
                        UIApplication.sharedApplication().cancelLocalNotification(item)
                    }
                }
                
            }
        }
    }
    
    class func resetAlarmTime(day : Int, hour : Int) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if  let fireDay = Survey().wantedDay(day, hour: hour) {
            magic(fireDay)
            self.scheduleInitialAlarm(fireDay)
        }
        
    }
    
    
    
    class func cancelAllNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification in notifications {
                if let userInfo = notification.userInfo {
                    if userInfo["alarmUser"] as! String == "cf" {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
                
            }
        }
    }
    
}