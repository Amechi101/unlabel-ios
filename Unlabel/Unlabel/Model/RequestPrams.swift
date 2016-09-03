//
//  RequestPrams.swift
//  Unlabel
//
//  Created by Zaid Pathan on 14/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

//RequestParams
class FetchBrandsRP: NSObject {
    var brandGender:BrandGender?
    var selectedTab:FilterType = .Men //Not used in request params but in response handling because of async.
    var filterLocation:String?
    var filterCategory:String?
   var filterStyle:String?
    var nextPageURL:String?
    var brandId:String?
}
