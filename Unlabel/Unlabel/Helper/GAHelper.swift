//
//  GAHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

enum GAEventType:String{
    case LabelClicked = "Label Clicked"
    case ProductClicked = "Product Clicked"
    case BuyLabelClicked = "Buy Product Clicked"
}
class GAHelper: NSObject {
    class func trackEvent(eventType:GAEventType ,labelName:String, productName:String?,buyProductName:String?){
        let tracker = GAI.sharedInstance().defaultTracker
        if eventType == .LabelClicked{
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Label", action: GAEventType.LabelClicked.rawValue, label: labelName, value: 1).build() as [NSObject:AnyObject])
        }else if eventType == .ProductClicked{
            if let productNameValue = productName {
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Product", action: GAEventType.ProductClicked.rawValue, label: productNameValue, value: 1).build() as [NSObject:AnyObject])
            }
        }else if eventType == .BuyLabelClicked{
            if let buyProductNameValue = buyProductName {
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Product", action: GAEventType.BuyLabelClicked.rawValue, label: buyProductNameValue, value: 1).build() as [NSObject:AnyObject])
            }
        }else{
        
        }
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
