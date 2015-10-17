//
//  CreateAccountUdacity.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/23/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import UIKit

class CreateAccountUdacity: UIViewController {

    @IBOutlet weak var webviewUdacity: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://www.udacity.com/account/auth#!/signup"
        self.webviewUdacity.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
    }

    @IBAction func backButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}