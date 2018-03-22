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
    
    var buttonState = ""
    
    @IBAction func favoriteButtonTaped(_ sender: UIButton) {
        
        if self.buttonState == "notSelected"{
            addFavoriteCityInDB()
        }else if self.buttonState == "selected"{
            deleteFavoriteCityFromDB()
        }
    }
    
    // Add the favorite city in DB
    func addFavoriteCityInDB(){
        favoriteButton.setImage( UIImage(named: "starRempli"), for: .normal)
        let city = City()
        city.name = (self.weatherInfo?.cityName)!
        city.weather = self.weatherInfo
        
        DBManager.sharedInstance.addCity(object: city)
    
        self.buttonState = "selected"
    }
    
    // Delete the city from the favorite city in DB
    func deleteFavoriteCityFromDB(){
        self.favoriteButton.setImage( UIImage(named: "starVide"), for: .normal)
        let cityName = (self.weatherInfo?.cityName)!
        
        DBManager.sharedInstance.deleteCityByName(cityName: cityName)
        
        self.buttonState = "notSelected"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityReceived = (self.weatherInfo?.cityName)!
        diplayWetherInformations()
    }
    
    func setUpFavoriteImage(){
        if (DBManager.sharedInstance.cityExistedInDB(cityName: cityReceived) == true){
            self.buttonState = "selected"
            self.favoriteButton.setImage( UIImage(named: "starRempli"), for: .normal)
        }else{
            self.buttonState = "notSelected"
            self.favoriteButton.setImage( UIImage(named: "starVide"), for: .normal)
        }
    }

    // Display the weather information in the view
    func diplayWetherInformations() {
        setUpFavoriteImage()
        self.cityName.text = weatherInfo?.cityName
        let tmpCelicius = (weatherInfo?.infoWeather?.temperature)! - 273.15
        self.temperature.text = "\(Int(round(tmpCelicius)))°"
        self.wind.text = "\(weatherInfo?.wind?.speed ?? 0.0) m/s"
        self.humidity.text = "\(weatherInfo?.infoWeather?.humidity ?? 0) %"
        self.cloudCover.text = "\(weatherInfo?.clouds?.clouds  ?? 0) %"
        self.weatherDescription.text = weatherInfo?.descriptif?.first?.desc
        
        guard let rainLastHours = weatherInfo?.rain?.lastHours else{
            self.rain.text = "no rain"
            return
        }
        self.rain.text = "\(rainLastHours)"
    }
    
    // Update information when the phone is shaken
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print (" Phone shaken ...")
            
            guard let city = self.weatherInfo?.cityName else{
                return
            }

            WeatherRequestService.getWeather(params: ["q" : city]) { (weather, error) in
                self.weatherInfo = weather
                
                guard self.weatherInfo != nil else{
                    return
                }
            }
            diplayWetherInformations()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

