//
//  Location.swift
//  FourSquare-App
//
//  Created by Konrad Uciechowski on 03/10/2018.
//  Copyright © 2018 Konrad Uciechowski. All rights reserved.
//

import Foundation

import MapKit

class Location: NSObject, MKAnnotation {
    let name: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
