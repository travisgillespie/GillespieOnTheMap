//
//  UdacityUser.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/23/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    var studentId: String
    var firstName: String
    var lastName: String
    
    init (studentId: String, firstName: String, lastName: String){
        self.studentId = studentId
        self.firstName = firstName
        self.lastName = lastName
    }
}