//
//  HomeViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/3/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import BubbleTransition
import Magic
import ActionSheetPicker_3_0
import BRYXBanner

struct BannerColors {
    static let red = UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000)
    static let green = UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000)
    static let yellow = UIColor(red:255.0/255.0, green:204.0/255.0, blue:51.0/255.0, alpha:1.000)
    static let blue = UIColor(red:31.0/255.0, green:136.0/255.0, blue:255.0/255.0, alpha:1.000)
}

class HomeViewController: UIViewController {
    
    let transition = BubbleTransition()
    
    let dayList = ["Monday" , "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let hourList = [ "8 AM",
        "9 AM ", "10 AM", "11 AM", "12 PM ", "1 PM", "2 PM"
        , "3 PM ", "4 PM", "5 PM", "6 PM ", "7 PM", "8 PM"
    ]
    var day : [[String :Int]] = []
    var time : [[String : Int]] = []
    

    @IBOutlet weak var takeSurvey: UIButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor(red: 245 / 255.0, green: 124 / 255.0, blue: 1 / 255.0, alpha: 1)
        
        logoutButton.layer.cornerRadius = 4
        logoutButton.layer.shadowColor = UIColor.brownColor().CGColor
        logoutButton.layer.shadowRadius = 5
        
        resetButton.layer.cornerRadius = 4
        resetButton.layer.shadowRadius = 5
        resetButton.layer.shadowColor = UIColor.brownColor().CGColor
        
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.blackColor()]
        completeLabel.lineBreakMode = .ByWordWrapping
        completeLabel.numberOfLines = 0
        toggleSurveyButton()
        // notification observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleSurveyButton", name: "reloadHome", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "takeToSurvey", name: "TakeSurvey", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleSurveyButton", name: "justCompleteSurvey", object: nil)
        // requesting permission if it has been revoked!!
       // NotificationHandler.setupNotificationSettings()
        
        var dayCounter =  0
        for item in dayList {
            day.append([item : dayCounter])
            dayCounter++
        }
        var hourCounter = 8
        for item in hourList {
            time.append([item : hourCounter])
            hourCounter++
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func showAction() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Settings.sharedInstance.getAlarmStatus() {
            self.performSegueWithIdentifier("customizeAlertTime", sender: self)
        }
        
    }
    
    
    func takeToSurvey() {
        self.performSegueWithIdentifier("take_survey", sender: self)
    }

    @IBAction func didClickOnLogOUT(sender : UIButton) {
        Settings.sharedInstance.setUserLoginStatus(isLogin: false)
        Settings.sharedInstance.setUserId("")
        Settings.sharedInstance.reset()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shouldBeginQuestionaire(sender : UIButton) {
        
        magic("presenting surveuy")
    
        //self.performSegueWithIdentifier("survey", sender: self)
        
    }
    
    
    func toggleSurveyButton() {
        if Survey.isSurveyAvailable(){
            completeLabel.text = ""
            takeSurvey.hidden = false
            takeSurvey.userInteractionEnabled = true
            takeSurvey.backgroundColor = UIColor.MKColor.Orange
            takeSurvey.layer.cornerRadius = 4.0
            takeSurvey.layer.borderColor = UIColor.MKColor.Amber.CGColor
            takeSurvey.layer.borderWidth = 1.0
            takeSurvey.setTitle("Begin Questionnaire", forState: UIControlState.Normal)
        }else{
            
            completeLabel.text = "Thank you for completing this questionnaire"
            takeSurvey.hidden = true
            takeSurvey.userInteractionEnabled = false
            takeSurvey.backgroundColor = UIColor.clearColor()
            takeSurvey.setTitle("", forState: UIControlState.Normal)
        }
    }
    

    @IBAction func didClickOnSettings(sender: AnyObject) {
//        self.performSegueWithIdentifier("customizeAlertTime", sender: self)
        
        
        ActionSheetMultipleStringPicker.showPickerWithTitle("Select Day, Time", rows: [
            dayList,
            hourList,
            ], initialSelection: [2, 2], doneBlock: {
                picker, values, indexes in
                let dayAsKey = indexes[0] as! String
                let hourAsKey = indexes[1] as! String
                for item in self.day {
                    for (k, v) in item  {
                        if k == dayAsKey {
                            Settings.sharedInstance.setAlertDay(v)
                        }
                    }
                }
                for item in self.time {
                    for (k, v) in item {
                        if k == hourAsKey {
                            Settings.sharedInstance.setAlertHour(v)
                        }
                    }
                }
                magic("\(Settings.sharedInstance.getAlertDay()) hour : \(Settings.sharedInstance.getAlertHour())")
                if let fireDay = Survey.scheduleTime(Settings.sharedInstance.getAlertDay(), hour: Settings.sharedInstance.getAlertHour()) {
                    magic(fireDay)
                    
                    NotificationHandler.scheduleInitialAlarm(fireDay)
                    let banner = Banner(title: "Successful!", subtitle: "Reset to \(dayAsKey) : \(hourAsKey)", image: nil, backgroundColor: BannerColors.green)
                    banner.show(duration: 1.5)
                }
              
                return
            }, cancelBlock: { ActionMultipleStringCancelBlock in return }, origin: sender)
        

    }

}




extension HomeViewController : UIViewControllerTransitioningDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let controller = segue.destinationViewController
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = self.view.center
        transition.bubbleColor = UIColor.MKColor.Orange
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .Dismiss
        transition.startingPoint = self.view.center
        transition.bubbleColor = UIColor.whiteColor()
        return transition
    }
}


extension HomeViewController  {
    
    @IBAction func didClickOnResetAlarmTime(sender: AnyObject) {
        
        self.performSegueWithIdentifier("customizeAlertTime", sender: self)

    }
}





