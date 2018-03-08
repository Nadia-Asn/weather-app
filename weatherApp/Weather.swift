//
//  Weather.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 05/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//
// THE WEATHER MODEL
struct Coord: Codable{
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Clouds: Codable{
    var all: Int
    
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

struct Wind: Codable{
    var speed: Double
    var degree: Int?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
}

struct Weather: Codable{
    var id_weather: Int
    var main_weather: String
    var weather_desc: String
    var weather_icon: String
    
    enum CodingKeys: String, CodingKey{
        case id_weather = "id"
        case main_weather = "main"
        case weather_desc = "description"
        case weather_icon = "icon"
    }
}

struct Sys: Codable{
    var type: Int
    var id_sys: Int
    var message: Double
    var country: String
    var sunrise: Int
    var sunset: Int
    
    enum CodingKeys: String, CodingKey{
        case type = "type"
        case id_sys = "id"
        case message = "message"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
    
}




struct WeatherInformation: Codable {
    
    var cityName: String?
    var code: Int
    var base: String?
    var visibility: Int?
    var dt: Int?
    var coord: Coord?
    var sys: Sys?
    var wind: Wind?
    var clouds: Clouds?
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decode(Int.self, forKey: .code)
        cityName = try values.decode(String.self, forKey: .cityName)
        base = try values.decode(String.self, forKey: .base)
        visibility = try values.decode(Int.self, forKey: .visibility)
        dt = try values.decode(Int.self, forKey: .dt)
        coord = try values.decode(Coord.self, forKey: .coord)
        sys = try values.decode(Sys.self, forKey: .sys)
        wind = try values.decode(Wind.self, forKey: .wind)
        clouds = try values.decode(Clouds.self, forKey: .clouds)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case code = "cod"
        case id
        case base
        case visibility
        case dt
        case coord = "coord"
        case sys = "sys"
        case wind = "wind"
        case clouds = "clouds"
    }
    
    
    
    mutating func decode(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try values.decode(Int.self, forKey: .code)
        if(code == 170){
            print ("error 170")
        }else{
            self.cityName = try values.decode(String.self, forKey: .cityName)
            
            self.base = try values.decode(String.self, forKey: .base)
            self.visibility = try values.decode(Int.self, forKey: .visibility)
            self.dt = try values.decode(Int.self, forKey: .dt)
            
            self.coord = try values.decode(Coord.self, forKey: .coord)
            self.sys = try values.decode(Sys.self, forKey: .sys)
            self.wind = try values.decode(Wind.self, forKey: .wind)
            self.clouds = try values.decode(Clouds.self, forKey: .clouds)
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cityName, forKey: .cityName)
    }
}

