//
//  ManageDataBase.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 12/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    private var   database:Realm
    static let   sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getCitiesFromDb() ->   Results<City> {
        let results: Results<City> =   database.objects(City.self)
        return results
    }
    
    func addCity(object: City)   {
        try! database.write {
            database.add(object)
            //database.add(object, update: true)
            print("Added new city")
        }
    }
    func deleteAllCities()  {
        try!   database.write {
            database.deleteAll()
            print("deleted all the cities")
            
        }
    }
    func deleteCity(object: City)   {
        try!   database.write {
            database.delete(object)
            print("deleted a city ")
            
        }
    }
    
    func deleteCityByName(cityName: String){
        let city = database.objects(City.self).filter("name = '\(cityName)\' ").first!
        try!   database.write {
            database.delete(city)
            print("deleted a city ")
            
        }
    }
}
