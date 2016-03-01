//
//  Filter.swift
//  Unlabel
//
//  Created by Zaid Pathan on 01/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class Filter: NSObject {
    //Sex
    var Male:Bool = Bool()
    var Female:Bool = Bool()
    
    //Categories
    var AllCategories:Bool = Bool()               //i.e. All Categories
    var Clothing:Bool = Bool()
    var Accessories:Bool = Bool()
    var Jewelry:Bool = Bool()
    var Shoes:Bool = Bool()
    var Bags:Bool = Bool()
    
    //Locations
    var arrLocations:[String] = []
}
