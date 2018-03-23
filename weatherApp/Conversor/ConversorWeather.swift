//
//  ConversorWeather.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 23/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation

class ConversorWeather {
    static func dataToWeather(data: Data) -> Weather?{
        let decoder = JSONDecoder()

        do {
            let decode =   try decoder.decode(Weather.self, from: data)
            return decode
        } catch  {
            return nil
        }
    }
    
    static func dataToWeather(data: Data, completion: (_ weather: Weather?, _ error: Error?) -> ()) {
        let decoder = JSONDecoder()
        do {
             let decode =   try decoder.decode(Weather.self, from: data)
            completion(decode,nil)
        } catch  {
            completion(nil, error)
        }
    }
}

