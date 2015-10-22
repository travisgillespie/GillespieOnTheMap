//
//  MapVC.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/26/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    var url : [String] = []
    var i = 0
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }

    var studentLocations = UdacityClientApi()
    
    override func viewWillAppear(animated: Bool) {
        appendStudentDataToPins()
    }
    @IBAction func logout(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pinLocation(sender: UIBarButtonItem) {
        performSegueWithIdentifier("mapPostLocation", sender: self)
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        appendStudentDataToPins()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView { // 2
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.enabled = true
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            let link = view.annotation?.subtitle
            if link!! != "" { view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) }

            view.pinTintColor = UIColor.purpleColor()
        }
        return view
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let link = view.annotation?.subtitle
        UIApplication.sharedApplication().openURL(NSURL(string: "\(link!!)")!)
    }
    
    func appendStudentDataToPins(){
        mapView.removeAnnotations(mapView.annotations)

        self.studentLocations.gatherStudentLocations() { success in
            if success == "true" {
                let loadStudentsOnMap = MKPointAnnotation()

                let firstName = UdacityClientApi.sharedInstance().studentDict["firstName"]!
                let lastName = UdacityClientApi.sharedInstance().studentDict["lastName"]!
                let mediaURL = UdacityClientApi.sharedInstance().studentDict["mediaURL"]! as! String
                let latitude = UdacityClientApi.sharedInstance().studentDict["latitude"]! as! Double
                let longitude = UdacityClientApi.sharedInstance().studentDict["longitude"]! as! Double
                
                loadStudentsOnMap.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                loadStudentsOnMap.title = "\(firstName) \(lastName)"
                if self.verifyUrl(mediaURL) {
                    loadStudentsOnMap.subtitle = "\(mediaURL)"
                } else {
                    loadStudentsOnMap.subtitle = ""
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotation(loadStudentsOnMap)
                }
            } else {
                self.loginAlert("map failure", alertMessage: "\(success)")
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
    
    func loginAlert (alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: "\(alertTitle)", message: "\(alertMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}