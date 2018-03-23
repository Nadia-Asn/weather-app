//
//  CellCity.swift
//  weatherExtension
//
//  Created by Ahassouni, Nadia on 20/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//


import UIKit

// cell identifier
let CellCityIdentifier = "CellCity"

/*
 A city cell representing with a city label and degree label
 */
class CellCity: UITableViewCell {
    
    var city: City? = nil
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDegree: UILabel!
    
    
    
    func configureCell() {
        //TODO: update UI cell
    }
    
    func configureAppereance()  {
        //TODO: configure cell appareance 
    }
    
}
