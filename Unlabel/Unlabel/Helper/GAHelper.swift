//
//  GAHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

enum GAEventType{
    case LabelClicked
    case ProductClicked
    case BuyLabelClicked
}
class GAHelper: NSObject {
    class func trackEvent(eventType:GAEventType ,labelName:String, productName:String?,buyProductName:String?){
        let tracker = GAI.sharedInstance().defaultTracker
        if eventType == .LabelClicked{
            tracker.set("Label Click", value: labelName)
        }else if eventType == .ProductClicked{
            if let productNameValue = productName {
                tracker.set("Product Click", value: productNameValue)
            }
        }else if eventType == .BuyLabelClicked{
            if let buyProductNameValue = buyProductName {
                tracker.set("Product Buy", value: buyProductNameValue)
            }
        }else{
        
        }
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
