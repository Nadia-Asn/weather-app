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
    
    // MARK : MAP
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = CLLocationDistance(K.Initialisation.LocationMap.regionRadius)
    
    // MARK : Strorybord components
    
    @IBOutlet weak var city: UITextField!

    // MARK: Model
    
    var weatherInfo: Weather?
    
    // MARK : Localisation
    
    var locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: K.Initialisation.LocationMap.latitude, longitude: K.Initialisation.LocationMap.longitude)
    
    // MARK : BD
    
    var cities = DBManager.sharedInstance.getCitiesFromDb()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        centerMapOnLocation(location: self.initialLocation)
        mapRemoveAnnotations()
        mapAddAnnotations(cities: self.cities)
        mapView.delegate = self
    }

    ////////////////////////// Segue and Redirection //////////////////////////////
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.StoryBoardSegue.detail{
            redirectToDetailsView(segue: segue)

        }else if segue.identifier == K.StoryBoardSegue.favoriteCities{
            redirectToCitiesTableView(segue: segue)
        }
    }
    
    @IBAction func searchButtonTaped(_ sender: UIButton) {
        
        guard let cityName = self.city.text else {
            return
        }
        //!!!
        requestServiceByCityName(cityName: cityName)
    }

    @IBAction func geoLocalisationButtonTaped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.setUpGeaolocation()
        }
    }

    @IBAction func favoriteCitiesButtonTaped(_ sender: Any) {
        self.performSegue(withIdentifier: K.StoryBoardSegue.favoriteCities, sender: self)
    }
    
    func redirectToDetailsView(segue: UIStoryboardSegue){
        if let detailsController = segue.destination as? DetailsViewController {
            detailsController.cityReceived = self.city.text!
            detailsController.weatherInfo = self.weatherInfo
        }
    }
    
    func redirectToCitiesTableView(segue: UIStoryboardSegue){
        if let favoriteController = segue.destination as? CitiesTableViewController {
            favoriteController.cityName = self.city.text!
        }
    }
    
    func requestServiceByCityName(cityName: String){
                                                                                                            //!!!
        WeatherRequestService.getWeather(params: [K.ServiceWeatherKeys.cityNameKey : cityName]) { (weather, error) in
            self.weatherInfo = weather
            //!!! gestion error
            
            guard self.weatherInfo != nil else{
                return
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: K.StoryBoardSegue.detail, sender: self)
            }
        }
    }
    
    ///  get the weather information of a city using the coordinates of given in parameters
    ///
    /// - Parameters:
    ///   - x: latitude coordinate
    ///   - y: longitude coordinate
    func requestServiceByCoordinate(x: Double, y: Double){
        WeatherRequestService.getWeather(params: [K.ServiceWeatherKeys.latitudeKey : String(x) , K.ServiceWeatherKeys.longitudeKey : String(y)]) { (weather, error) in
            self.weatherInfo = weather
            //!!!
            guard self.weatherInfo != nil else{
                return
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: K.StoryBoardSegue.detail, sender: self)
            }
        }
    }
    
    // Centre the map & make favorites cities on it
    func centerMapOnLocation(location: CLLocation, animated: Bool = true) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: animated)
    }

    
    func mapRemoveAnnotations(){
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
    func mapAddAnnotations(cities: Results<City>){
        var listAnotation = [CityMap]()
        for city in cities{
            if let latitude = city.weather?.coord?.lat, let longitude = city.weather?.coord?.lon, let name = city.weather?.cityName {
                let cityMap = CityMap(title: name,
                                      coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                listAnotation.append(cityMap)
            }
        }
        mapView.addAnnotations(listAnotation)
    }
}



extension SearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CityMap, let title = annotation.title{
            requestServiceByCityName(cityName: title)
        }
    }
}


extension SearchViewController: CLLocationManagerDelegate {
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return }
        
        requestServiceByCoordinate(x: locValue.latitude, y: locValue.longitude)
        /**
         only one location necesary
         */
        manager.stopUpdatingLocation()
    }
    
    func setUpGeaolocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.locationManager.delegate = self
        }
    }
}

