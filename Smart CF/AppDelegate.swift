//
//  AppDelegate.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 9/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import IQKeyboardManager

import Magic

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = false

        self.setupNotification()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        magic("application will enter foreground")
      
       self.setupNotification()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        magic(notificationSettings.description)
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Cancelling if user is not login!!
        if !Settings.sharedInstance.isUserLogin() {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if identifier == "TakeSurvey" {
            NSNotificationCenter.defaultCenter().postNotificationName("TakeSurvey", object: nil, userInfo: nil)
            
        }else if  identifier == "Snooze" {
            SurveyHandler.rescheduleAlarm("snoozing")
           // NSNotificationCenter.defaultCenter().postNotificationName("Snooze", object: nil, userInfo: nil)
            
        }else {
            magic("something went wrong")
            
        }
    }
    
    
    
    private func setupNotification() {
        magic("NOTIFICATION INITIALIZATION")

        let notification : UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()!
        
        if (notification.types == UIUserNotificationType.None){
            
            let notificationType : UIUserNotificationType = [.Alert , .Badge , .Sound]
           

            
            // take action
            
            let takeSurvey = UIMutableUserNotificationAction()
            takeSurvey.identifier = "TakeSurvey"
            takeSurvey.activationMode = .Foreground
            takeSurvey.destructive = false
            takeSurvey.title = "Take Survey"
            takeSurvey.authenticationRequired = false
            
            
            // snooze for 30
            let snooze30min = UIMutableUserNotificationAction()
            snooze30min.title = "Snooze for 30 minutes"
            snooze30min.activationMode = .Background
            snooze30min.destructive = true
            snooze30min.identifier = "Snooze"
            snooze30min.authenticationRequired = false
            
            let actionsArray = NSArray(objects: takeSurvey, snooze30min)
            let actionsArrayMinimal = NSArray(objects: takeSurvey, snooze30min)
            
            let cfSmartNotificationCategory = UIMutableUserNotificationCategory()
            cfSmartNotificationCategory.identifier = "CfSmartNotification"
            cfSmartNotificationCategory.setActions(actionsArray as? [UIUserNotificationAction], forContext: .Default)
            cfSmartNotificationCategory.setActions(actionsArrayMinimal as? [UIUserNotificationAction], forContext: .Minimal)
            let catgoriesForSettings = NSSet(objects: cfSmartNotificationCategory)
            let registeredNotification = UIUserNotificationSettings(forTypes: notificationType, categories: catgoriesForSettings as? Set<UIUserNotificationCategory>)
            UIApplication.sharedApplication().registerUserNotificationSettings(registeredNotification)
            



        }

    }


}

