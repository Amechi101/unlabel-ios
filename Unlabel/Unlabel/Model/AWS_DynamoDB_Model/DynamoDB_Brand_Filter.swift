//
//  DynamoDB_Brand_Filter.swift
//  Unlabel
//
//  Created by Zaid Pathan on 19/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSDynamoDB

class DynamoDB_Brand_Filter: AWSDynamoDBObjectModel,AWSDynamoDBModeling {
    
    var BrandID:String = String()
    
    //Categories
    var All:Bool = Bool()               //i.e. All Categories
    var Clothing:Bool = Bool()
    var Accessories:Bool = Bool()
    var Jewelry:Bool = Bool()
    var Shoes:Bool = Bool()
    var Bags:Bool = Bool()
    
    //Sex
    var Male:Bool = Bool()
    var Female:Bool = Bool()
    
    //Other filters should be added here. i.e. styles etc...
    
    static func dynamoDBTableName() -> String! {
        return "DynamoDB_Brand"
    }
    
    static func hashKeyAttribute() -> String! {
        return "BrandID"
    }
}	