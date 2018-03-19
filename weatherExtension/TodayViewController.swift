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

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var widgetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print( "lklklklklk" , Book.sharedInstance.display())
        widgetLabel.text = "toto : \(Book.sharedInstance.add(x: 1, y: 2))"
//        let x = DBManager.sharedInstance.getCitiesFromDb()
//        print ( "Cities in database : ")
//        print ( x.description)
//        let y = DBManager.sharedInstance.getCityByName(cityName: "oujda")
//        guard y != nil else {
//            return
//        }
//
//        print ( y.cityId)
        
        // Dispose of any resources that can be recreated.
         //       widgetLabel.text = "knkjkjmj"
                if let x = UserDefaults.init(suiteName: "group.weatherApp")?.value(forKey: "test") {
                    widgetLabel.text = x as? String
                }
        if let x = UserDefaults.init(suiteName: "group.weatherApp")?.value(forKey: "test") {
            if x as? String != widgetLabel.text {
                widgetLabel.text = x as? String
                //var x = DBManager.sharedInstance.getCitiesFromDb()
                //print (x.description)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
