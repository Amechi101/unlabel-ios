//
//  GAHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum GAEventType:String{
  case LabelClicked = "Label Clicked"
  case ProductClicked = "Product Clicked"
  case BuyLabelClicked = "Buy Product Clicked"
}
class GAHelper: NSObject {
  class func trackEvent(_ eventType:GAEventType ,labelName:String, productName:String?,buyProductName:String?){
    let tracker = GAI.sharedInstance().defaultTracker
    if eventType == .LabelClicked{
      
      let build = GAIDictionaryBuilder.createEvent(withCategory: "Label", action: GAEventType.LabelClicked.rawValue, label: labelName, value: 1).build() as [NSObject : AnyObject]
      tracker?.send(build)
      
      //     tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Label", action: GAEventType.LabelClicked.rawValue, label: labelName, value: 1).build() as [AnyHashable: Any])
    }else if eventType == .ProductClicked{
      if let productNameValue = productName {
        
        let build = GAIDictionaryBuilder.createEvent(withCategory: "Product", action: GAEventType.ProductClicked.rawValue, label: productNameValue, value: 1).build() as [NSObject : AnyObject]
        tracker?.send(build)
        // tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Product", action: GAEventType.ProductClicked.rawValue, label: productNameValue, value: 1).build() as [AnyHashable: Any])
      }
    }else if eventType == .BuyLabelClicked{
      if let buyProductNameValue = buyProductName {
        
        let build = GAIDictionaryBuilder.createEvent(withCategory: "Product", action: GAEventType.BuyLabelClicked.rawValue, label: buyProductNameValue, value: 1).build() as [NSObject : AnyObject]
        tracker?.send(build)
        
        
        //    tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Product", action: GAEventType.BuyLabelClicked.rawValue, label: buyProductNameValue, value: 1).build() as [AnyHashable: Any])
      }
    }else{
      
    }
    let build = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
    tracker?.send(build)
    // let builder = GAIDictionaryBuilder.createScreenView()
    //  tracker?.send(builder?.build() as [AnyHashable: Any])
  }
}
