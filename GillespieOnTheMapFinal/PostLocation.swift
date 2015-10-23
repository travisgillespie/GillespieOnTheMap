//
//  PostLocation.swift
//  GillespieOnTheMapFinal
//
//  Created by Travis Gillespie on 9/26/15.
//  Copyright © 2015 Travis Gillespie. All rights reserved.
//

import UIKit
import MapKit

class PostLocation: UIViewController {
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var userWebsite: UITextField!
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submit: UIButton!
    
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    var clientApi = UdacityClientApi()
    let geoCoder = CLGeocoder()
    var locality : String?
    var longitude : CLLocationDegrees?
    var latitude : CLLocationDegrees?
    
    @IBAction func submit(sender: UIButton) {
        let firstName = LoginVerification.sharedInstance().currentUser.firstName
        let lastName = LoginVerification.sharedInstance().currentUser.lastName
        let studentId = LoginVerification.sharedInstance().currentUser.studentId
        locality = PostLocation.sharedInstance().locality
        longitude = PostLocation.sharedInstance().longitude
        latitude = PostLocation.sharedInstance().latitude
        
        geoCoder.geocodeAddressString(location.text!) { (placemarks, error) -> Void in
            if error != nil && !self.location.text!.isEmpty {
                self.geoAlert("Geocode Error", alertMessage: "\(error!)")
            } else if self.location.text == "" {
                self.geoAlert("Geocode Error", alertMessage: "Location can't be blank")
            } else if self.locality != nil {
                let request = self.clientApi.configureRequest("postStudentLocation",  email: nil, password: nil, id: "\(studentId)", firstName: "\(firstName)", lastName: "\(lastName)", locality: "\(self.locality!)", mediaUrl: "\(self.userWebsite.text!)", latitude: self.latitude!, longitude: self.longitude!)
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if error != nil {
                        let getError = error!.localizedDescription
                        dispatch_async(dispatch_get_main_queue()) {
                            self.geoAlert("Geocode Error", alertMessage: "\(getError)")
                        }

                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                task.resume()
            }
        }
    }
    
    @IBAction func viewUrl(sender: UIButton) {
//        print("buttonPressed \(userWebsite.text!)")
        if self.verifyUrl(userWebsite.text!) {
            UIApplication.sharedApplication().openURL(NSURL(string: "\(userWebsite.text!)")!)
        } else {
            userWebsite.text! = ""
            geoAlert("URL Error", alertMessage: "url denied be sure to follow the format \ne.g. http://www.udacity.com")
        }
        
        print("buttonPressed \(userWebsite.text!)")
        UIApplication.sharedApplication().openURL(NSURL(string: "\(userWebsite.text!)")!)
    }
    
    var indicator: String?
    
    override func viewWillAppear(animated: Bool) {
        textFieldOutlets()
        switchIND("hide")
        location!.addTarget(self, action: "locateUser:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        textFieldOutlets()
    }
    
    func textFieldOutlets(){
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact) {
        // Compact
            location.placeholder = "Where are you studying today?"
            userWebsite.placeholder = "(optional) http://www.udacity.com"
        } else {
        // Regular
            location.placeholder = "Place location here"
            userWebsite.placeholder = "http://www.udacity.com"
        }
    }
        
    func locateUser(textField: UITextField) {
        switchIND("unhide")
        geocode()
        if location.text == ""{
            textFieldOutlets()
            switchIND("hide")
        }
    }
    
    func switchIND (indicator: String) {
        switch indicator {
        case "hide":
            activityInd.hidden = true
            activityInd.stopAnimating()
            break
        case "unhide":
            activityInd.hidden = false
            activityInd.startAnimating()
            break
        default:
            break
        }
    }
    
    func geocode() {
        geoCoder.geocodeAddressString(location.text!) { (placemarks, error) -> Void in
            if let userLocation = placemarks?[0] {
                self.mapView.removeAnnotations(self.mapView.annotations)
                let placemark = MKPlacemark(placemark: userLocation)
                if placemark.locality != nil{
                    PostLocation.sharedInstance().locality = placemark.locality
                    PostLocation.sharedInstance().longitude = placemark.location?.coordinate.longitude
                    PostLocation.sharedInstance().latitude = placemark.location?.coordinate.latitude
                    
                    self.mapView.addAnnotation(placemark)
                    self.centerMapOnLocation(placemark.location!)
                    self.switchIND("hide")
                }
            } else {
//                self.geoAlert("Geocode Error", alertMessage: "\(error!)")
            }
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func geoAlert(alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: "\(alertTitle)", message: "\(alertMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    class func sharedInstance() -> PostLocation {
        struct Singleton {
            static var sharedInstance = PostLocation()
        }
        return Singleton.sharedInstance
    }
}
