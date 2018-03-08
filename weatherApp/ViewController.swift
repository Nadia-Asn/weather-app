//
//  ViewController.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 02/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    
    private let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "440641e20987cefb9bd803e6e48a9444"
    
    @IBOutlet weak var weatherDetails: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialisation
        
        cityLabel.text = "weather"
        weatherDetails.text = "Weather details"
        weatherLabel.text = ""
        temperatureLabel.text = ""
        cloudLabel.text = ""
        windLabel.text = ""
        rainLabel.text = ""
        humidityLabel.text = ""
        cityTextField.text = ""
        cityTextField.placeholder = "Enter a city name"
        cityTextField.delegate = self as UITextFieldDelegate
        cityTextField.enablesReturnKeyAutomatically = true
        buttonOk.isEnabled = false
        
        
        
        let buttonGeoloc = UIButton()
        buttonGeoloc.frame = CGRect(x: 270, y:90, width: 50, height: 50)
        buttonGeoloc.setBackgroundImage(img, for: UIControlState.normal)
        buttonGeoloc.addTarget(self, action: #selector(ViewController.getLocalisationButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(buttonGeoloc)
        buttonGeoloc.isEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Get weather by city name
    func getWeatherByCity(city: String){
        let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&q=\(city)")
        if(weatherRequestURL != nil){
            getWeather(weatherReq: weatherRequestURL!)
        }else{
            print("error")
        }
    }
    
    // Get weather by city name
    func getWeatherByGeolocalisation(latitude: Double, longitude: Double){
        let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&lat=\(latitude)&lon=\(longitude)")!
        if(weatherRequestURL != nil){
        getWeather(weatherReq: weatherRequestURL)
        }else{
            print("error")
        }
    }
    
    private func getWeather(weatherReq: NSURL){
        
        /*  var urlRequest = URLRequest(
         url: weatherReq as URL,
         cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
         timeoutInterval: 10.0 * 1000)
         urlRequest.httpMethod = "GET"
         urlRequest.addValue("application/json", forHTTPHeaderField: "Accept") */
        
        let urlRequest = URLRequest(
            url: weatherReq as URL)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let taskTest = session.dataTask(with: urlRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            
            guard error == nil else {
                print("error calling GET on weather api")
                print(error!)
                return
            }
            // make sure we got data
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let weather = try JSONSerialization.jsonObject(with: data)
                    as? [String: AnyObject] else {
                        print("error trying to convert data to JSON !! ")
                        return
                }
                
                if let cod = weather["cod"]  as? String ,  cod == "404" {
                    print("Not such a city")
                    self.alertInvalidCityName()
                    return
                }else{
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode(WeatherInformation.self, from: data)
                    print ("json decoder : " , decode.code)
                    print(decode)
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
    
    
    /////////////////////////////////////////////////////
    
    
    // Button recherche event
    @IBAction func gettheCityWhenButtonPressed(sender: UIButton){
        guard let text = cityTextField.text, !text.isEmpty else{
            return
        }
        getWeatherByCity(city: cityTextField.text!)
    }
    
    // Ask for geolocalisation when button pressed
    @IBAction func getLocalisationButtonPressed(sender: UIButton){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        gettheCityWhenButtonPressed(sender: buttonOk)
        return true
    }
    
    // Get weather returned data OK
    func didGetWeather(weather: WeatherInformation) {
        DispatchQueue.main.async(){
            /* self.cityLabel.text = weather.city
             self.weatherLabel.text = weather.weatherDescription
             self.cloudLabel.text = "\(weather.cloudCover)%"
             self.humidityLabel.text = "\(weather.humidity)%"
             self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
             self.windLabel.text = "\(weather.windSpeed) m/s"
             
             if let rain = weather.rainfallInLast3Hours{
             self.rainLabel.text = "\(rain) mm"
             }else{
             self.rainLabel.text = "no rain"
             }*/
            
            self.cityLabel.text = weather.cityName
            self.weatherLabel.text = "\(weather.wind?.degree ?? 0)%"
            //self.cloudLabel.text = "\(weather.coord ?? 0)%"
            self.humidityLabel.text = "\(weather.dt ?? 00)%"
            //self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            self.windLabel.text = "\(weather.wind?.speed ?? 0.0) m/s"
            
        }
    }
    
    // get weather return data failed
    func didNotGetWeather(error: NSError) {
        DispatchQueue.main.async() {
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        print(type(of: locValue.longitude))
        getWeatherByGeolocalisation(latitude: locValue.latitude, longitude: locValue.longitude)
        self.cloudLabel.text = locValue.latitude.description
    }
    
    // Enable the button if there is text in cityTextField
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(
            in: range,
            with: string)
        buttonOk.isEnabled = prospectiveText.characters.count > 0
        return true
    }
    
    // Showing alert when city name is invalid
    func alertInvalidCityName(){
        // create the alert
        let alert = UIAlertController(title: "invalid city name", message: "please enter a valid city name !", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}




