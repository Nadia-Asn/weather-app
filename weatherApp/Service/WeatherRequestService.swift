//
//  WeatherRequestService.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 22/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation

class WeatherRequestService{
    
    static func getWeather(params: [String:String], completion: @escaping (_ weather: Weather?, _ error: Error?) -> ()){
        
        let urlComp = NSURLComponents(string: K.API.Weather.url)!
        let apiKey = K.API.Weather.key
        
        var items = [URLQueryItem]()
        
        items.append(URLQueryItem(name: K.ServiceWeatherKeys.appId, value: apiKey))
        
        for(key, value) in params{
            items.append(URLQueryItem(name: key, value: value))
        }
        
        if !items.isEmpty {
            urlComp.queryItems = items
        }

        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
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
                    completion(nil, error)
                    print("Not such a city")
                    return
                }else{
                    //ConversorWeather.dataToWeather(data: data)
                    let decoder = JSONDecoder()
                    let decode = try decoder.decode(Weather.self, from: data)
//                    ConversorWeather.dataToWeather(data: data, completion: { (weather, error) in
//                        completion()
//                    })
                    completion(decode, nil)
                }
                
            } catch  {
                print("error decoding data")
                completion(nil, error)
                return
            }
        }
        taskTest.resume()
    }
}

