//
//  DynamoDB_Brand.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 04/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Foundation
import AWSDynamoDB

class DynamoDB_Brand: AWSDynamoDBObjectModel,AWSDynamoDBModeling {
    
    var BrandName:String = String()
    var Description:String = String()
    var Location:String = String()
    var ImageName:String = String()
    var isActive:Bool = Bool()
    
    static func dynamoDBTableName() -> String! {
        return "DynamoDB_Brand"
    }
    
    static func hashKeyAttribute() -> String! {
        return "BrandName"
    }
}
