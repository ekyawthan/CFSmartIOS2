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
    
    
    class func scheduleAlarm(item : SurveyAlarm) {
        let counter  = Settings.sharedInstance.getDelayCounter()
        if (counter < 5){
            Settings.sharedInstance.setDelayCounter(counter + 1)
            let notification                = UILocalNotification()
            notification.alertBody          = "Survey available"
            notification.alertAction        = "open"
            notification.fireDate           = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
            notification.soundName          = UILocalNotificationDefaultSoundName
            notification.userInfo           = ["alarmUser" : "cf", "UUID" : "UUID1"]
            notification.category           = "SURVEY_ALARM_CATAGORIES"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        else {
            Settings.sharedInstance.setDelayCounter(0)
            
        }
    }
    
        
        
}