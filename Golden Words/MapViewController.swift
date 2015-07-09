//
//  MapViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Map View outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    var locationManager: CLLocationManager?
    
    // Creating a variable to hold the "IssueLocation" objects from the JSON file
    var issueLocations = [IssueLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger button configuration
    if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Setting the Map type to standard
        mapView.mapType = MKMapType.Standard
        
        // Configuring locationManager and mapView delegate
        locationManager = CLLocationManager()
        mapView.delegate = self
        
        // Set the center of campus as the first location, before we show the actual user location
        let initialLocation = CLLocation(latitude: 44.226397, longitude: -76.495571)
        let regionRadius: CLLocationDistance = 1000
        
        // Centering map on center of campus
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        loadInitialData()
        mapView.addAnnotations(issueLocations)
        
        // Show user location and start updating user location
        mapView.showsUserLocation = true
        locationManager?.startUpdatingLocation()
        
//        // Show a sample issue location on the Map
//        let IssueLocation = IssueLocation(locationName: "Stirling Hall, West Entrance", coordinate: CLLocationCoordinate2D(latitude: 44.22468034747186, longitude: -76.49805217981339))
//        
//        mapView.addAnnotation(IssueLocation)

        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func loadInitialData() {
        
        let fileName = NSBundle.mainBundle().pathForResource("IssueLocations", ofType: "json");
        
        var readError : NSError?
        
        var data: NSData?
        
        do {
            
            data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
            
        } catch _ {
            
            data = nil
            
        }
        
        var error: NSError?
        
        let jsonObject: AnyObject!
        
        if let data = data {
            
            do {
                
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                
            } catch _ {
                
                jsonObject = nil
                
            }
            
            }
        
        if let jsonObject = jsonObject as? [String: AnyObject],
        
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                
                for issueLocationJSON in jsonData {
                    
                    if let issueLocationJSON = issueLocationJSON.array,
                    
                        issueLocation = IssueLocation.fromJSON(issueLocationJSON) {
                            
                            issueLocations.append(issueLocation)
                            
                    }
                    
                }
                
        }
    
    // Checking location authorization status and requesting permission from user if status is not ".AuthorizedWhenInUse"
    func checkLocationAuthorizationStatus() {
            
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
         } else {
            locationManager?.requestWhenInUseAuthorization()
            }
        }
        
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        }
        
     func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
}