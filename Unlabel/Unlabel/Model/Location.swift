//
//  Location.swift
//  Unlabel
//
//  Created by Zaid Pathan on 20/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import ObjectMapper

class Location: Mappable {
    var locationChoices: String?
    var stateOrCountry: String?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        locationChoices     <- map[APIParams.locationChoices]
        stateOrCountry      <- map[APIParams.stateOrCountry]
    }
}
