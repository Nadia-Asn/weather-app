//
//  weatherFromAPI.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 02/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import os.log


protocol weatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

// MARK: WeatherGetter
class WeatherGetter {
    
    private let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "440641e20987cefb9bd803e6e48a9444"
    
    // Protocol
    private var delegate: WeatherGetter
    
    //MARK: -
    init(delegate: weatherGetterDelegate){
        self.delegate = delegate
    }
    
    func getWeatherByCity(city: String){
        let weatherReq = urlAPI+"?APPID="+apiKey+"&q="+city
        getWeather(weatherReq)
    }
    
    func getWeather(weatherReq: NSURL){
        // Set up the URL request
        //let todoEndpoint: String = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=095711373620570aa92ee530246dc8af"
        
        //let todoEndpoint = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&q=\(city)")!
        let todoEndpoint = urlAPI+"?APPID="+apiKey+"&q="+city
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let taskTest = session.dataTask(with: urlRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            print(error ?? "NoError")
            print(urlResponse ?? "NoResposne")
            print(data ?? "noData")
            
            // parsing the data
            do {
                guard let weather = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // print weather
                print("Weather data : " + weather.description)
                print("Could not get todo title from JSON")
                print(weather["coord"]!["lat"])
                print(weather["main"]!["temp"]!!)
            
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        
        taskTest.resume()
    }
}

