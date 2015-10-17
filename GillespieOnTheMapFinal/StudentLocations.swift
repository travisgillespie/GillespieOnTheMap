//
//  StudentLocations.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/28/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import Foundation

class StudentLocations {
    var clientApi = UdacityClientApi()
    var createdAt:String!
    var firstName:String!
    var lastName:String!
    var latitude:Double!
    var longitude:Double!
    var mapString:String!
    var mediaURL:String!
    var objectId:String!
    var uniqueKey:String!
    var updatedAt:String!
    
    func gatherStudentLocations(completion: ((success: Bool) -> Void)?) {
        
        let request = clientApi.configureRequest("getStudentLocations", email: nil, password: nil, id: nil, firstName: nil, lastName: nil, locality: nil, mediaUrl: nil, latitude: nil, longitude: nil)
        
        self.clientApi.makeAnotherRequestAndParseData(request)
        { jsonData in
            if let results = jsonData!["results"] as? [[String:AnyObject]]{
                for students in results{
                    let udacityStudent = UdacityStudents(dictionary: students)
                    self.createdAt = udacityStudent.createdAt!
                    self.firstName = udacityStudent.firstName!
                    self.lastName = udacityStudent.lastName!
                    self.latitude = udacityStudent.latitude!
                    self.longitude = udacityStudent.longitude!
                    self.mapString = udacityStudent.mapString!
                    self.mediaURL = udacityStudent.mediaURL!
                    self.objectId = udacityStudent.objectId!
                    self.uniqueKey = udacityStudent.uniqueKey!
                    self.updatedAt = udacityStudent.updatedAt!
                    completion?(success: true)
                }
            } else {
                print ("error gathering students from database")
                completion?(success: false)
            }
        }
    }
}