//
//  city.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 12/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


////////////////////////////////////////////////////////////////////

/////////////////////////  CITY MODEL   ////////////////////////////

class City: Object,Codable {
    @objc dynamic var cityId = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var weather: Weather?
    
    override static func primaryKey() -> String? {
        return "cityId"
    }
    
    private enum cityCodingKeys: String, CodingKey {
        case name
        case weather
    }
    
    convenience init( name: String, weather: Weather) {
        self.init()
        self.name = name
        self.weather = weather
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: cityCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let weather = try container.decode(Weather.self, forKey: .weather)
        self.init(name: name, weather: weather)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

////////////////////////////////////////////////////////////////////

/////////////////////////  WEATHER   //////////////////////////////


//______________________Weather Model _________________________________//


class Weather:Object, Codable {
    
    @objc dynamic var cityName: String?
    @objc dynamic var code: Int = 0
    @objc dynamic var visibility: Int = 0
    @objc dynamic var dt: Int = 0
    
    @objc dynamic var infoWeather: InfoWeather?
    @objc dynamic var wind: Wind?
    @objc dynamic var rain: Rain?
    @objc dynamic var clouds: CLouds?
    @objc dynamic var coord: Coord?
    var descriptif: [Descriptif]?
    
    @objc dynamic var descript: String?
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case code = "cod"
        case visibility
        case dt
        case infoWeather = "main"
        case wind
        case rain
        case clouds
        case coord
        case descriptif = "weather"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let cityName = try values.decode(String.self, forKey: .cityName)
        let code = try values.decode(Int.self, forKey: .code)
        let visibility = try values.decode(Int.self, forKey: .visibility)
        let dt = try values.decode(Int.self, forKey: .dt)
        
        let infoWeather = try values.decode(InfoWeather.self, forKey: .infoWeather)
        let wind = try values.decode(Wind.self, forKey: .wind)
        let clouds = try values.decode(CLouds.self, forKey: .clouds)
        
        let rain = try? values.decode(Rain.self, forKey: .rain)
        let coord = try? values.decode(Coord.self, forKey: .coord)
        let descriptif = try? values.decode([Descriptif].self, forKey: .descriptif)
        
        self.init(cityName: cityName, code: code, visibility: visibility, dt: dt, infoWeather: infoWeather, wind: wind, rain: rain, clouds: clouds, descriptif: descriptif!, coord: coord!)
        
    }
    
    convenience init( cityName: String, code: Int,visibility: Int, dt: Int, infoWeather: InfoWeather, wind: Wind, rain: Rain?, clouds: CLouds, descriptif: [Descriptif], coord: Coord) {
        self.init()
        self.cityName = cityName
        self.code = code
        self.visibility = visibility
        self.dt = dt
        self.infoWeather = infoWeather
        self.wind = wind
        self.clouds = clouds
        self.descriptif = descriptif
        self.descript = descriptif[0].desc
        self.coord = coord
        if(rain != nil){
            self.rain = rain
        }else{
            self.rain = nil
        }
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cityName, forKey: .cityName)
    }
}

////////////////////////////////////////////////////////////////////

/////////////////////////  INFO WEATHER   //////////////////////////////


class InfoWeather: Object, Codable{
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var humidity: Int = 0
    
    enum CodingKeys: String, CodingKey{
        case temperature = "temp"
        case humidity = "humidity"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let temperature = try container.decode(Double.self, forKey: .temperature)
        let humidity = try container.decode(Int.self, forKey: .humidity)
        self.init(temperature: temperature, humidity: humidity)
    }
    
    convenience init(temperature: Double, humidity: Int) {
        self.init()
        self.temperature = temperature
        self.humidity = humidity
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


////////////////////////////////////////////////////////////////////

////////////////////////////  WIND   //////////////////////////////


class Wind: Object, Codable{
    @objc dynamic var speed: Double = 0.0
    @objc dynamic var degree: Int = 0
    
    enum CodingKeys: String, CodingKey{
        case speed
        case degree = "deg"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let speed = try container.decode(Double.self, forKey: .speed)
        let degree = try container.decode(Int.self, forKey: .degree)
        self.init(speed: speed, degree: degree)
    }
    
    convenience init(speed: Double, degree: Int) {
        self.init()
        self.speed = speed
        self.degree = degree
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}




////////////////////////////////////////////////////////////////////

////////////////////////////  RAIN   //////////////////////////////


class Rain: Object, Codable{
    @objc dynamic var lastHours: Int = 0
    
    enum CodingKeys: String, CodingKey{
        case lastHours = "3h"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let lastHours = try container.decode(Int.self, forKey: .lastHours)
        self.init(lastHours: lastHours)
    }
    
    convenience init(lastHours: Int) {
        self.init()
        self.lastHours = lastHours
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


////////////////////////////////////////////////////////////////////

////////////////////////////  CLOUD   //////////////////////////////


class CLouds: Object, Codable{
    @objc dynamic var clouds: Int = 0
    
    enum CodingKeys: String, CodingKey{
        case clouds = "all"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let clouds = try container.decode(Int.self, forKey: .clouds)
        self.init(clouds: clouds)
    }
    
    convenience init(clouds: Int) {
        self.init()
        self.clouds = clouds
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

////////////////////////////////////////////////////////////////////

/////////////////////////  Weather desc   //////////////////////////


class Descriptif: Object, Codable{
    @objc dynamic var desc: String = ""
    
    enum CodingKeys: String, CodingKey{
        case desc = "description"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let desc = try container.decode(String.self, forKey: .desc)
        self.init(desc: desc)
    }
    
    convenience init(desc: String) {
        self.init()
        self.desc = desc
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

////////////////////////////////////////////////////////////////////

////////////////////////////  Coordinate   /////////////////////////


class Coord: Object, Codable{
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var lat: Double = 0.0

    enum CodingKeys: String, CodingKey{
        case lon
        case lat
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let lon = try container.decode(Double.self, forKey: .lon)
        let lat = try container.decode(Double.self, forKey: .lat)
        self.init(lon: lon, lat: lat)
    }

    convenience init(lon: Double, lat: Double) {
        self.init()
        self.lon = lon
        self.lat = lat
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

