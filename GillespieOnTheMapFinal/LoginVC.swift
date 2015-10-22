//
//  LoginVC.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/21/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelLoginSuggestions: UILabel!
    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var udacityIcon: UIImageView!
    
    
    var verifyUser = LoginVerification()
    
    @IBAction func login(sender: UIButton) {
        let username = loginUsername.text!
        let password = loginPassword.text!
        
        if username.isEmpty && password.isEmpty{
            loginAlert("Empty Fields", alertMessage: "username & password")
            startAnimation()
        } else if username.isEmpty {
            loginAlert("Empty Field", alertMessage: "username")
            startAnimation()
        } else if password.isEmpty {
            loginAlert("Empty Field", alertMessage: "password")
            startAnimation()
        } else {
            verifyUser.verifyingUsersUdacityAccount(username, pass: password) { success in
                dispatch_async(dispatch_get_main_queue()) {
                    if success == "true" {
                        self.resetTextFields()
                        self.performSegueWithIdentifier("tabBarVC", sender: sender)
                    } else {
                        self.resetTextFields()
                        self.loginAlert("failure to login", alertMessage: "\(success)")
                        self.startAnimation()
                    }
                }
            }
        }
    }
    
    @IBAction func createAccountUdacity(sender: UIButton) {
        performSegueWithIdentifier("createAccount", sender: self)
    }
    
    func loginAlert (alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: "\(alertTitle)", message: "\(alertMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func resetTextFields(){
        self.loginUsername.text = ""
        self.loginPassword.text = ""
    }
    
    func animateView(textField: AnyObject){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x - 10, textField.center.y - 10))
        animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x + 10, textField.center.y + 10))
        textField.layer.addAnimation(animation, forKey: "position")
    }
    
    func startAnimation(){
        animateView(labelLoginSuggestions)
        animateView(loginUsername)
        animateView(loginPassword)
        animateView(loginButton)
        animateView(udacityIcon)
    }
}