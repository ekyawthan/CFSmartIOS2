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

class HomeViewController: UIViewController {
    
    let transition = BubbleTransition()

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
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        self.performSegueWithIdentifier("customizeAlertTime", sender: self)

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





