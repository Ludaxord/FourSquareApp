//
//  ViewController.swift
//  FourSquare-App
//
//  Created by Konrad Uciechowski on 02/10/2018.
//  Copyright © 2018 Konrad Uciechowski. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var namesArr = [String]()
    var cityArr = [String]()
    var distanceArr = [String]()
    var stateArr = [String]()
    var postalCodeArr = [String]()
    var countryArr = [String]()
    var addressArr = [String]()
    var latArr = [String]()
    var longArr = [String]()
    
    var segueLong: String!
    var segueLat: String!
    var segueName: String!
    var segueCity: String!
    var segueAddress: String!
    var segueCountry: String!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell") as! ResultsTableViewCell?
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.namesArr.isEmpty {
                self.ResultTableView.isHidden = true
                self.NoResultsLabel.isHidden = false
            } else {
                self.ResultTableView.isHidden = false
                self.NoResultsLabel.isHidden = true
                let name = self.namesArr[indexPath.row]
                let address = self.addressArr[indexPath.row]
                let state = self.stateArr[indexPath.row]
                let postalCode = self.postalCodeArr[indexPath.row]
                let distance = self.distanceArr[indexPath.row]
                let country = self.countryArr[indexPath.row]
                let city = self.cityArr[indexPath.row]
                if name != "null" {
                    (cell as! ResultsTableViewCell).NameLabel.isHidden = false
                    (cell as! ResultsTableViewCell).NameLabel.text = name
                } else {
                    (cell as! ResultsTableViewCell).NameLabel.isHidden = true
                }
                
                if address != "null" {
                    (cell as! ResultsTableViewCell).AddressLabel.isHidden = false
                    (cell as! ResultsTableViewCell).AddressLabel.text = address
                } else {
                    (cell as! ResultsTableViewCell).AddressLabel.isHidden = true
                }
                
                if city != "null" {
                    (cell as! ResultsTableViewCell).CityLabel.isHidden = false
                    (cell as! ResultsTableViewCell).CityLabel.text = city
                } else {
                    (cell as! ResultsTableViewCell).CityLabel.isHidden = true
                }
                
                if country != "null" {
                    (cell as! ResultsTableViewCell).CityLabel.isHidden = false
                    if city != "null" {
                        (cell as! ResultsTableViewCell).CityLabel.text = "\((cell as! ResultsTableViewCell).CityLabel.text!), \(country)"
                    } else {
                        (cell as! ResultsTableViewCell).CityLabel.text = country
                    }
                }
                
                if distance != "null" {
                    (cell as! ResultsTableViewCell).DistanceLabel.isHidden = false
                    (cell as! ResultsTableViewCell).DistanceLabel.text = "Distance: \(distance)m"
                } else {
                    (cell as! ResultsTableViewCell).DistanceLabel.isHidden = true
                }
                
                (cell as! ResultsTableViewCell).AddressLabel.sizeToFit()
                (cell as! ResultsTableViewCell).CityLabel.sizeToFit()
                (cell as! ResultsTableViewCell).NameLabel.sizeToFit()
                (cell as! ResultsTableViewCell).DistanceLabel.sizeToFit()
            }
        }
        return cell!
    }
    
    @IBOutlet weak var LocationName: UINavigationItem!
    @IBOutlet weak var SearchLocationField: UITextField!
    @IBOutlet weak var ResultTableView: UITableView!
    @IBOutlet weak var NoResultsLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    let settings = UserSettings()
    
    let venues = Venues()
    
    public var downloadedInitialLocations = false
    
    override func loadView() {
        super.loadView()
        settings.setPreferences(key: "clientId", value: "<YOUR_CLIENT_ID>")
        settings.setPreferences(key: "clientSecret", value: "<YOUR_CLIENT_SECRET>")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchLocationField.addTarget(self, action: #selector(ChangedTextListener(_:)), for: .editingChanged)
        ResultTableView.delegate = self
        ResultTableView.dataSource = self
        ResultTableView?.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func ChangedTextListener(_ textField: UITextField) {
        LocationName.title = "Near: \(textField.text!)"
        venues.asyncVenueListProvidedByUser(near: textField.text!) { resp, err in
            self.namesArr = [String]()
            self.cityArr = [String]()
            self.stateArr = [String]()
            self.addressArr = [String]()
            self.postalCodeArr = [String]()
            self.countryArr = [String]()
            self.distanceArr = [String]()
            self.latArr = [String]()
            self.longArr = [String]()
            if resp != nil {
                var meta = resp!["meta"]
                let code = meta["code"].rawString()!
                let errorDetail = meta["errorDetail"].rawString()!
                if code == "200" {
                        var jsonObj = resp!["response"]
                        let venues = jsonObj["venues"].array
                        if venues != nil {
                            for venue in venues! {
                                let categories = venue["categories"].array
                                let name = venue["name"].rawString()!
                                let location = venue["location"]
                                let city = location["city"].rawString()!
                                let state = location["state"].rawString()!
                                let address = location["address"].rawString()!
                                let postalCode = location["postalCode"].rawString()!
                                let country = location["country"].rawString()!
                                let distance = location["distance"].rawString()!
                                let lat = location["lat"].rawString()!
                                let long = location["lng"].rawString()!
                                self.namesArr.append(name)
                                self.cityArr.append(city)
                                self.stateArr.append(state)
                                self.addressArr.append(address)
                                self.postalCodeArr.append(postalCode)
                                self.countryArr.append(country)
                                self.distanceArr.append(distance)
                                self.latArr.append(lat)
                                self.longArr.append(long)
                                for category in categories! {
                                    let categoryName = category["name"].rawString()!
                                    let icon = category["icon"]
                                    let prefix = icon["prefix"].rawString()!
                                    let suffix = icon["suffix"].rawString()!
                                    let iconURL = "\(prefix)\(suffix)"
                                }
                            }
                    }
                } else {
                    self.NoResultsLabel.text = errorDetail
                }
                self.ResultTableView.reloadData()
            }
            
            if err != nil {
                self.NoResultsLabel.text = "error fetching data"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell") as! ResultsTableViewCell?
        segueLat = latArr[indexPath.row]
        segueLong = longArr[indexPath.row]
        if cityArr[indexPath.row] != "null" {
            segueCity = cityArr[indexPath.row]
        } else {
            let location = CLLocation(latitude: Double(segueLat)!, longitude: Double(segueLong)!)
            fetchCityAndCountry(from: location) { city, country, error in
                guard let city = city, let _ = country, error == nil else { return }
                self.segueCity = city
            }
        }
        if addressArr[indexPath.row] != "null" {
            segueAddress = addressArr[indexPath.row]
        } else {
            segueAddress = ""
        }
        if countryArr[indexPath.row] != "null" {
            segueCountry = countryArr[indexPath.row]
        } else {
            let location = CLLocation(latitude: Double(segueLat)!, longitude: Double(segueLong)!)
            fetchCityAndCountry(from: location) { city, country, error in
                guard let city = city, let _ = country, error == nil else { return }
                self.segueCountry = city
            }
        }
        segueName = namesArr[indexPath.row]
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "ShowMap", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMap" {
            let vc = segue.destination as! MapController
            vc.segueCountry = segueCountry
            vc.segueAddress = segueAddress
            vc.segueName = segueName
            vc.segueLong = segueLong
            vc.segueLat = segueLat
            vc.segueCity = segueCity
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentLocation()
    }
    
    func currentLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[0] as CLLocation

            let lat = String(location.coordinate.latitude)
            let long = String(location.coordinate.longitude)
        
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let _ = country, error == nil else { return }
            self.LocationName.title = "Near: \(city)"
        }
        
        if self.downloadedInitialLocations == false {
            self.downloadedInitialLocations = true
            venues.asyncVenueListByUserLocation(lat: lat, long: long) { resp, err in
                self.namesArr = [String]()
                self.cityArr = [String]()
                self.stateArr = [String]()
                self.addressArr = [String]()
                self.postalCodeArr = [String]()
                self.countryArr = [String]()
                self.distanceArr = [String]()
                self.latArr = [String]()
                self.longArr = [String]()
                if resp != nil {
                    var meta = resp!["meta"]
                    let code = meta["code"].rawString()!
                    let errorDetail = meta["errorDetail"].rawString()!
                    if code == "200" {
                        var jsonObj = resp!["response"]
                        let venues = jsonObj["venues"].array
                        if venues != nil {
                            for venue in venues! {
                                let categories = venue["categories"].array
                                let name = venue["name"].rawString()!
                                let location = venue["location"]
                                let city = location["city"].rawString()!
                                let state = location["state"].rawString()!
                                let address = location["address"].rawString()!
                                let postalCode = location["postalCode"].rawString()!
                                let country = location["country"].rawString()!
                                let distance = location["distance"].rawString()!
                                let lat = location["lat"].rawString()!
                                let long = location["lng"].rawString()!
                                self.namesArr.append(name)
                                self.cityArr.append(city)
                                self.stateArr.append(state)
                                self.addressArr.append(address)
                                self.postalCodeArr.append(postalCode)
                                self.countryArr.append(country)
                                self.distanceArr.append(distance)
                                self.latArr.append(lat)
                                self.longArr.append(long)
                                for category in categories! {
                                    let categoryName = category["name"].rawString()!
                                    let icon = category["icon"]
                                    let prefix = icon["prefix"].rawString()!
                                    let suffix = icon["suffix"].rawString()!
                                    let iconURL = "\(prefix)\(suffix)"
                                    
                                }
                            }
                        }
                    } else {
                        self.NoResultsLabel.text = errorDetail
                    }
                    
                    self.ResultTableView.reloadData()
                }
                
                if err != nil {
                    self.NoResultsLabel.text = "error fetching data"
                }
            }

        }
        
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) {
            placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    var heightAtIndexPath = NSMutableDictionary()
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }
    
    @IBAction func unwindToPlacesList(segue: UIStoryboardSegue) {
        
    }

}

