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
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    // Map View outlet declaration
    @IBOutlet weak var mapView: MKMapView!
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    var locationManager: CLLocationManager?
    
    /* Really ugly code where I declare all of my static data */
    let coordinatesARC = IssueLocation(locationName: "ARC", coordinate: CLLocationCoordinate2D(latitude: 44.22928743712073, longitude: -76.49416565895079))
    let coordinatesJDUC = IssueLocation(locationName: "JDUC", coordinate: CLLocationCoordinate2D(latitude: 44.22838027067406  , longitude: -76.49507761001587))
    let coordinatesStaufferLibrary = IssueLocation(locationName: "Stauffer Library", coordinate: CLLocationCoordinate2D(latitude: 44.228418710213944, longitude: -76.49615049362183))
    let coordinatesWalterLightHall = IssueLocation(locationName: "Walter Light Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22794205814507, longitude: -76.49166584014893))
    let coordinatesDupuisHall = IssueLocation(locationName: "Dupuis Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22867241054762, longitude: -76.4927065372467))
    let coordinatesHumphreyHall = IssueLocation(locationName: "Humphrey Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22688879714365, longitude:  -76.49212718009949))
    let coordinatesBiosciencesComplex = IssueLocation(locationName: "Biosciences Complex", coordinate: CLLocationCoordinate2D(latitude: 44.226327562781904, longitude: -76.49117231369019))
    let coordinatesBMH = IssueLocation(locationName: "Beamish-Munro Hall", coordinate: CLLocationCoordinate2D(latitude: 44.228195760533175, longitude: -76.49271726608276 ))
    let coordinatesBotterellHall = IssueLocation(locationName: "Botterell Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22447468258034, longitude: -76.49160146713257))
    let coordinatesEtheringtonHall = IssueLocation(locationName: "Etherington Hall", coordinate: CLLocationCoordinate2D(latitude: 44.224282471751785, longitude: -76.49390816688538))
    let coordinatesJefferyHall = IssueLocation(locationName: "Jeffery Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22590855555731, longitude: -76.49605393409729))
    let coordinatesEllisHall = IssueLocation(locationName: "Ellis Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22636984774898, longitude: -76.49602174758911))
    let coordinatesMackintoshCorryHall = IssueLocation(locationName: "Mackintosh-Corry Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22677731951135, longitude: -76.49697124958038))
    let coordinatesChernoffHall = IssueLocation(locationName: "Chernoff Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22436704459368, longitude: -76.49884343147278))
    let coordinatesLeggetHall = IssueLocation(locationName: "Legget Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22362126170883, longitude: -76.49749159812927))
    let coordinatesLeonardHall = IssueLocation(locationName: "Leonard Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22429016019697, longitude: -76.50065660476685))
    let coordinatesVictoriaHall = IssueLocation(locationName: "Victoria Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22550492192426, longitude: -76.49863958358765))
    let coordinatesStirlingHall = IssueLocation(locationName: "Stirling Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22463613919133, longitude: -76.49767398834229))
    let coordinatesWestCampus = IssueLocation(locationName: "Jean Royce Hall", coordinate: CLLocationCoordinate2D(latitude: 44.22438242146097, longitude: -76.51471138000487))
    
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
        let initialLocation = CLLocationCoordinate2D(latitude: 44.226181, longitude: -76.495614)
//        let regionRadius: CLLocationDistance = 10
        let latitudeDelta:CLLocationDegrees = 0.015
        let longitudeDelta:CLLocationDegrees = 0.015
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        let coordinateRegion = MKCoordinateRegionMake(initialLocation, span)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
//        let ARCAnnotation = MKPointAnnotation()
//        ARCAnnotation.title = "ARC"
//        ARCAnnotation.subtitle = "ARC Subtitle"
//        ARCAnnotation.coordinate = coordinatesARC.coordinate
        
//        mapView.addAnnotation(ARCAnnotation)
        
        // Adding all annotations to the map view
        mapView.addAnnotation(coordinatesARC)
        mapView.addAnnotation(coordinatesJDUC)
        mapView.addAnnotation(coordinatesStaufferLibrary)
        mapView.addAnnotation(coordinatesWalterLightHall)
        mapView.addAnnotation(coordinatesDupuisHall)
        mapView.addAnnotation(coordinatesHumphreyHall)
        mapView.addAnnotation(coordinatesBiosciencesComplex)
        mapView.addAnnotation(coordinatesBMH)
        mapView.addAnnotation(coordinatesBotterellHall)
        mapView.addAnnotation(coordinatesEtheringtonHall)
        mapView.addAnnotation(coordinatesJefferyHall)
        mapView.addAnnotation(coordinatesEllisHall)
        mapView.addAnnotation(coordinatesMackintoshCorryHall)
        mapView.addAnnotation(coordinatesChernoffHall)
        mapView.addAnnotation(coordinatesLeggetHall)
        mapView.addAnnotation(coordinatesLeonardHall)
        mapView.addAnnotation(coordinatesVictoriaHall)
        mapView.addAnnotation(coordinatesStirlingHall)
        mapView.addAnnotation(coordinatesWestCampus)
        
        // loadInitialData()
//        mapView.addAnnotations(issueLocations)
        
        // Show user location and start updating user location
        mapView.showsUserLocation = true
        locationManager?.startUpdatingLocation()
        
//        // Show a sample issue location on the Map
//        let IssueLocation = IssueLocation(locationName: "Stirling Hall, West Entrance", coordinate: CLLocationCoordinate2D(latitude: 44.22468034747186, longitude: -76.49805217981339))
//        
//        mapView.addAnnotation(IssueLocation)

        // Do any additional setup after loading the view.
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
