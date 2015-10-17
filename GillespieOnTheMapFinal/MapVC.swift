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
    
    var studentLocations = StudentLocations()
    
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
            if success {
                let loadStudentsOnMap = MKPointAnnotation()
                loadStudentsOnMap.coordinate = CLLocationCoordinate2D(latitude: self.studentLocations.latitude!, longitude: self.studentLocations.longitude!)
                loadStudentsOnMap.title = "\(self.studentLocations.firstName!) \(self.studentLocations.lastName!)"
                if self.verifyUrl(self.studentLocations.mediaURL) {
                    loadStudentsOnMap.subtitle = "\(self.studentLocations.mediaURL!)"
                } else {
                    loadStudentsOnMap.subtitle = ""
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotation(loadStudentsOnMap)
                }
            } else {
                print("map FAILURE")
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