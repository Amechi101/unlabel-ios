//
//  DynamoDB_Label.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDB_Label: AWSDynamoDBObjectModel,AWSDynamoDBModeling {

    var BrandName:String = String()
    var LabelName:String = String()
    var LabelImageName:String = String()
    var LabelPrice:CGFloat = CGFloat()
    var LabelURL:String = String()
    var isActive:Bool = Bool()
    
    static func dynamoDBTableName() -> String! {
        return "DynamoDB_Label"
    }
    
    static func hashKeyAttribute() -> String! {
        return "LabelImageName"
    }
}