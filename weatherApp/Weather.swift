////
////  Weather.swift
////  weatherApp
////
////  Created by Ahassouni, Nadia on 05/03/2018.
////  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
////
//// THE WEATHER MODEL
//
//struct Coord: Codable{
//    var latitude: Double
//    var longitude: Double
//    
//    enum CodingKeys: String, CodingKey {
//        case latitude = "lat"
//        case longitude = "lon"
//    }
//}
//
//struct Clouds: Codable{
//    var all: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case all = "all"
//    }
//}
//
//struct Wind: Codable{
//    var speed: Double
//    var degree: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case speed
//        case degree = "deg"
//    }
//}
//
//struct Weather: Codable{
//    var id: Int
//    var main: String
//    var description: String
//    var icon: String
//}
//
//struct Sys: Codable{
//    var type: Int
//    var id_sys: Int
//    var message: Double
//    var country: String
//    var sunrise: Int
//    var sunset: Int
//    
//    enum CodingKeys: String, CodingKey{
//        case type = "type"
//        case id_sys = "id"
//        case message = "message"
//        case country = "country"
//        case sunrise = "sunrise"
//        case sunset = "sunset"
//    }
//}
//
//struct Info: Codable{
//    var temperature: Double?
//    var pressure: Int?
//    var humidity: Int?
//    var tmp_min: Double?
//    var tmp_max: Double?
//    
//    enum CodingKeys: String, CodingKey{
//        case temperature = "temp"
//        case pressure = "pressure"
//        case humidity = "humidity"
//        case tmp_min = "temp_min"
//        case tmp_max = "temp_max"
//    }
//}
//
//struct Rain: Codable{
//    var lastHours: Int?
//    
//    enum CodingKeys: String, CodingKey{
//        case lastHours = "3h"
//    }
//}
//
//
//
////______________________Weather Model _________________________________//
//
//
//class WeatherInformation: Codable {
//    
//    var cityName: String?
//    var code: Int
//    var base: String?
//    var visibility: Int?
//    var dt: Int?
//    var coord: Coord
//    var sys: Sys?
//    var wind: Wind?
//    var clouds: Clouds
//    var info: Info
//    var rain: Rain?
//    var weather: [Weather]
//    
//    enum CodingKeys: String, CodingKey {
//        case cityName = "name"
//        case code = "cod"
//        case id
//        case base
//        case visibility
//        case dt
//        case coord = "coord"
//        case sys = "sys"
//        case wind = "wind"
//        case clouds = "clouds"
//        case info = "main"
//        case rain
//        case weather
//    }
//    
//    public required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//         code = try values.decode(Int.self, forKey: .code)
//         cityName = try values.decode(String.self, forKey: .cityName)
//         base = try values.decode(String.self, forKey: .base)
//         visibility = try values.decode(Int.self, forKey: .visibility)
//         dt = try values.decode(Int.self, forKey: .dt)
//         coord = try values.decode(Coord.self, forKey: .coord)
//         sys = try values.decode(Sys.self, forKey: .sys)
//         wind = try values.decode(Wind.self, forKey: .wind)
//         clouds = try values.decode(Clouds.self, forKey: .clouds)
//         info = try values.decode(Info.self, forKey: .info)
//         weather = try values.decode([Weather].self, forKey: .weather)
//        if values.contains(.rain) {
//             rain = try values.decode(Rain.self, forKey: .rain)
//        } else {
//          rain = nil
//        }
//        
//        
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(cityName, forKey: .cityName)
//    }
//}
//

