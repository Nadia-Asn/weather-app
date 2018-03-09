//
//  DetailsViewController.swift
//  weatherGeo
//
//  Created by Ahassouni, Nadia on 08/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rain: UILabel!
    
    var weatherInfo: WeatherInformation?
    
    var cityReceived = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = cityReceived
        country.text = weatherInfo?.sys?.country.description
        temperature.text = weatherInfo?.cityName
        wind.text = "\(weatherInfo?.wind?.degree ?? 0)"
        cloudCover.text = "\(weatherInfo?.clouds?.all ?? 0) %"
        let tmpCelicius = (weatherInfo?.info?.temperature)! - 273.15
        temperature.text = "\(Int(round(tmpCelicius)))°"
        humidity.text = "\(weatherInfo?.info?.humidity ?? 0)"
        guard let rainLastHours = weatherInfo?.rain?.lastHours else{
            return
        }
        rain.text = "\(rainLastHours)"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

