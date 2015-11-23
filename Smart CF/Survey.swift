//
//  Survey.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/3/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation

class Survey {
    class func isSurveyAvailable() -> Bool {
        if (isOnline()){
            print("online")
            if(isTodayIsMonday()) {
                print("yes , its the day")
                if (!isSurveyTokenToday()) {
                    print("survey not taken yet")
                    return true
                    
                }
                
            }
            
        }
        return false
    }
    
    
    class func isTodayIsMonday() -> Bool {
        //        if (getDayOfWeek() == 2){
        //            return true
        //
        //        }
        return true
    }
    class func  isOnline() -> Bool {
        return true
    }
    
    class func isSurveyTokenToday() -> Bool {
        
        return dayDifferent() < 1 ? true : false
        
        
    }
    func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(NSCalendarUnit.Weekday, fromDate: todayDate)
        let weekDay = myComponents?.weekday
        print(weekDay)
        return weekDay
    }
    
    
    class func dayDifferent() -> Int {
        
        // Replace the hour (time) of both dates with 00:00
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start  = dateFormatter.stringFromDate(NSDate())
        let end = Settings.sharedInstance.getlastSurveyDate()!
        
        return test(end, end: start)
    }
    
    
    class func test(start :String, end : String) -> Int {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate:NSDate = dateFormatter.dateFromString(start)!
        let endDate:NSDate = dateFormatter.dateFromString(end)!
        
        let cal = NSCalendar.currentCalendar()
        let now : String = dateFormatter.stringFromDate(NSDate())
        print(now)
        
        
        let unit:NSCalendarUnit = .Day
        
        let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])
        
        print("The day diff from test :\(components.day)")
        return components.day
        
        
    }
    
    class  func scheduleTime(day : Int , hour : Int ) -> NSDate? {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let today = NSDate()
        if let calendarComp = cal?.components([
            NSCalendarUnit.Year,
            NSCalendarUnit.Weekday,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.WeekOfYear,
            
            ], fromDate: today) {
                calendarComp.weekday = day
                calendarComp.weekOfYear = calendarComp.weekOfYear + 1
                calendarComp.hour = hour
                calendarComp.second = 0
        
                return cal?.dateFromComponents(calendarComp)
            
        }
        return nil
    }
    

    func wantedDay(day : Int, hour : Int) -> NSDate? {
        let dayInt  = day
        print("Raw value of monday  : \(dayInt) houtr \(hour)")
        let today : NSDate = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let  comp = cal?.components([
            NSCalendarUnit.Year,
            NSCalendarUnit.Weekday,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.WeekOfYear,
            
            ], fromDate: today) {
                print(comp.weekday)
                print(comp.hour)
               // comp.weekday = dayInt as Int
                if comp.hour > hour {
                    if comp.weekday == day {
                        comp.weekOfYear = comp.weekOfYear + 1
                    }
                }
                else if comp.weekday > day {
                    comp.weekOfYear = comp.weekOfYear + 1

                }
                else if comp.weekday == day && comp.hour == hour {
                    comp.weekOfYear = comp.weekOfYear + 1

                }
                comp.weekday = dayInt as Int

            comp.hour = hour
            
            comp.minute = 0
            comp.second = 0
            
            return cal?.dateFromComponents(comp)
            
        }
        
        return NSDate()
    }
    
    class func shouldResetAlertDate () -> Bool {
        if Settings.sharedInstance.isUserJustLoggin() {
            return true
        }
        
        return false
    }
    
}




enum Day : Int {
    case SUNDAY = 1
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    
}


struct  SurveyAlarm {
    
    var alarmTime               : NSDate
    var UUID                    : String
    
    init(alarmTime : NSDate, unitId : String){
        self.alarmTime  = alarmTime
        self.UUID       = unitId
    }

}
