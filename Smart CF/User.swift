//
//  User.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 9/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import Alamofire
import Magic
import SwiftyJSON


class User {
    static let baseURL = "http://54.175.149.177"
    
    class func login(userId : String, completeHandler : (response : AnyObject, error : NSError?)->()) {
        
        Alamofire.request(.GET,  baseURL + "/user/\(userId)/")
            .response{ (_, response, data , error) in
                if  let reponseHeader = response  {
                    if reponseHeader.statusCode == 200 {
                        completeHandler(response: "Success", error: nil)
                        Settings.sharedInstance.setUserLoginStatus(isLogin: true)
                        Settings.sharedInstance.setUserId(userId)
                       
                    }else {
                        completeHandler(response: "failed", error: nil)
                        Settings.sharedInstance.setUserLoginStatus(isLogin: false)
                        Settings.sharedInstance.setUserId(userId)
                    }
                }
                
        }
        
    }
    
    class func postSurvey(answerList : [Int], completeHandler : (response : AnyObject, error : NSError?)->()) {
        let settings = Settings.sharedInstance

        let userID : String = settings.getUserId()!
        let delay : Int = settings.getDelayCounter()
        
        let parameter :[String : AnyObject] = [
            
            
            "author": userID,
            "question1": answerList[0],
            "question2": answerList[1],
            "question3": answerList[2],
            "question4": answerList[3],
            "question5": answerList[4],
            "question6": answerList[5],
            "question7": answerList[6],
            "question8": answerList[7],
            "question9": answerList[8],
            "question10": answerList[9],
            "question11": answerList[10],
            "question12": answerList[11],
            "question13": answerList[12],
            "question14": answerList[13],
            "delay_counter": delay
        ]
        magic(JSON(parameter))
        
       Alamofire.request(.POST, baseURL + "/survey/", parameters: parameter, encoding: .JSON)
        .response{(_, response, data, error) in
            if let responseData = response {
                if responseData.statusCode == 201 {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let surveyDate  = dateFormatter.stringFromDate(NSDate())
                    settings.setLastSurveyDate(surveyDate)
                    Settings.sharedInstance.setDelayCounter(0)
                     NotificationHandler.cancelAllNotification()
                    completeHandler(response: "Success", error: nil)
                
                }else {
                    completeHandler(response: "failed", error: nil)
                }
            }
        }
        
    
    }
    

}
