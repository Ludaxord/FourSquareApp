//
//  MapController.swift
//  FourSquare-App
//
//  Created by Konrad Uciechowski on 03/10/2018.
//  Copyright © 2018 Konrad Uciechowski. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    var segueLong: String!
    var segueLat: String!
    var segueName: String!
    var segueCity: String!
    var segueAddress: String!
    var segueCountry: String!
    
    let regionRadius: CLLocationDistance = 1000
    func getMapLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleBar.title = segueName
        let placeMarker = Location(name: segueName!, locationName: "\(segueAddress!) \(segueCity!), \(segueCountry!)", coordinate: CLLocationCoordinate2D(latitude: Double(segueLat)!, longitude: Double(segueLong)!))
        MapView.addAnnotation(placeMarker)
        let location = CLLocation(latitude: Double(segueLat)!, longitude: Double(segueLong)!)
        getMapLocation(location: location)
    }
    
}
