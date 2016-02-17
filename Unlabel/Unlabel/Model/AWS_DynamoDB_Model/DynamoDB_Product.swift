//
//  DynamoDB_Product.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDB_Product: AWSDynamoDBObjectModel,AWSDynamoDBModeling {

    var BrandName:String = String()
    var ProductName:String = String()
    var ProductImageName:String = String()
    var ProductPrice:CGFloat = CGFloat()
    var ProductURL:String = String()
    var isActive:Bool = Bool()
    
    static func dynamoDBTableName() -> String! {
        return "DynamoDB_Product"
    }
    
    static func hashKeyAttribute() -> String! {
        return "ProductImageName"
    }
}