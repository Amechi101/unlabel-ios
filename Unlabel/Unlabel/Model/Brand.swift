//
//  Brand.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 24/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

//Label == Brand
class Brand {
    var ID:String = String()
    var Name:String = String()
    var OriginCity:String = String()
    var StateOrCountry:String = String()
    var Description:String = String()
    var FeatureImage:String = String()
    var CreatedDateString:String = String()
    var BrandWebsiteURL:String = String()
    var isActive:Bool = Bool()
    var CreatedDate:NSDate = NSDate()
    
    var city:String = String()
    var location:String = String()
    var latitude:String = String()
    var longitude:String = String()
    
    //Sex
    var Menswear:Bool = Bool()
    var Womenswear:Bool = Bool()
    
    //Categories
    var BrandCategory:String = String()
    
    var arrProducts = [Product]()
    
    var isFollowing = false
    var currentIndex = Int()
}
