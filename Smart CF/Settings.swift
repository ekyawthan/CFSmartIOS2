//
//  Settings.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 9/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

//
//  Settings.swift
//  CfSmart
//
//  Created by Kyaw Than Mong on 6/1/15.
//  Copyright (c) 2015 meeratech. Inc. All rights reserved.
//

import Foundation

let UserLoginStatus = "loginStatus"
let UserId = "userID"
let delayCounter = "delayCounter"
let LastSurveyDate = "lastSurveyDate"

class Settings {
    
    class var sharedInstance : Settings {
        struct Static {
            static let instance : Settings = Settings()
        }
        return Static.instance
        
    }
    let settings = NSUserDefaults.standardUserDefaults()
    
    // user login status
    
    func isUserLogin()->Bool                            { return settings.boolForKey(UserLoginStatus)}
    func setUserLoginStatus(isLogin isLogin:Bool)              { settings.setObject(isLogin, forKey: UserLoginStatus)}
    
    func setUserId(userId : String)                     { settings.setObject(userId, forKey: UserId)}
    func getUserId() -> String?                         { return settings.stringForKey(UserId)}
    
    func setDelayCounter(counter : Int)                 { settings.setInteger(counter, forKey: delayCounter)}
    func getDelayCounter () -> Int                      { return settings.integerForKey(delayCounter)}
    
    func setLastSurveyDate(date : String)              { settings.setObject(date, forKey: LastSurveyDate)}
    
    func getlastSurveyDate() -> String?                 {
        let surveyDate = settings.stringForKey(LastSurveyDate)
        if surveyDate == nil {
            return "2010-09-01"
        }
        return surveyDate
    }
    
    func setAlertHour(hour : Int = 12) {
        settings.setInteger(hour, forKey: "hour")
        
    }
    
    func getAlertHour() -> Int {
        return settings.integerForKey("hour")
    }
    
    func setAlertDay(day : Int ) {
        settings.setInteger(day, forKey: "day")
    }
    
    
    func getAlertDay() -> Int {
        return settings.integerForKey("day")
    }
    
    func setUserJustLoggin(isJustLogin : Bool) {
        settings.setBool(isJustLogin, forKey: "userLogin")
    }
    
    func isUserJustLoggin() -> Bool {
        return settings.boolForKey("userLogin")
    }
    
    
    
    func reset(){
        if let appDomain : NSString = NSBundle.mainBundle().bundleIdentifier {
            print("deleting Settings of  \(appDomain)")
            self.settings.removePersistentDomainForName(appDomain as String)
        }
    }
    
}