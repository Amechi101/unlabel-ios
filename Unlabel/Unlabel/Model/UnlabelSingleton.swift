//
//  UnlabelSingleton.swift
//  Unlabel
//
//  Created by SayOne on 16/06/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class UnlabelSingleton: NSObject {
    static let sharedInstance = UnlabelSingleton()
    var radiusFilter : String? = "10"
    var telePhoneCodes:[UnlabelStaticList]? = []
    

}
