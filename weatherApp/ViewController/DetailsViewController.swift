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
    
    // MARK : Strorybord components
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var realm: Realm! //!!! extension
    var cityReceived = ""
    var starState = ""
    
    // MARK : Model
    
    var weatherInfo: Weather?

    @IBAction func favoriteButtonTaped(_ sender: UIButton) {
        
        if self.starState == K.StarState.notSelected{
            addFavoriteCityInDB()
        }else if self.starState == K.StarState.selected{
            deleteFavoriteCityFromDB()
        }
    }
    
    // Add the favorite city in DB
    func addFavoriteCityInDB(){
        self.favoriteButton.setImage( UIImage(named: K.Image.imgStarFilled), for: .normal)
        let city = City()
        city.name = (self.weatherInfo?.cityName)!
        city.weather = self.weatherInfo
        DBManager.sharedInstance.addCity(object: city)
        
        self.starState = K.StarState.selected
    }
    
    // Delete the city from the favorite city in DB
    func deleteFavoriteCityFromDB(){
        self.favoriteButton.setImage( UIImage(named: K.Image.imgStarEmty), for: .normal)
        let cityName = self.weatherInfo?.cityName
        
        DBManager.sharedInstance.deleteCityByName(cityName: cityName!)
        
        self.starState = K.StarState.notSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diplayWetherInformations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpFavoriteImage()
        self.cityReceived = (self.weatherInfo?.cityName)!
    }
    
    func setUpFavoriteImage(){
        if (DBManager.sharedInstance.cityExistedInDB(cityName: cityReceived)) {
            self.starState = K.StarState.selected
            self.favoriteButton.setImage( UIImage(named: K.Image.imgStarFilled), for: .normal)
        }else{
            self.starState = K.StarState.notSelected
            self.favoriteButton.setImage( UIImage(named: K.Image.imgStarEmty), for: .normal)
        }
    }

    
    // Display the weather information in the view
    func diplayWetherInformations() {
        guard let weatherInfo = weatherInfo else {
            return
        }
        //!!!!
        self.cityName.text = weatherInfo.cityName
        let tmpCelicius = (weatherInfo.infoWeather?.temperature)! - 273.15
        self.temperature.text = "\(Int(round(tmpCelicius)))°"
        self.wind.text = "\(weatherInfo.wind?.speed ?? 0.0) m/s"
        self.humidity.text = "\(weatherInfo.infoWeather?.humidity ?? 0) %"
        self.cloudCover.text = "\(weatherInfo.clouds?.clouds ?? 0) %"
        self.weatherDescription.text = weatherInfo.descriptif?.first?.desc
        
        guard let rainLastHours = weatherInfo.rain?.lastHours else{
            self.rain.text = "no rain"
            return
        }
        self.rain.text = "\(rainLastHours)"
    }
    
    // Update information when the phone is shaken
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            guard let city = self.weatherInfo?.cityName else{
                return
            }
            WeatherRequestService.getWeather(params: [K.ServiceWeatherKeys.cityNameKey : city]) { (weather, error) in
                self.weatherInfo = weather
                
                guard self.weatherInfo != nil else{
                    return
                }
            }
            diplayWetherInformations()
        }
    }
}


