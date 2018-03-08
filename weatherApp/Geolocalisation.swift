//
//  Geolocalisation.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 05/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Geolocalisation{
    
    // api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}
    
    // protocol
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    //MARK: initialization
    init(locationManager: CLLocationManager){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.startLocation = nil
        self.locationManager = locationManager
    }

    
}


