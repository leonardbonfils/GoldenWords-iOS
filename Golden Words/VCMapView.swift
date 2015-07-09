//
//  VCMapView.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-07-08.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? IssueLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation // NOTE: 2 options here for the "annotation" at the end of this line. I choose the first one but am in doubt.
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier) // NOTE: another unsure choice for the "annotation" right before the comma
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as! UIView
            }
            
//            // Applying the "pinColor" method declared in IssueLocation.swift
//            view.pinColor = annotation.pinColor()

            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let location = view.annotation as! IssueLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
}