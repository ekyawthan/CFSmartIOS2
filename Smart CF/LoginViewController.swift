//
//  LoginViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 9/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import MaterialKit

class LoginViewController: UIViewController {

   
    @IBOutlet weak var userId: MKTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

   
    @IBAction func didClickOnLogin(sender: AnyObject) {
        
        if let user = userId.text {
            User.login(user, completeHandler: {
                (response, error) in
                if error == nil {
                    // Succesfully login
                }
            })
            
        }
        
        
        
        
    }
    
}
