//
//  SettingViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/12/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Magic

class SettingViewController: UIViewController {
    
    @IBOutlet weak var HourSelector: IQDropDownTextField!
    @IBOutlet weak var DaySelector: IQDropDownTextField!
    @IBOutlet weak var currentAlertTime: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    let dayList = ["Monday" , "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let timeList = [ "8 AM",
        "9 AM ", "10 AM", "11 AM", "12 PM ", "1 PM", "2 PM"
        , "3 PM ", "4 PM", "5 PM", "6 PM ", "7 PM", "8 PM"
    ]
    
    
    var day : [[String :Int]] = []
    var time : [[String : Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HourSelector.delegate = self
        DaySelector.delegate = self
        
       
        HourSelector.itemList = timeList
        HourSelector.isOptionalDropDown = false
        DaySelector.itemList = dayList
        DaySelector.isOptionalDropDown = false
        
        resetButton.layer.cornerRadius = 4
        resetButton.layer.borderColor = UIColor.MKColor.Orange.CGColor
        resetButton.layer.borderWidth = 1
        
        skipButton.layer.cornerRadius = 4
        skipButton.layer.borderColor = UIColor.MKColor.Orange.CGColor
        skipButton.layer.borderWidth = 1
        var dayCounter =  0
        for item in dayList {
            day.append([item : dayCounter])
            dayCounter++
        }
        var hourCounter = 8
        for item in timeList {
            time.append([item : hourCounter])
            hourCounter++
        }
        let currentHour = timeList[Settings.sharedInstance.getAlertHour() == 0 ? 4 : Settings.sharedInstance.getAlertHour() - 8]
        let currentDay = dayList[Settings.sharedInstance.getAlertDay()]
        HourSelector.text =  currentHour
        DaySelector.text = currentDay
        currentAlertTime.text = currentDay + " " + currentHour
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        if self.HourSelector.isFirstResponder() {
            self.HourSelector.resignFirstResponder()
        }
        else if self.DaySelector.isFirstResponder() {
            self.DaySelector.hidden = true
        }
        
    }
    

}


extension SettingViewController {
    
    @IBAction func didClickOnSkip(sender: AnyObject) {
        
       // initialAlertTime()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func didClickOnUpdateAlertTime(sender: AnyObject) {
        Settings.sharedInstance.setUserJustLoggin(false)
        if let dayAsKey = DaySelector.text {
            for item in day {
                for (k, v) in item  {
                    if k == dayAsKey {
                        Settings.sharedInstance.setAlertDay(v)
                    }
                }
            }
        }
        
        if let hourAsKey = HourSelector.text {
            for item in time {
                for (k, v) in item {
                    if k == hourAsKey {
                        Settings.sharedInstance.setAlertHour(v)
                    }
                }
            }
        }
       // initialAlertTime()
        
        self.view.endEditing(true)
        let item = SurveyAlarm(alarmTime:
            Survey.scheduleTime(Settings.sharedInstance.getAlertDay(), hour: Settings.sharedInstance.getAlertHour() == 0 ? 12 : Settings.sharedInstance.getAlertHour())!,
            unitId: "cf")
        SurveyHandler.scheduleAlarm(item)
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    
    private func initialAlertTime() {
        Settings.sharedInstance.setUserJustLoggin(false)
        if let fireDate : NSDate = Survey.scheduleTime(Settings.sharedInstance.getAlertDay(), hour: Settings.sharedInstance.getAlertHour()) {
            let item : SurveyAlarm = SurveyAlarm(alarmTime: fireDate, unitId: "First")
            SurveyHandler.scheduleAlarm(item)
            
        }else {
            /// set upd
        }
        
    }
}


extension SettingViewController : IQDropDownTextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField == HourSelector as UITextField {
            HourSelector.resignFirstResponder()
            DaySelector.becomeFirstResponder()
        }
        
        else if textField == DaySelector as UITextField {
            DaySelector.resignFirstResponder()
        }
        return true
    }
    
    func textField(textField: IQDropDownTextField!, didSelectItem item: String!) {
        
        if textField.isEqual(DaySelector) {
            currentAlertTime.text = "\(item) \(HourSelector.text!)"
        }else {
            currentAlertTime.text = "\(DaySelector.text!) \(item)"
            self.view.endEditing(true)
        }
        
       
    }
    
    
}