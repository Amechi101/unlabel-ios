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

    var ProductImageName:String = String() // As this should be unique in S3, using it as hashKeyAttribute
    var ProductName:String = String()
    var BrandID:String = String()
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