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
    static let sharedInstance = UnlabelAPIHelper()
    
    //If need single brand then pass brand ID else will return all brands
    func getBrands(brandId:String?,success:([Brand])->(),failed:(error:NSError)->()){
        let requestURL:String?
        if let brandIdObj = brandId {
            requestURL = "\(URL_PREFIX)\(brandIdObj)/\(URL_POSTFIX)".encodedURL()
        }else{
            requestURL = GET_LABELS_URL.encodedURL()
        }
        
        print(requestURL)
        
        if let requestURLObj = requestURL{
            Alamofire.request(.GET, requestURLObj).responseJSON { response in
                switch response.result {
                    
                case .Success(let data):
                    let json = JSON(data)
                    debugPrint(json)
                    if let arrBrands = self.getBrandModels(fromJSON: json){
                        success(arrBrands)
                    }else{
                        failed(error: NSError(domain: "No brand found", code: 0, userInfo: nil))
                    }
                    
                    
                case .Failure(let error):
                    failed(error: error)
                }
            }
        }
    }
    
    func getBrandModels(fromJSON json:JSON)->[Brand]?{
        var arrBrands = [Brand]()
        
        if let brandList = json.dictionaryObject![PRM_LABELS]{
            
            for (index,thisBrand) in (brandList as! [[String:AnyObject]]).enumerate(){
                let brand = Brand()
                
                brand.currentIndex = index
                
                if let isActive = thisBrand[PRM_IS_ACTIVE] as? Bool{
                    brand.isActive = isActive
                }
                
                //Add only active brands
                if brand.isActive{
                    
                    if let id = thisBrand[PRM_ID] as? String {
                        brand.ID = id
                    }
                    
                    if let featureImage = thisBrand[PRM_BRAND_FEATURE_IMAGE] as? String{
                        brand.FeatureImage = featureImage
                    }
                    
                    if let description = thisBrand[PRM_BRAND_DESCRIPTION] as? String{
                        brand.Description = description
                    }
                    
                    if let name = thisBrand[PRM_BRAND_NAME] as? String{
                        brand.Name = name
                    }
                    
                    if let stateOrCountry = thisBrand[PRM_BRAND_ORIGIN_STATE_OR_COUNTRY] as? String{
                        brand.StateOrCountry = stateOrCountry
                    }
                    
                    if let createdDate = thisBrand[PRM_CREATED] as? String{
                        brand.CreatedDateString = createdDate
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let newDateString:String = String(brand.CreatedDateString.characters.prefix(10))
                        if let createdDate = dateFormatter.dateFromString(newDateString){
                            brand.CreatedDate = createdDate
                        }
                    }
 
                    if let originCity = thisBrand[PRM_ORIGIN_CITY] as? String{
                        brand.OriginCity = originCity
                    }
                    
                    if let brandWebsiteURL = thisBrand[PRM_BRAND_WEBSITE_URL] as? String{
                        brand.BrandWebsiteURL = brandWebsiteURL
                    }
                    
                    if let arrProducts:[[String : AnyObject]] = thisBrand[PRM_PRODUCTS] as? [[String : AnyObject]]{
                        brand.arrProducts = getProductsArrayFromJSON(arrProducts)
                    }
                    
                    if let menswear = thisBrand[PRM_MENSWEAR] as? Bool{
                        brand.Menswear = menswear
                    }
                    
                    if let jewelry = thisBrand[PRM_JEWELRY] as? Bool{
                        brand.Jewelry = jewelry
                    }
                    
                    if let accessories = thisBrand[PRM_ACCESSORIES] as? Bool{
                        brand.Accessories = accessories
                    }
                    
                    if let shoes = thisBrand[PRM_SHOES] as? Bool{
                        brand.Shoes = shoes
                    }
                    
                    if let bags = thisBrand[PRM_BAGS] as? Bool{
                        brand.Bags = bags
                    }
                    
                    if let clothing = thisBrand[PRM_CLOTHING] as? Bool{
                        brand.Clothing = clothing
                    }
                    
                    if let womenswear = thisBrand[PRM_WOMENSWEAR] as? Bool{
                        brand.Womenswear = womenswear
                    }
                    
                    arrBrands.append(brand)
                }
            }
            
            //Sorting arrBrands by created date
//            arrBrands.sortInPlace({ $0.CreatedDate.compare($1.CreatedDate) == NSComparisonResult.OrderedDescending })
            
            return arrBrands
        }else{
            return nil
        }
    }
    
    func getProductsArrayFromJSON(arrProductsJSON:[[String:AnyObject]])->[Product]{
        var arrProducts = [Product]()
        
        for product in arrProductsJSON{
            let productObj = Product()
            
            if let isActive:Bool = product[PRM_PRODUCTIS_ACTIVE] as? Bool{
                productObj.isActive = isActive
            }
            
            //Add only active products
            if productObj.isActive{
                
                if let productURL:String = product[PRM_PRODUCT_URL] as? String{
                    productObj.ProductURL = productURL
                }
                
                if let brandID:String = product[PRM_BRAND_ID] as? String{
                    productObj.BrandID = brandID
                }
                
                if let productImage:String = product[PRM_PRODUCT_IMAGE] as? String{
                    productObj.ProductImage = productImage
                }
                
                if let productName:String = product[PRM_PRODUCT_NAME] as? String{
                    productObj.ProductName = productName
                }
                
                if let productPrice:String = product[PRM_PRODUCT_PRICE] as? String{
                    productObj.ProductPrice = productPrice
                }
                
                arrProducts.append(productObj)
            }
        }
        
        return arrProducts
    }
    
}