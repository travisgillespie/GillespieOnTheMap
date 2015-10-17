//
//  UdacityClientApi.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/28/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import MapKit

class UdacityClientApi {
    func configureRequest (requestType: String, email: String?, password: String?, id: String?, firstName: String?, lastName: String?, locality: String?, mediaUrl: String?, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) -> NSMutableURLRequest {
        let request: NSMutableURLRequest
        switch requestType {
        case "login":
            request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            return request
        case "userAccountInfo":
            request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(id!)")!)
            return request
        case "getStudentLocations":
            request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "GET"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            return request
        case "postStudentLocation":
            request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"uniqueKey\": \"\(id!)\", \"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(locality!)\", \"mediaURL\": \"\(mediaUrl!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
            return request
        default:
            request = NSMutableURLRequest(URL: NSURL(string: "")!)
            return request
        }
    }
    
    func makeRequestAndParseData(request: NSMutableURLRequest, completionHandler: (( jsonData: AnyObject?) -> Void)?) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("SessionID Failed")
                print("could not complete the request \(error)")
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                completionHandler?(jsonData: parsedResult)
            }
        }
        task.resume()
    }
    
    func makeAnotherRequestAndParseData(request: NSMutableURLRequest, completionHandler: (( jsonData: AnyObject?) -> Void)?) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("SessionID Failed")
                print("could not complete the request \(error)")
            } else {
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                completionHandler?(jsonData: parsedResult)
            }
        }
        task.resume()
    }
    
    func useParsedData(jsonResponse: AnyObject?, key: String, value: String) -> String? {
        var result: String?
        if let jsonObject = jsonResponse as? [String:AnyObject],
            sessionKey = jsonObject["\(key)"] as? [String:AnyObject],
            sessionValue = sessionKey["\(value)"] as? String {
            result = sessionValue
        }
        return result
    }
}