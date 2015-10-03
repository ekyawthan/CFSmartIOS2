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

class LoginViewController: UIViewController {

   
    @IBOutlet weak var userId: MKTextField!
    var settings : Settings = Settings()

    
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
        

    }

   
    @IBAction func didClickOnLogin(sender: AnyObject) {
        
        if let user = userId.text {
            User.login(user, completeHandler: {
                (response, error) in
                if error == nil {
                    // Succesfully login
                    
                    magic(response)
                    
                    magic("Login successfully")
                }
            })
            
        }
        
        
        
        
    }
    
}
