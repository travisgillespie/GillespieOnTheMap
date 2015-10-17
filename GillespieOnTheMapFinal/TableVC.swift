//
//  TableVC.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/26/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var studentLocations = StudentLocations()
    var fullName : [String] = []
    var url : [String] = []
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("udacStudentTableCell", forIndexPath: indexPath)
        appendStudentDataToCells(cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: "\(url[indexPath.row])")!)
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pinLocation(sender: UIBarButtonItem) {
        performSegueWithIdentifier("tablePostLocation", sender: self)
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    func appendStudentDataToCells(cell:UITableViewCell, indexPath:NSIndexPath ){
        self.studentLocations.gatherStudentLocations() { success in
            if success {
                self.fullName.append("\(self.studentLocations.firstName!) \(self.studentLocations.lastName!)")
                if self.verifyUrl(self.studentLocations.mediaURL) {
                    self.url.append("\(self.studentLocations.mediaURL)")
                } else {
                    self.url.append("")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    cell.textLabel?.text = "\(indexPath.row+1) \(self.fullName[indexPath.row])"
                    cell.detailTextLabel?.text = "\(self.url[indexPath.row])"
                }
            } else {
                print("table FAILURE")
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
}