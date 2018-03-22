//
//  CityMap.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 15/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import MapKit


/// Object used to represente a city as an annotation
class CityMap: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String , coordinate: CLLocationCoordinate2D) {
        self.title = title
         self.coordinate = coordinate
        super.init()
    }
}
