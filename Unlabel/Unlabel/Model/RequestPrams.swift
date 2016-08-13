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
    var brandCategory:BrandCategory?
    var location:String?
    var nextPageURL:String?
    var brandId:String?
}
