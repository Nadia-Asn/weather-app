//
//  Cachable.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 16/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation

protocol Cachable{
    var cityName: String {
        get
    }
    func transform() -> Weather
}
