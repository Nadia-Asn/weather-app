//
//  WeatherService.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 14/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation

class WeatherService{
 
    static func getWeather(url: NSURL, completion: @escaping (_ weather: Weather?, _ error: Error?) -> ()){

        let urlRequest = URLRequest( url: url as URL)
        let decoder = JSONDecoder()
        
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
                    completion(nil, error)
                    print("Not such a city")
                    return
                }else{
                    let decode = try decoder.decode(Weather.self, from: data)
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

