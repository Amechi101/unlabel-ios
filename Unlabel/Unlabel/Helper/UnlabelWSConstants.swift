//
//  UnlabelWSConstants.swift
//  Unlabel
//
//  Created by Zaid Pathan on 06/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation

//http://unlabel.us/unlabel-network/unlabel-network-api/v1/labels/?username=unlabel_us_api&api_key=f54c309313f3bb0f28322f035cfc169c8631faf9

let BASE_URL = "http://unlabel.us/unlabel-network/unlabel-network-api/v1"

let SUB_URL_LABELS = "/labels"

let USERNAME = "unlabel_us_api"
let API_KEY =  "f54c309313f3bb0f28322f035cfc169c8631faf9"

//API URLs
let GET_LABELS_URL = "\(BASE_URL)\(SUB_URL_LABELS)/?\(PRM_USERNAME)=\(USERNAME)&\(PRM_API_KEY)=\(API_KEY)"

let PRM_USERNAME = "username"
let PRM_API_KEY  = "api_key"

let PRM_LABELS              = "labels"
let PRM_ID                  = "id"
let PRM_MENSWEAR            = "menswear"
let PRM_BRAND_FEATURE_IMAGE = "brand_feature_image"
let PRM_BRAND_DESCRIPTION   = "brand_description"
let PRM_BRAND_NAME          = "brand_name"
let PRM_JEWELRY             = "jewelry"
let PRM_ACCESSORIES         = "accessories"
let PRM_SHOES               = "shoes"
let PRM_BRAND_ORIGIN_STATE_OR_COUNTRY = "brand_origin_state_or_country"
let PRM_CREATED               = "created"
let PRM_ORIGIN_CITY           = "brand_origin_city"
let PRM_IS_ACTIVE             = "brand_isActive"
let PRM_PRODUCTS              = "products"
let PRM_BAGS                  = "bags"
let PRM_CLOTHING              = "clothing"
let PRM_WOMENSWEAR            = "womenswear"