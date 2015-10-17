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
    
    var verifyUser = LoginVerification()
    
    @IBAction func login(sender: UIButton) {
        let username = loginUsername.text!
        let password = loginPassword.text!
        
        if username.isEmpty && password.isEmpty{
            loginAlert("Empty Fields", alertMessage: "username & password")
        } else if username.isEmpty {
            loginAlert("Empty Field", alertMessage: "username")
        } else if password.isEmpty {
            loginAlert("Empty Field", alertMessage: "password")
        } else {
            verifyUser.verifyingUsersUdacityAccount(username, pass: password) { success in
                dispatch_async(dispatch_get_main_queue()) {
                    if success == "true" {
                        self.resetTextFields()
                        self.performSegueWithIdentifier("tabBarVC", sender: sender)
                    } else {
                        self.resetTextFields()
                        self.loginAlert("failure to login", alertMessage: "\(success)")
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
}