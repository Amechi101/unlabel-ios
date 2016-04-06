//
//  UnlabelAPIHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 06/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class UnlabelAPIHelper{
    
    class func getBrands(success:([Brand])->(),failed:(error:NSError)->()){
        let requestURL = GET_LABELS_URL.encodedURL()
        print(requestURL)
        Alamofire.request(.GET, GET_LABELS_URL.encodedURL()).responseJSON { response in
            switch response.result {
                
            case .Success(let data):
                let json = JSON(data)
                print(json)
                if let arrBrands = getBrandModels(fromJSON: json){
                    success(arrBrands)
                }else{
                    failed(error: NSError(domain: "No brand found", code: 0, userInfo: nil))
                }
                
                
            case .Failure(let error):
                failed(error: error)
            }
        }
    }
    
    class func getBrandModels(fromJSON json:JSON)->[Brand]?{
        var arrBrands = [Brand]()
        
        if let brandList = json.dictionaryObject![PRM_LABELS]{
            for thisBrand in brandList as! [[String:AnyObject]]{
                let brand = Brand()
                
                
                if let id = thisBrand[PRM_ID]{
                    brand.ID = id as! String
                }
                
                if let featureImage = thisBrand[PRM_BRAND_FEATURE_IMAGE]{
                    brand.FeatureImage = featureImage as! String
                }
                
                if let description = thisBrand[PRM_BRAND_DESCRIPTION]{
                    brand.Description = description as! String
                }
                
                if let name = thisBrand[PRM_BRAND_NAME]{
                    brand.Name = name as! String
                }
                
                if let stateOrCountry = thisBrand[PRM_BRAND_ORIGIN_STATE_OR_COUNTRY]{
                    brand.StateOrCountry = stateOrCountry as! String
                }
                
                if let createdDate = thisBrand[PRM_CREATED]{
                    brand.CreatedDate = createdDate as! String
                }
                
                if let originCity = thisBrand[PRM_ORIGIN_CITY]{
                    brand.OriginCity = originCity as! String
                }
                
                if let _ = thisBrand[PRM_PRODUCTS]{
                    print("products need to set *******")
                }
                
                if let menswear = thisBrand[PRM_MENSWEAR]{
                    brand.Menswear = menswear as! Bool
                }
                
                if let jewelry = thisBrand[PRM_JEWELRY]{
                    brand.Jewelry = jewelry as! Bool
                }
                
                if let accessories = thisBrand[PRM_ACCESSORIES]{
                    brand.Accessories = accessories as! Bool
                }
                
                if let shoes = thisBrand[PRM_SHOES]{
                    brand.Shoes = shoes as! Bool
                }
                
                if let isActive = thisBrand[PRM_IS_ACTIVE]{
                    brand.isActive = isActive as! Bool
                }
                
                if let bags = thisBrand[PRM_BAGS]{
                    brand.Bags = bags as! Bool
                }
                
                if let clothing = thisBrand[PRM_CLOTHING]{
                    brand.Clothing = clothing as! Bool
                }
                
                if let womenswear = thisBrand[PRM_WOMENSWEAR]{
                    brand.Womenswear = womenswear as! Bool
                }
                
                arrBrands.append(brand)
            }
            
            return arrBrands
        }else{
            return nil
        }
    }
    
}