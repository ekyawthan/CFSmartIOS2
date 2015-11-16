//
//  LoginViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 9/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import MaterialKit
import Magic
import Dodo

class LoginViewController: UIViewController {

    @IBOutlet weak var userId: MKTextField!
    var settings : Settings = Settings()
    var message = "Smart Cf"
    var isFirstTime : Bool = false
    @IBOutlet weak var loginButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId.floatingPlaceholderEnabled = true
        userId.cornerRadius = 2.0
        userId.placeholder = "user id"
        userId.layer.borderColor = UIColor.MKColor.Green.CGColor
        userId.rippleLayerColor = UIColor.MKColor.LightGreen
        userId.tintColor = UIColor.MKColor.LightGreen
        
        loginButton.layer.borderColor = UIColor.MKColor.Green.CGColor
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.cornerRadius = 2.0
        
        loginButton.bounds.origin.x  += self.view.bounds.size.width
        userId.bounds.origin.x  += self.view.bounds.size.width
        isFirstTime = true
        userId.delegate = self
        
        
        
    }
  
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Settings.sharedInstance.isUserLogin()
        {
            // to verify notifiation settings 
            NotificationHandler.setupNotificationSettings()
            // redirect to home
            self.performSegueWithIdentifier("home", sender: self)
        }else
        {
            if isFirstTime {
                isFirstTime = false
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.userId.bounds.origin.x -= self.view.bounds.size.width
                    }, completion: nil)
                UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
                        self.loginButton.bounds.origin.x -= self.view.bounds.size.width
                    }, completion: nil)
            }
            
        }
        
    }
   

    @IBAction func didClickOnLogin(sender: AnyObject) {
        shouldLogin()
    }
    
    private func shouldLogin() {
        if let user = userId.text {
            User.login(user, completeHandler: {[weak self]
                (response, error) in
                if error == nil {
                    // Successfully logined, set default alarm , and redirect to home
                    self!.userId.text = ""
                    if Settings.sharedInstance.isUserLogin() {
                        Settings.sharedInstance.setUserJustLoggin(true)
                        
                        let defaultFireDate = Survey.scheduleTime(2, hour: 12)
                        magic("default alarm time : \(defaultFireDate)")
                        
                        NotificationHandler.scheduleInitialAlarm(NSDate())
                        self!.performSegueWithIdentifier("home", sender: self)
                    }
                }else {
                    
                }
            })
            
        }
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userId as UITextField {
            magic("did click on return on user id")
            shouldLogin()

        }

        return true
    }
}



