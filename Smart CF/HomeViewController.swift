//
//  HomeViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/3/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var completeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func didClickOnLogOUT(sender : UIButton) {
        Settings.sharedInstance.setUserLoginStatus(isLogin: false)
        Settings.sharedInstance.setUserId("")
        Settings.sharedInstance.reset()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shouldBeginQuestionaire(sender : UIButton) {
        
        self.performSegueWithIdentifier("survey", sender: self)
        
    }
    

    

}
