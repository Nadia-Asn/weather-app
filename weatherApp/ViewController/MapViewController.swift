//
//  MapViewController.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 15/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000000
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 34.686667, longitude: -1.911389)
        
        //mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsView" {
            _ = segue.destination as! DetailsViewController
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // show favorite cities on the map
        makeFavoriteCitiesOnTheMap()
        _ = mapView.dequeueReusableAnnotationView(withIdentifier: "oujda")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func makeFavoriteCitiesOnTheMap(){
        let listCities = DBManager.sharedInstance.getCitiesFromDb()
        for i in listCities{
            let latitude = i.weather?.coord?.lat
            let longitude = i.weather?.coord?.lon
            let name = i.weather?.cityName
            let cityMap = CityMap(title: name!,
                                  coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            
            mapView.addAnnotation(cityMap)
            mapView.selectAnnotation(cityMap, animated: true)
        }
        print ( "All favorite cities : " , listCities.description)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "detailsView", sender: self)
    }
}
