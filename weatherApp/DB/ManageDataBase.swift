//
//  ManageDataBase.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 12/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import RealmSwift

// Managing the DB : insert/delete/update ...
class DBManager {
     var   database:Realm
    static let   sharedInstance = DBManager()
    
     init() {
        database = try! Realm(configuration: DBManager.getRealmConfiguration())
    }
    
    // Get all the cities from the DB
    func getCitiesFromDb() ->   Results<City> {
        let results: Results<City> =   database.objects(City.self)
        return results
    }
    
    // Get Realm database configuration
    static func getRealmConfiguration() -> Realm.Configuration{
        let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.pictime.test2")! as NSURL
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var configuration = Realm.Configuration()
        configuration.fileURL = realmPath
        
        return configuration
    }
    
    // Insert the city given in paramater in the DB
    func addCity(object: City)   {
        try! database.write {
            database.add(object)
            //database.add(object, update: true)
            print("Added new city")
        }
    }
    
    // Delete all the cities from DB
    func deleteAllCities()  {
        try!   database.write {
            database.deleteAll()
            print("deleted all the cities")
            
        }
    }
    
    // Delete the city given in parameter from DB
    func deleteCity(object: City)   {
        try!   database.write {
            database.delete(object)
            print("deleted a city ")
            
        }
    }
    
    // Delete the city given in parameter from the DB
    func deleteCityByName(cityName: String){
        let city = database.objects(City.self).filter("name = '\(cityName)\' ").first!
        try!   database.write {
            database.delete(city)
            print("deleted a city ")
            
        }
    }
    
    // Get the city given in parameter
    func getCityByName(cityName: String) -> City  {
        let city = database.objects(City.self).filter("name = '\(cityName)\' ").first
        return city!
    }
    
    // Check if the city given in parameter exist in DB -> True if existen 
    func cityExistedInDB(cityName: String) -> Bool  {
        if database.objects(City.self).filter("name = '\(cityName)\' ").first != nil {
            return true
        }else{
            return false
        }
    }
}
