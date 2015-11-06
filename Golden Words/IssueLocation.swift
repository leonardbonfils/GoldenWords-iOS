//
//  IssueLocation.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-07-08.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import Foundation
import MapKit
import AddressBook
import Contacts

class IssueLocation: NSObject, MKAnnotation {
    
    var locationName: String
    var campusName: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D
    
    init(locationName: String, campusName: String, latitude: Double, longitude: Double, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.campusName = campusName
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = coordinate
        
        super.init()
        
    }
    
    var subtitle: String? {
        if (latitude == 44.22438242146097) {
            return "West Campus"
        } else {
            return "Main Campus"
        }
    }
    
    var title: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        
        let addressDictionary = [String(kABPersonAddressStreetKey): locationName]
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
}
    
//    class func fromJSON(json: [JSONValue]) -> IssueLocation {
//        
//        let locationName = json[12].string // NOTE: replace "12" with the actual index of the locationName in each array of our .JSON file
//        
//        let latitude = (json[18].string! as NSString).doubleValue // NOTE: replace "18" with the actual index of the latitude in each array of our .JSON file
//        let longitude = (json[19].string! as NSString).doubleValue // NOTE: replace "19" with the actual index of the latitude in each array of our .JSON file
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        
//        // Returning an "IssueLocation" object with properties: "locationName" and "coordinate"
//        return IssueLocation(locationName: locationName!, coordinate: coordinate)
//        
//    }
    
//    // Configuring the colour of each annotation pin. We would need to add another property for each object, in the JSON array (here it is called "discpline")
//    func pinColor() -> MKPinAnnotationColor {
//        
//        switch discipline {
//        case "Sculpture", "Plaque":
//            return .Red
//        case "Mural", "Monument":
//            return .Purple
//        default:
//            return .Green
//        }
//    }
