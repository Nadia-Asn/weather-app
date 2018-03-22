//
//  TodayViewController.swift
//  weatherEcitiestension
//
//  Created by Ahassouni, Nadia on 16/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import Foundation
import NotificationCenter
import Realm
import RealmSwift


/*
    View controller which represent the today extension (widget) of the weather application
*/
class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource {
    
    
    @IBOutlet var myTableView: UITableView!
    
    // Realm notification token
    var notifToken: RLMNotificationToken? = nil
    
    let realm = try! Realm()
    
    var cellSize: Int = 0
    
    let DB = DBManager.sharedInstance
    let cities = DBManager.sharedInstance.getCitiesFromDb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(UINib.init(nibName: CellCityIdentifier, bundle: nil), forCellReuseIdentifier: CellCityIdentifier)
        myTableView.dataSource = self
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let citiesInDatabase = DBManager.sharedInstance.getCitiesFromDb()
        getNotifications(cities: citiesInDatabase)

    }
    

    /// Get notification when the Realm database was changed
    ///
    /// - Parameter cities: Collection of the current cities in database
    func getNotifications(cities: Results<City>){
        self.notifToken = cities.observe { changes in
            switch changes {
            case .initial:
                print ( " ------> initial ")
            case .update:
                print ("-----> database updated")
            case .error(let error):
                fatalError("-----> \(error)")
            }
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .expanded {
            self.preferredContentSize.height = CGFloat(self.cities.count * self.cellSize)
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: 0.0, height: 200.0)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
                completionHandler(NCUpdateResult.newData)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cities.count)
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellCityIdentifier, for: indexPath) as? CellCity else{
            fatalError("Cell is not instance of CellCity")
        }
        
        let cellIndex  = indexPath.row
        let tmpCelicius = (cities[cellIndex].weather?.infoWeather?.temperature)! -  273.15
        cell.cityName.text = cities[cellIndex].weather?.cityName
        cell.weatherDegree.text = "\(Int(round(tmpCelicius)))°"
        
        self.cellSize = Int(cell.bounds.height)
        
        return cell

    }
}



