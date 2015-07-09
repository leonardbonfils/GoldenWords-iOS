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
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
        
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        
        if #available(iOS 9.0, *) { // iOS 9.0 and above (Contacts framework)
            let addressDictionary = [String(CNPostalAddressStreetKey): subtitle]
        } else {
            // iOS 8.0 and below (AddressBook framework)
            let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        }
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary) // NOTE: Xcode does not find addressDictionary because of the availability checking statement. How to fix ?
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
    class func fromJSON(json: [JSONValue]) -> IssueLocation {
        
        let locationName = json[12].string // NOTE: replace "12" with the actual index of the locationName in each array of our .JSON file
        
        let latitude = (json[18].string! as NSString).doubleValue // NOTE: replace "18" with the actual index of the latitude in each array of our .JSON file
        let longitude = (json[19].string! as NSString).doubleValue // NOTE: replace "19" with the actual index of the latitude in each array of our .JSON file
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Returning an "IssueLocation" object with properties: "locationName" and "coordinate"
        return IssueLocation(locationName: locationName!, coordinate: coordinate)
        
    }
    
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
    
        
}
