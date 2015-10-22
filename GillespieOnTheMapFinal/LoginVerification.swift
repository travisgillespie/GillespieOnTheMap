//
//  LoginVerification.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/23/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class LoginVerification {

    var currentUser = UdacityUser(studentId: "", firstName: "", lastName: "")
    
    var clientApi = UdacityClientApi()
    
    func verifyingUsersUdacityAccount (user: String?, pass: String?, completion: ((success: String) -> Void)?) {
        let request = clientApi.configureRequest("login", email: user!, password: pass!, id: nil, firstName: nil, lastName: nil, locality: nil, mediaUrl: nil, latitude: nil, longitude: nil)
        
        clientApi.makeRequestAndParseData(request)
        { jsonData in
            if let studentId = self.clientApi.useParsedData(jsonData, key: "account", value: "key") {
                LoginVerification.sharedInstance().currentUser.studentId = studentId
                let request = self.clientApi.configureRequest("userAccountInfo", email: nil, password: nil, id: studentId, firstName: nil, lastName: nil, locality: nil, mediaUrl: nil, latitude: nil, longitude: nil)
                self.clientApi.makeRequestAndParseData(request)
                { jsonData in
                    self.currentUser.lastName = self.clientApi.useParsedData(jsonData, key: "user", value: "last_name")!
                    LoginVerification.sharedInstance().currentUser.firstName = self.clientApi.useParsedData(jsonData, key: "user", value: "first_name")!
                    LoginVerification.sharedInstance().currentUser.lastName = self.clientApi.useParsedData(jsonData, key: "user", value: "last_name")!
                   completion?(success: "true")
                }
            } else if jsonData!["error"] != nil {
                let getError = jsonData!["error"]
                completion?(success: "\(getError!!)")
            } else {
                completion?(success: "\(jsonData!)")
            }
        }
    }
    
    class func sharedInstance() -> LoginVerification {
        
        struct Singleton {
            static var sharedInstance = LoginVerification()
        }
        return Singleton.sharedInstance
    }
}