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
    
    var sc: SearchViewController?
    var scc = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        return self.cities.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let index = indexPath.row
        return setUpCellContent(indexCell: index, city: cities[index], cell: cell)
     }
    
    func setUpCellContent(indexCell: Int, city: City, cell: UITableViewCell) -> UITableViewCell{
        if indexCell % 2 == 0 {
            cell.textLabel?.text = city.weather?.cityName
            cell.textLabel?.textColor = UIColor.brown
            cell.backgroundColor = UIColor(red: 248/255, green: 234/255, blue: 227/255, alpha: 1)
            return cell
        }else{
            cell.textLabel?.text = city.weather?.cityName
            cell.textLabel?.textColor = UIColor.brown
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cityName = cities[indexPath.row].weather?.cityName else{
            return
        }
        
        WeatherRequestService.getWeather(params: ["q" : cityName]) { (weather, error) in
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
