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
import Realm
import RealmSwift

class SearchViewController: UIViewController  {
    
    var notifToken: NotificationToken? = nil
    // MARK : MAP
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000000
    
    // MARK : Strorybord components
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var city: UITextField!

    // MARK: Model
    var weatherInfo: Weather?
    
    // MARK : Localisation
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    let initialLocation = CLLocation(latitude: 34.686667, longitude: -1.911389)
    
    var cities = DBManager.sharedInstance.getCitiesFromDb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(location: self.initialLocation)
        getNotifications(cities: self.cities)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        mapRemoveAnnotations()
        mapAddAnnotations(cities: self.cities)
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsView"{
            redirectToDetailsView(segue: segue)

        }else if segue.identifier == "favoriteCities"{
            redirectToCitiesTableView(segue: segue)
        }
    }
    
    @IBAction func detailsButtonTaped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "detailsTable", sender: self)
    }
    
    @IBAction func searchButtonTaped(_ sender: UIButton) {
        
        guard let cityName = self.city.text else{
            return
        }
        requestServiceByCityName(cityName: cityName)
    }

    @IBAction func geoLocalisationButtonTaped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.setUpGeaolocation()
        }
    }

    @IBAction func favoriteCitiesButtonTaped(_ sender: Any) {
        self.performSegue(withIdentifier: "favoriteCities", sender: self)
    }
    
    func redirectToDetailsView(segue: UIStoryboardSegue){
        let detailsController = segue.destination as! DetailsViewController
        detailsController.cityReceived = self.city.text!
        detailsController.weatherInfo = self.weatherInfo
    }
    
    func redirectToCitiesTableView(segue: UIStoryboardSegue){
        let controllerDet = segue.destination as! CitiesTableViewController
        controllerDet.x = self.city.text!
    }
    
    
    /// Get notification when the Realm database was changed
    ///
    /// - Parameter cities: Collection of the current cities in database
    func getNotifications(cities: Results<City>){
        self.notifToken = cities.observe { changes in
            switch changes {
            case .initial:
                print ( " ---> initial ")
            case .update:
                print ("---> database updated")
            case .error(let error):
                fatalError("---> \(error)")
            }
        }
    }
    
    func requestServiceByCityName(cityName: String){
        WeatherRequestService.getWeather(params: ["q" : cityName]) { (weather, error) in
            self.weatherInfo = weather
            
            guard self.weatherInfo != nil else{
                return
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "detailsView", sender: self)
            }
        }
    }
    
    ///  get the weather information of a city using the coordinates of given in parameters
    ///
    /// - Parameters:
    ///   - x: latitude coordinate
    ///   - y: longitude coordinate
    func requestServiceByCoordinate(x: Double, y: Double){
        WeatherRequestService.getWeather(params: ["lat" : String(x) , "lon" : String(y)]) { (weather, error) in
            self.weatherInfo = weather
            
            guard self.weatherInfo != nil else{
                return
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "detailsView", sender: self)
            }
        }
    }
    
    // Centre the map & make favorites cities on it
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }

    
    func mapRemoveAnnotations(){
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
    func mapAddAnnotations(cities: Results<City>){
        for i in cities{
            let latitude = i.weather?.coord?.lat
            let longitude = i.weather?.coord?.lon
            let name = i.weather?.cityName
            let cityMap = CityMap(title: name!,
                                  coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            
            mapView.addAnnotation(cityMap)
        }
    }

    
}

extension SearchViewController: CLLocationManagerDelegate {
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return }
        
        requestServiceByCoordinate(x: locValue.latitude, y: locValue.longitude)
        self.locationManager.stopUpdatingLocation()
    }
    
    func setUpGeaolocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
}

