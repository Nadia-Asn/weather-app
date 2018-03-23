//
//  CitiesTableViewController.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 13/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//
import UIKit
import RealmSwift

class CitiesTableViewController: UITableViewController {
    
    var weatherInfo: Weather?
    
    var cityName: String = ""
    var cities: Results<City>?
    
    var dataSource: UITableViewDataSource?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities = DBManager.sharedInstance.getCitiesFromDb()

        // TODO : utiliser CellCity par la suite
        tableView.register(UINib.init(nibName: CellCityIdentifier, bundle: nil), forCellReuseIdentifier: CellCityIdentifier)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellCityIdentifier) //!!!
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.StoryBoardSegue.detail{
            redirectDetailsView(segue: segue)
        }
    }
    
    func redirectDetailsView(segue: UIStoryboardSegue){
        
        if let detailsVC = segue.destination as? DetailsViewController{
            detailsVC.weatherInfo = self.weatherInfo
            detailsVC.cityReceived = (self.weatherInfo?.cityName)!
        }
    }
    
    /// A mettre dans cityCell
    
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
    

}

extension CitiesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCityIdentifier, for: indexPath) //!!! type ?
        let cellIndex = indexPath.row
        return setUpCellContent(indexCell: cellIndex, city: self.cities![cellIndex], cell: cell)
    }
    
    
}
