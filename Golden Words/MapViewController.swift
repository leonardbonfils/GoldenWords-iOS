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
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
        
    // Map View outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!

    var populatingMapObjects = false
    
    var loadingIndicator = UIActivityIndicatorView()

    var mapObjects = [IssueLocation]()
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger button configuration
    if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Setting the Map type to standard
        mapView.mapType = MKMapType.Standard
        
        // Configuring locationManager and mapView delegate
        locationManager = CLLocationManager()
        mapView.delegate = self
        
        // Set the center of campus as the first location, before we show the actual user location
        let initialLocation = CLLocationCoordinate2D(latitude: 44.226181, longitude: -76.495614)
//        let regionRadius: CLLocationDistance = 10
        let latitudeDelta:CLLocationDegrees = 0.015
        let longitudeDelta:CLLocationDegrees = 0.015
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        let coordinateRegion = MKCoordinateRegionMake(initialLocation, span)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        self.loadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.loadingIndicator.color = UIColor.goldenWordsYellow()
        let indicatorCenter = self.view.center
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(loadingIndicator)
        
        populateMapObjects()

        // Show user location and start updating user location
        mapView.showsUserLocation = true
        locationManager?.startUpdatingLocation()
    }

    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        mapView.centerCoordinate = userLocation.location!.coordinate
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 44.226181, longitude: -76.495614)
    }
    
    /*
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
        var jsonObject: AnyObject! = nil
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
                    let issueLocation = IssueLocation.fromJSON(issueLocationJSON.array!)
                            issueLocations.append(issueLocation)
                            
                    
                    
                }
                
        }
    }
    */
    
    // Checking location authorization status and requesting permission from user if status is not ".AuthorizedWhenInUse"
    func checkLocationAuthorizationStatus() {
            
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
         } else {
            locationManager?.requestWhenInUseAuthorization()
            }
        }
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateMapObjects() {
    
        if populatingMapObjects {
            return
        }
        
        populatingMapObjects = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.loadingIndicator.startAnimating()
        
        var index = 0

        
        Alamofire.request(GWNetworking.Router.MapObjects).responseJSON() { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
//                    print (JSON[0]["name"])
                    
                    /* Making an array of all the node IDs from the JSON file */
                    
                    if (JSON .isKindOfClass(NSArray)) {
                    
                    
                        for _ in JSON as! [Dictionary<String,AnyObject>] {

                            if let issueLocation: IssueLocation = IssueLocation(locationName: "Center of the universe", campusName: "Queen's University", latitude: 44.22661586877309, longitude: -76.49380087852478, coordinate: CLLocationCoordinate2D(latitude: 44.22661586877309, longitude: -76.49380087852478)) {
                                
                                
                                if let locationName = JSON[index]["name"] as? String {
                                    issueLocation.locationName = locationName
                                }

                                if let latitude = JSON[index]["coordinates"]!![1] as? Double {
                                    issueLocation.latitude = latitude
                                }
                                
                                if let longitude = JSON[index]["coordinates"]!![0] as? Double {
                                    issueLocation.longitude = longitude
                                }
                                
                                issueLocation.coordinate = CLLocationCoordinate2D(latitude: issueLocation.latitude, longitude: issueLocation.longitude)
                                
                                index = index+1
                                
                                self.mapObjects.append(issueLocation)
                        }
                    }
                }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.loadingIndicator.stopAnimating()
                        self.populatingMapObjects = false
                        print(self.mapObjects.count)
                        
                        for mapObject in self.mapObjects {
                            
                            let temporaryMapAnnotation = IssueLocation(locationName: mapObject.locationName, campusName: "Main Campus", latitude: mapObject.latitude, longitude: mapObject.longitude, coordinate: mapObject.coordinate)
                            
                            if (temporaryMapAnnotation.longitude < -76.50921821594238) {
                                temporaryMapAnnotation.campusName = "West Campus"
                            }
                            
                            self.mapView.addAnnotation(temporaryMapAnnotation)
                        }
                }
            }
        }
    }
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