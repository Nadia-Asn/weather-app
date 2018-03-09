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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var buttonState = "notSelected"
    
    
    @IBAction func favoriteButtonTaped(_ sender: UIButton) {
        
        
        // JSON file
        
        // Get the json file path
        guard let jsonFilePath = Bundle.main.path(forResource: "favoriteCities", ofType: "json")else{
            return
        }
        
        // get the json file url
        let urlJsonFile = URL(fileURLWithPath: jsonFilePath)
        print(urlJsonFile)
        
        guard let pathtoto = Bundle.main.path(forResource: "toto", ofType: "json")else{
            return
        }
        
        // get the json file url
        let urltoto = URL(fileURLWithPath: pathtoto)
        print(urlJsonFile)
        
        // get the data from file
        let data = try! Data(contentsOf: urlJsonFile)
        var diction1 = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String>
        
        diction1?.updateValue("tototototo", forKey: "koukouu")
        print("diction1 append : " , diction1)
        
  /*
        let jsonData = try! JSONSerialization.data(withJSONObject: diction1, options: .prettyPrinted)
        try! jsonData.write(to: urltoto)
        
        //dictionnary.write(to: urltoto, atomically: true)
        
        let jsonAfter = NSDictionary(contentsOf: urltoto)
        if let str2 = jsonAfter?.value(forKey: "city4") {
            print ( str2 as? String ?? "<#default value#>")
        }
        */
        //var data2 = try! Data(contentsOf: urltoto)
        
        // On recupère un objet de type JSON data et on le caste en dictionnaire de string
        //let dictionFinal = try! JSONSerialization.jsonObject(with: data2, options: []) as! Dictionary<String, String>
        
        //print(" resultat final json : " , dictionFinal)
    
        /*
        let dd = try! Data(contentsOf: urlJsonFile)
        let tt = try! JSONSerialization.jsonObject(with: dd, options: [])
        let rr = (tt as AnyObject).description
        let vv = rr?.data(using: String.Encoding.utf8)!
        
        if let file = FileHandle(forWritingAtPath:jsonFilePath) {
            file.write(vv!)
            print("content of file : ", file.availableData)
        }
        
        
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDir = dirPaths[0].path
        
        print ("directory = " , docsDir)
        if filemgr.changeCurrentDirectoryPath(docsDir) {
            // Success
        } else {
            // Failure
        }
        
        
        if FileManager.default.fileExists(atPath: docsDir){
            var err:NSError?
            //if let fileHandle = FileHandle(fileDescriptor: docsDir, closeOnDealloc: &err){
                
         }
        */
        
        if self.buttonState == "notSelected"{
            favoriteButton.setImage( UIImage(named: "starRempli"), for: .normal)
            self.buttonState = "selected"
        }else if self.buttonState == "selected"{
            self.favoriteButton.setImage( UIImage(named: "starVide"), for: .normal)
            self.buttonState = "notSelected"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonState = "notSelected"
        cityName.text = cityReceived
        country.text = weatherInfo?.sys?.country
        temperature.text = weatherInfo?.cityName
        wind.text = "\(weatherInfo?.wind?.degree ?? 0)"
        cloudCover.text = "\(weatherInfo?.clouds.all  ?? 0) %"
        let tmpCelicius = (weatherInfo?.info.temperature)! - 273.15
        temperature.text = "\(Int(round(tmpCelicius)))°"
        humidity.text = "\(weatherInfo?.info.humidity  ?? 0)"
        weatherDescription.text = weatherInfo?.weather[0].description
        
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

