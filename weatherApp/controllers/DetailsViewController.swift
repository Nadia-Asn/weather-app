//
//  DetailsViewController.swift
//  weatherGeo
//
//  Created by Ahassouni, Nadia on 08/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import RealmSwift


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rain: UILabel!
    
    var realm: Realm!
    
    var weatherInfo: Weather?
    
    var cityReceived = ""
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var buttonState = "notSelected"
    
    
    @IBAction func favoriteButtonTaped(_ sender: UIButton) {
        
        if self.buttonState == "notSelected"{
            favoriteButton.setImage( UIImage(named: "starRempli"), for: .normal)
            let city = City()
            city.name = cityReceived
            city.weather = weatherInfo
            
            DBManager.sharedInstance.addCity(object: city)
            
            let w = DBManager.sharedInstance.getCitiesFromDb()
            print( "nb cities : " , w.count )
            print ( "Favorite cities : " , w.description)
            
            self.buttonState = "selected"
        }else if self.buttonState == "selected"{
            self.favoriteButton.setImage( UIImage(named: "starVide"), for: .normal)
            let cityName = cityReceived
            
            DBManager.sharedInstance.deleteCityByName(cityName: cityName)
            
            self.buttonState = "notSelected"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonState = "notSelected"
        cityName.text = cityReceived
        let tmpCelicius = (weatherInfo?.infoWeather?.temperature)! - 273.15
        temperature.text = "\(Int(round(tmpCelicius)))°"
        wind.text = "\(weatherInfo?.wind?.speed ?? 0.0) m/s"
        humidity.text = "\(weatherInfo?.infoWeather?.humidity ?? 0) %"
        cloudCover.text = "\(weatherInfo?.clouds?.clouds  ?? 0) %"
        weatherDescription.text = weatherInfo?.descriptif?.first?.desc
        
        guard let rainLastHours = weatherInfo?.rain?.lastHours else{
            rain.text = "no rain"
            return
        }
        rain.text = "\(rainLastHours)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

