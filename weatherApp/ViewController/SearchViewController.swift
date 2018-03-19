//
//  SearchViewController.swift
//  weatherGeo
//
//  Created by Ahassouni, Nadia on 08/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK : MAP
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000000
    
    // MARK : Strorybord components
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var city: UITextField!
    
    // MARK: API
    let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
    let apiKey = "440641e20987cefb9bd803e6e48a9444"
    
    // MARK : Service
    var serviceWeather = WeatherService()
    
    // MARK: Model
    var weatherInfo: Weather?
    
    // MARK : Localisation
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ( "Cities in Database : ", "\(DBManager.sharedInstance.getCitiesFromDb())".description)
        // Initialize the map
        let initialLocation = CLLocation(latitude: 34.686667, longitude: -1.911389)
        centerMapOnLocation(location: initialLocation)
        
        UserDefaults.init(suiteName: "group.weatherApp")?.setValue("Coucouc Nadia", forKey: "test1")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsView"{
            let detailsController = segue.destination as! DetailsViewController
            detailsController.cityReceived = self.city.text!
            detailsController.weatherInfo = self.weatherInfo
        }else if segue.identifier == "favoriteCities"{
            let controllerDet = segue.destination as! CitiesTableViewController
            controllerDet.x = self.city.text!
        }else if segue.identifier == "displayMap"{
            _ = segue.destination as! MapViewController
        }
    }
    
    @IBAction func displayMapTaped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "displayMap", sender: self)
    }
    
    
    @IBAction func searchButtonTaped(_ sender: UIButton) {
        // API weather contantes
        
        guard let text = city.text, !text.isEmpty else{
            return
        }
        
        guard let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&q=\(text)") else{
            return
        }
        
        WeatherService.getWeather(url: weatherRequestURL) { (weather, error) in
            self.weatherInfo = weather
            guard self.weatherInfo != nil else{
                print(error ?? "No Error" )
                return
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "detailsView", sender: self)
                
                print(weather ?? "no Data")
            }
        }
    }
    
    @IBAction func detailsButtonTaped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "detailsTable", sender: self)
    }
    
    @IBAction func geoLocalisationButtonTaped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    @IBAction func getFavoriteCitiesButtonTaped(_ sender: Any) {
        self.performSegue(withIdentifier: "favoriteCities", sender: self)
    }
    
    
    // Centre the map & make favorites cities on it
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // show favorite cities on the map
        let listCities = DBManager.sharedInstance.getCitiesFromDb()
        for i in listCities{
            let latitude = i.weather?.coord?.lat
            let longitude = i.weather?.coord?.lon
            let name = i.weather?.cityName
            let cityMap = CityMap(title: name!,
                                  coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            
            mapView.addAnnotation(cityMap)
            mapView.selectAnnotation(cityMap, animated: true)
        }
        print ( "All favorite cities : " , listCities.description)
    }
    //
    //    // Fetch for the favorite cities in database and make it on the map
    //    func makeFavoriteCitiesOnTheMap(){
    //        let listCities = DBManager.sharedInstance.getCitiesFromDb()
    //        for i in listCities{
    //            let latitude = i.weather?.coord?.lat
    //            let longitude = i.weather?.coord?.lon
    //            let name = i.weather?.cityName
    //            let cityMap = CityMap(title: name!,
    //                                  coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
    //
    //            mapView.addAnnotation(cityMap)
    //            mapView.selectAnnotation(cityMap, animated: true)
    //        }
    //        print ( "All favorite cities : " , listCities.description)
    //    }
    //
    
    // Showing alert when city name is invalid
    func alertInvalidCityName(){
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "invalid city name", message: "please enter a valid city name !", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let lat = locValue.latitude
        let long = locValue.longitude
        
        toto(x: lat, y: long)
        self.locationManager.stopUpdatingLocation()
    }
    
    func toto(x: Double, y: Double){
        guard let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&lat=\(x)&lon=\(y)") else {
            return
        }
        
        WeatherService.getWeather(url: weatherRequestURL) { (weather, error) in
            self.weatherInfo = weather
            guard self.weatherInfo != nil else{
                print ("Error !!")
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "detailsView", sender: self)
            }
        }
    }
}


