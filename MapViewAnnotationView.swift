//
//  MapViewAnnotationView.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 15/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import MapKit

class MapAnnotationView: MKAnnotationView {
//    // data
//
//    override var annotation: MKAnnotation? {
//        willSet { customCalloutView?.removeFromSuperview() }
//    }
//
//    // MARK: - life cycle
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        self.canShowCallout = false // 1
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.canShowCallout = false // 1
//    }
//
//    // MARK: - callout showing and hiding
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected { // 2
//            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
//
//            if let newCustomCalloutView = loadPersonDetailMapView() {
//                // fix location from top-left to its right place.
//                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
//                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
//
//                // set custom callout view
//                self.addSubview(newCustomCalloutView)
//                self.customCalloutView = newCustomCalloutView
//
//                // animate presentation
//                if animated {
//                    self.customCalloutView!.alpha = 0.0
//                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
//                        self.customCalloutView!.alpha = 1.0
//                    })
//                }
//            }
//        } else { // 3
//            if customCalloutView != nil {
//                if animated { // fade out animation, then remove it.
//                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
//                        self.customCalloutView!.alpha = 0.0
//                    }, completion: { (success) in
//                        self.customCalloutView!.removeFromSuperview()
//                    })
//                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
//            }
//        }
//    }
//
//    func loadPersonDetailMapView() -> UIView? { // 4
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 280))
//        return view
//    }
//
//    override func prepareForReuse() { // 5
//        super.prepareForReuse()
//        self.customCalloutView?.removeFromSuperview()
//    }
}
