//
//  SearchViewController.swift
//  weatherGeo
//
//  Created by Ahassouni, Nadia on 08/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import CoreLocation


class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    // Strorybord components
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var city: UITextField!
    
    
    var weatherInfo: Weather?
    
    // Localisation
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    // API weather
    private let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "440641e20987cefb9bd803e6e48a9444"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.city.borderStyle = UIColor.darkGray
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsView"{
            let detailsController = segue.destination as! DetailsViewController
            detailsController.cityReceived = self.city.text!
            detailsController.weatherInfo = self.weatherInfo
        }
        /*} else if segue.identifier == "detailsTable"{
         let controllerDet = segue.destination as! WeatherDetailsTableViewController
         controllerDet.cityNameReceived = self.city.text!
         }*/
    }
    
    @IBAction func searchButtonTaped(_ sender: UIButton) {
        
        guard let text = city.text, !text.isEmpty else{
            return
        }
        getWeatherByCity(city: city.text!)
    }
    
    @IBAction func detailsButtonTaped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "detailsTable", sender: self)
    }
    
    @IBAction func geoLocalisationButtonTaped(_ sender: Any) {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        locationManager.delegate = self
    }
    
    @IBAction func getFavoriteCitiesButtonTaped(_ sender: Any) {
    }
    
    
    // Get weather by city name
    func getWeatherByCity(city: String){
        let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&q=\(city)")
        getWeather(weatherReq: weatherRequestURL!)
    }
    
    // Showing alert when city name is invalid
    func alertInvalidCityName(){
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "invalid city name", message: "please enter a valid city name !", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Get weather returned data OK
    func didGetWeather(weather: Weather) {
        DispatchQueue.main.async(){
            self.weatherInfo = weather
            guard self.weatherInfo != nil else{
                return
            }
            self.performSegue(withIdentifier: "detailsView", sender: self)
        }
    }
    
    
    // get weather return data failed
    func didNotGetWeather(error: NSError) {
        self.alertInvalidCityName()
        print("didNotGetWeather error: \(error)")
    }
    
    private func getWeather(weatherReq: NSURL){
        
        let urlRequest = URLRequest(
            url: weatherReq as URL)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let taskTest = session.dataTask(with: urlRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            
            guard error == nil else {
                print("error calling GET on weather api")
                return
            }
            // make sure we got data
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let weather = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON !! ")
                    return
                }
                
                if let cod = weather["cod"]  as? String ,  cod == "404" {
                    print("Not such a city")
                    self.alertInvalidCityName()
                    return
                }else{
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode(Weather.self, from: data)
                    self.didGetWeather(weather: decode)
                }
                
            } catch  {
                print("error decoding data")
                self.didNotGetWeather(error: error as NSError)
                return
            }
        }
        taskTest.resume()
        
    }
    
    
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getWeatherByGeolocalisation(latitude: locValue.latitude, longitude: locValue.longitude)
        //self.cloudLabel.text = locValue.latitude.description
    }
    
    // Get weather by city name
    func getWeatherByGeolocalisation(latitude: Double, longitude: Double){
        let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherReq: weatherRequestURL)
    }
}

