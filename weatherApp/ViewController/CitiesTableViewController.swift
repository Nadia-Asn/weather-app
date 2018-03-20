//
//  CitiesTableViewController.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 13/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//
import UIKit

class CitiesTableViewController: UITableViewController {
    
    var weatherInfo: Weather?
    
    var x: String = ""
    let cities = DBManager.sharedInstance.getCitiesFromDb()
    var dataSource: UITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // update tableView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "weatherFavoriteCity"{
            let detailsController = segue.destination as! DetailsViewController
            detailsController.weatherInfo = self.weatherInfo
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let index = indexPath.row
        let city = cities[index]
        if index % 2 == 0 {
            cell.textLabel?.text = city.weather?.cityName
            cell.textLabel?.textColor = UIColor.brown
            cell.backgroundColor = UIColor(red: 248/255, green: 234/255, blue: 227/255, alpha: 1)
        }else{
            cell.textLabel?.text = city.weather?.cityName
            cell.textLabel?.textColor = UIColor.brown
        }
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // API weather contantes
        let urlAPI = "http://api.openweathermap.org/data/2.5/weather"
        let apiKey = "440641e20987cefb9bd803e6e48a9444"
        
        print (" un item a été séléctionné : " , indexPath.row)
        
        guard let cityName = cities[indexPath.row].weather?.cityName else{
            return
        }
        
        guard let weatherRequestURL = NSURL(string: "\(urlAPI)?APPID=\(apiKey)&q=\(cityName)") else {
            return
        }
        
        WeatherService.getWeather(url: weatherRequestURL) { (weather, error) in
            self.weatherInfo = weather
            guard self.weatherInfo != nil else{
                print ("Error !!")
                return
            }
            DispatchQueue.main.sync {
                self.performSegue(withIdentifier: "weatherFavoriteCity", sender: self)

            }
        }
    }
}
