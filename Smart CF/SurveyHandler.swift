//
//  SurveyHandler.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/4/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import UIKit


class SurveyHandler {
    class func sharedInstance () -> SurveyHandler {
        struct Static {
            static let instance : SurveyHandler = SurveyHandler()
        }
        return Static.instance
    }
    
    
    class func rescheduleAlarm(uuid : String) {
        let counter  = Settings.sharedInstance.getDelayCounter()
        if (counter < 5){
            Settings.sharedInstance.setDelayCounter(counter + 1)
            let notification                = UILocalNotification()
            notification.alertBody          = "Survey available"
            notification.alertAction        = "open"
            notification.fireDate           = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
            notification.soundName          = UILocalNotificationDefaultSoundName
            notification.userInfo           = ["alarmUser" : "cf", "UUID" : uuid]
            notification.category           = "SURVEY_ALARM_CATAGORIES"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        else {
            Settings.sharedInstance.setDelayCounter(0)
            
        }
    }
    
    
    
    class func scheduleAlarm(item : SurveyAlarm) {
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Survey Available"
        notification.alertAction = "open"
        notification.fireDate = NSDate()
        notification.repeatInterval = NSCalendarUnit.Weekday
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["alarmUser" : "cf_smarter", "UUID" : "First"]
        notification.category           = "SURVEY_ALARM_CATAGORIES"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

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