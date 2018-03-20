//
//  TodayViewController.swift
//  weatherExtension
//
//  Created by Ahassouni, Nadia on 16/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import Foundation
import NotificationCenter
import Realm
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource {
    
    
    @IBOutlet var myTableView: UITableView!
    
    var notifToken: RLMNotificationToken? = nil
    var notificationRunLoop: CFRunLoop? = nil
    
    let realm = try! Realm()
    
    var notif = Notifications()
    
    let DB = DBManager.sharedInstance
    let x = DBManager.sharedInstance.getCitiesFromDb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let citiesInDatabase = DBManager.sharedInstance.getCitiesFromDb()
        
        getNotifications(cities: citiesInDatabase)
        
        
        myTableView.register(UINib.init(nibName: CellJoseIdentifier, bundle: nil), forCellReuseIdentifier: CellJoseIdentifier)
        myTableView.dataSource = self
    }
    
    func getNotifications(cities: Results<City>){
        self.notifToken = cities.observe { changes in
            switch changes {
            case .initial:
                print ( " ------> initial ")
                
            case .update(_, let deletions, let insertions, let modifications):
                print ("-----> del " , deletions.count)
                print ("-----> inse " , insertions.count)
                print ("-----> modi " , modifications.count)
            case .error(let error):
                fatalError("-----> \(error)")
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
                completionHandler(NCUpdateResult.newData)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(x.count)
        return self.x.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellJoseIdentifier, for: indexPath) as? CellJose else{
            fatalError("Cell is not instance of CityTableViewCell")
        }
        
        let cellIndex = indexPath.row
        
        cell.title1.text = x[cellIndex].weather?.cityName
        cell.title2.text = "\(x[cellIndex].weather?.wind?.degree ?? 0)"
        
        return cell
        
        
        
    }
}



