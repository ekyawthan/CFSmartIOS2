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
        // initialization alarm 
        NotificationHandler.setupNotificationSettings()

       /// self.setupNotification()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
      
    }

    func applicationDidEnterBackground(application: UIApplication) {
    
    }

    func applicationWillEnterForeground(application: UIApplication) {
        magic("application will enter foreground")
      
       //self.setupNotification()
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
        if identifier == "takesurvey" {
            NSNotificationCenter.defaultCenter().postNotificationName("TakeSurvey", object: nil, userInfo: nil)
            
        }else if  identifier == "snooze" {
            NotificationHandler.rescheduleAlarm("snoozing")
        
            
        }else {
            magic("something went wrong")
            
        }
        
        completionHandler()
    }
    
    
    
   

}

