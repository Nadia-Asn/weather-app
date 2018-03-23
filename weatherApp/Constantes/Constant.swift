//
//  Constant.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 22/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation

struct K {
    struct StoryBoardSegue {
        static let detail = "detailsView"
        static let favoriteCities = "favoriteCities"
    }
    struct ServiceWeatherKeys {
        static let cityNameKey = "q"
        static let latitudeKey = "lat"
        static let longitudeKey = "lon"
        static let appId = "APPID"
    }
    
    struct Initialisation {
        struct LocationMap {
            static let latitude = 34.686667
            static let longitude = -1.911389
            static let regionRadius = 1000000
        }
    }
   

    struct Image {
        static let imgStarEmty = "starVide"
        static let imgStarFilled = "starRempli"
    }
    struct StarState {
        static let selected = "selected"
        static let notSelected = "notSelected"
    }
    
    struct Identifier {
        struct application {
            static let ApplicationGroup = "group.com.pictime.test2"
        }
    }
    
    struct API {
        struct Weather{
            static let url = "http://api.openweathermap.org/data/2.5/weather"
            static let key = "440641e20987cefb9bd803e6e48a9444"
        }
    }
}
