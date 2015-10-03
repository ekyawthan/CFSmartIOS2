//
//  SurveyViewController.swift
//  Smart CF
//
//  Created by Kyaw Than Mong on 10/3/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import MaterialKit
import Magic

class SurveyViewController: UIViewController {
    
    let SurveyQuestions : [String]  =  [
        "In the past week have you had an increase in sputum volume or change in colour?",
        
        "In the past week have you had new or increased blood in your sputum?",
        
        "In the past week have you had increased cough, or new pain on coughing?",
        
        "In the past week have you had new or increased wheeze?",
        
        "In the past week have you had new or increased chest tightness?",
        
        "In the past week have you had increased shortness of breath or difficulty breathing?",
        
        "In the past week have you had increased fatigue or lethargy?",
        
        "In the past week have you had a fever?",
        
        "In the past week have you had loss of appetite or weight?",
        
        "In the past week have you had sinus pain or tenderness?",
        
        "In the past week have you felt low in mood?",
        
        "In the past week have you felt worried?"
        
        
    ]
    
    var collectedAnswer : [Int]  = [Int]()


    @IBOutlet weak var currentQuestionBar: UILabel!
    
    @IBOutlet weak var currentQuestion: UILabel!
    
    @IBOutlet weak var NoButton: MKButton!
    
    @IBOutlet weak var yesButton: MKButton!
    
    
    
    var counter : Int = 0 {
        didSet {
            currentQuestion.text = SurveyQuestions[counter]
            currentQuestionBar.text = "Question \(counter + 1) of 12 "
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMKButton(NoButton)
        setupMKButton(yesButton)
        
        currentQuestion.userInteractionEnabled = false
        currentQuestion.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        currentQuestion.numberOfLines = 0
        currentQuestion.text = SurveyQuestions[0]
        self.NoButton.tag = 10
        self.NoButton.addTarget(self, action: "didAnswer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.yesButton.tag = 20
        self.yesButton.addTarget(self, action: "didAnswer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        

        // Do any additional setup after loading the view.
    }
    
    private func setupMKButton(button : MKButton) {
        button.cornerRadius = 40.0
        button.backgroundLayerCornerRadius = 40.0
        button.maskEnabled = false
        button.ripplePercent = 1.75
        button.rippleLocation = .Center
        
    }
    
    func didAnswer(button : MKButton) {
        if (button.tag == 10){
            collectedAnswer.append(0)
        }
        else {
            collectedAnswer.append(1)
            
        }
        
        if(counter > 10){
            
            yesButton.userInteractionEnabled = false
            NoButton.userInteractionEnabled = false
            
            User.postSurvey(collectedAnswer, completeHandler: {(res, error)
                in
                if let _ = error {
                    // something went wrong
                }else {
                    magic("Posting survey successfully")
                     self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
            })
            
            return
            
        }
        else
        {
            counter = counter + 1
            
        }
    }

  

}
