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
    var ISBN:String = String()
//    var imgBrandImage:UIImage = UIImage()
    var sBrandName:String = String()
    var sDescription:String = String()
    var sLocation:String = String()
    
    static func dynamoDBTableName() -> String! {
        return "Unlabel_Brand"
    }
    
    static func hashKeyAttribute() -> String! {
        return "ISBN"
    }
}
