//
//  WeatherGetter.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 05/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//


import Foundation
import os.log
/*
 
 protocol weatherGetterDelegate: class {
 func didGetWeather(weather: Weather)
 func didNotGetWeather(error: NSError)
 }
 
 
 // MARK: WeatherGetter
 
 class WeatherGetter {
 
 private let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
 private let apiKey = "440641e20987cefb9bd803e6e48a9444"
 
 // Protocol
 private var delegate: weatherGetterDelegate
 
 //MARK: initialisation
 init(delegate: weatherGetterDelegate){
 self.delegate = delegate
 }
 
 
 // function
 
 
 
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
 //if(weatherRequestURL != nil){
 getWeather(weatherReq: weatherRequestURL)
 //}else{
 //    print("error")
 //}
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
 // launch pop-up
 return
 }else{
 let decoder = JSONDecoder()
 let decode = try decoder.decode(WeatherInformation.self, from: data)
 print ("json decoder : " , decode.code)
 print(decode)
 //delegate.didGetWeather(weather: decode)
 }
 
 } catch  {
 print("error decoding data")
 self.delegate.didNotGetWeather(error: error as NSError)
 return
 }
 }
 taskTest.resume()
 }
 }*/

