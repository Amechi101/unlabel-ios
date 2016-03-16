//
//  DynamoDB_Brand.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 04/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDB_Brand: AWSDynamoDBObjectModel,AWSDynamoDBModeling {
    
    var BrandID:String = String()
    var BrandName:String = String()
    var Description:String = String()
    var Location:String = String()
    var ImageName:String = String()
    var isActive:Bool = Bool()

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

    
    //Other filters should be added here. i.e. styles etc...
    
    static func dynamoDBTableName() -> String! {
        return "DynamoDB_Brand"
    }
    
    static func hashKeyAttribute() -> String! {
        return "BrandID"
    }
}