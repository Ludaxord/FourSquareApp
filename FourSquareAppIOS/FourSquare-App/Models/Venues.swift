//
//  Venues.swift
//  FourSquare-App
//
//  Created by Konrad Uciechowski on 02/10/2018.
//  Copyright © 2018 Konrad Uciechowski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Venues {
    
    func asyncVenueListByUserLocation(lat: String, long: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        venueListByUserLocation(lat: lat, long: long, completionHandler: completionHandler)
    }
    
    func venueListByUserLocation(lat: String, long: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let clientID = UserSettings().getPreferences(key: "clientId")
        let clientSecret = UserSettings().getPreferences(key: "clientSecret")
        
        if clientID != nil || clientSecret != nil {
            let url = "https://api.foursquare.com/v2/venues/search?client_id=\(clientID!)&client_secret=\(clientSecret!)&v=20180323&ll=\(lat),\(long)"
            Alamofire.request(url)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        completionHandler(json, nil)
                    case .failure(let error):
                        completionHandler(nil, error)
                    }
            }
        }
    }
    
    func asyncVenueListProvidedByUser(near: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        venueListProvidedByUser(near: near, completionHandler: completionHandler)
    }
    
    func venueListProvidedByUser(near: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let clientID = UserSettings().getPreferences(key: "clientId")
        let clientSecret = UserSettings().getPreferences(key: "clientSecret")
        
        if clientID != nil || clientSecret != nil {
            Alamofire.request("https://api.foursquare.com/v2/venues/search?client_id=\(clientID!)&client_secret=\(clientSecret!)&v=20180323&near=\(near)")
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        completionHandler(json, nil)
                    case .failure(let error):
                        completionHandler(nil, error)
                    }
            }
        }
    }
}
