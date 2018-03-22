//
//  Localisation.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 22/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import CoreLocation

// Adding protocol CLLocation
protocol LocalisationDelegate: CLLocationManagerDelegate {
    
    // Get user coordinates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
    func setUpGeaolocation()
}


