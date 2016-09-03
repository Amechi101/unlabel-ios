//
//  UnlabelWSConstants.swift
//  Unlabel
//
//  Created by Zaid Pathan on 06/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation

//Branch.io
//let branch_key_live = "key_live_jknYG5BuWHoLVcCT92AtTbnfwEmqcrhD"
//let branch_app_domain_live = "u8cw.app.link"
//
//let branch_key_test = "key_test_lakYO8yu4JkGNbCT9XFSMgnesDoDlslG"
//let branch_app_domain_test = "u8cw.test-app.link"


//Unlabel.us URLs
let URL_PRIVACY_POLICY = "https://unlabel.us/privacy-policy/"
let URL_TERMS = "https://unlabel.us/terms/"

//FIREBASE
//let sFIREBASE_URL = "https://glowing-torch-9591.firebaseio.com"
let sFIREBASE_URL = "https://userdata-f2a6b.firebaseio.com"

let sEND_USERS = "/users"

let PRM_USER_ID                     = "userID"
let PRM_EMAIL                       = "email"
let PRM_PHONE                       = "phone"
let PRM_DISPLAY_NAME                = "displayName"
let PRM_PROFILE_IMAGE_URL           = "profileImageURL"
let PRM_PROVIDER                    = "provider"
let PRM_FOLLOWING_BRANDS            = "followingBrands"
let PRM_CURRENT_FOLLOWING_COUNT     = "currentFollowingCount"


//http://localhost:8000/unlabel-network/unlabel-network-api/v1/labels/22123793-2904-4b3f-841e-0db81e717f2b/

//API



struct API{
    //Live
//    static let onlyBaseURL = "https://unlabel.us"
//    static let baseURL = "\(ONLY_BASE_URL)/unlabel-network/unlabel-network-api/v1"
//    static let userName = "unlabel_us_api"
//    static let APIKey = "f54c309313f3bb0f28322f035cfc169c8631faf9"
    
    //Test
    static let onlyBaseURL = "http://unlabel-dev.herokuapp.com"
    static let baseURL = "\(ONLY_BASE_URL)/unlabel-network/labels-api/v3/"
    static let userName = "amechiegbe"
    static let APIKey = "79c86ba48fc323d61a0661f0ca5437fb9245a022"
    
    static let labels       = "labels/"
    static let products     = "products/"
    static let locations    = "locations/"
 
    static let getLabels    = WSConstantFetcher.getFinalURLs(labels)
    static let getProducts  = WSConstantFetcher.getFinalURLs(products)
    static let getLocations = WSConstantFetcher.getFinalURLs(locations)
}


struct APIParams {
    static let brandId          = "id"
    static let labelId          = "label_id"
    static let brandCity        = "brand_city"
    static let brandGender      = "brand_gender"
    static let brandCategory    = "brand_category"
    
    static let city             = "city"
    static let location         = "location"
    static let locations        = "locations"
    static let locationChoices  = "location_choices"
    static let stateOrCountry   = "state_or_country"
    
    static let latitude         = "latitude"
    static let longitude        = "longitude"
    
    static let menswear         = "menswear"
    static let womenswear       = "womenswear"
    
    static let locationChoicesCountry  = "Country"
    static let locationChoicesState    = "State"
}

class WSConstantFetcher{
    class func getFinalURLs(subURL:String)->String{
        return"\(API.baseURL)\(subURL)"
    }
    
    class func getLabelsSubURL(fetchBrandsRP:FetchBrandsRP)->String{
        var subURL = ""
        
        if let brandGender = fetchBrandsRP.brandGender where brandGender != BrandGender.None {
            if fetchBrandsRP.brandGender == BrandGender.Men{
                subURL = "?\(APIParams.menswear)=True"
            } else if fetchBrandsRP.brandGender == BrandGender.Women {
                subURL = "?\(APIParams.womenswear)=True"
            } else { //FIXME: both
               subURL = "?\(APIParams.womenswear)=True&\(APIParams.menswear)=True"
            }
        }
        
        var subSubURL = ""
        if let brandCategory = fetchBrandsRP.filterCategory{
            subSubURL = "&\(APIParams.brandCategory)=\(brandCategory)"
        }
        
        if let location = fetchBrandsRP.filterLocation{
            subSubURL = "\(subSubURL)&\(APIParams.location)=\(location)"
        }
        
        return subURL+subSubURL
    }
    
    class func getProductsSubURL(fetchBrandsRP:FetchBrandsRP)->String{
        var subURL = ""
        
        if let labelId = fetchBrandsRP.brandId where labelId.characters.count > 0{
            subURL = "?\(APIParams.brandId)=\(labelId)"
        }
        
        return subURL
    }
}

//Live
let ONLY_BASE_URL = "https://unlabel.us"
let BASE_URL = "\(ONLY_BASE_URL)/unlabel-network/unlabel-network-api/v1"
let USERNAME = "unlabel_us_api"
let API_KEY =  "f54c309313f3bb0f28322f035cfc169c8631faf9"

//Dev
//let ONLY_BASE_URL = "http://unlabel-dev.herokuapp.com"
//let BASE_URL = "\(ONLY_BASE_URL)/unlabel-network/labels-api/v3/Devlabels/"
//let USERNAME = "amechiegbe"
//let API_KEY =  "79c86ba48fc323d61a0661f0ca5437fb9245a022"


let SUB_URL_LABELS = "/labels"

//API URLs
let URL_PREFIX = "\(BASE_URL)\(SUB_URL_LABELS)/"
let URL_POSTFIX = "&\(PRM_USERNAME)=\(USERNAME)&\(PRM_API_KEY)=\(API_KEY)"
let GET_LABELS_URL = "\(URL_PREFIX)\(URL_POSTFIX)"

let PRM_USERNAME = "username"
let PRM_API_KEY  = "api_key"

let PRM_LABELS              = "labels"
let PRM_ID                  = "id"
let PRM_MENSWEAR            = "menswear"
let PRM_BRAND_FEATURE_IMAGE = "brand_feature_image"
let PRM_BRAND_DESCRIPTION   = "brand_description"
let PRM_BRAND_NAME          = "brand_name"
let PRM_BRAND_CATEGORY      = "brand_category"
let PRM_BRAND_ORIGIN_STATE_OR_COUNTRY = "brand_location"
let PRM_CREATED               = "created"
let PRM_ORIGIN_CITY           = "brand_city"
let PRM_IS_ACTIVE             = "brand_isActive"
let PRM_PRODUCTS              = "products"
let PRM_WOMENSWEAR            = "womenswear"

let PRM_PRODUCT_URL           = "product_url"
let PRM_BRAND_ID              = "brand_id"
let PRM_PRODUCT_IMAGE         = "product_image"
let PRM_PRODUCTIS_ACTIVE      = "product_isActive"
let PRM_PRODUCT_NAME          = "product_name"
let PRM_PRODUCT_PRICE         = "product_price"
let PRM_BRAND_WEBSITE_URL     = "brand_website_url"

let PRM_PRODUCTIS_IS_UNISEX     = "product_isUnisex"
let PRM_PRODUCTIS_IS_MALE       = "product_isMale"
let PRM_PRODUCTIS_IS_FEMALE     = "product_isFemale"

let PRM_brand_city__location__state_or_country     = "brand_city__location__state_or_country"

