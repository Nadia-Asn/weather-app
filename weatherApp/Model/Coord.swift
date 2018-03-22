//
//  Coord.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 22/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

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
