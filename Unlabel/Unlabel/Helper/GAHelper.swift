//
//  GAHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 11/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class GAHelper: NSObject {
    class func trackBrandClicked(brandName brandName:String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Label Name")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
