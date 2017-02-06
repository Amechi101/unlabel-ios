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
import ObjectMapper

class UnlabelAPIHelper{
  
  //Mark: - Singleton
  
  static let sharedInstance = UnlabelAPIHelper()
  
  
  //Mark: - Old API method
  
  func getSingleBrand(_ fetchBrandsRP:FetchBrandsRP, success:@escaping (Brand, _ meta:JSON)->(),failed:@escaping (_ error:NSError)->()) {
    var requestURL:String?
    
    if let brandId = fetchBrandsRP.brandId, brandId.characters.count > 0 {
      requestURL = "\(API.getLabels)\(WSConstantFetcher.getProductsSubURL(fetchBrandsRP))\(URL_POSTFIX)".encodedURL()
    }
    if let requestURLObj = requestURL {
      Alamofire.request(requestURLObj+"get").responseJSON { (response) in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          let meta = json["meta"]
          if let brand = self.getBrandModels(fromJSON: json)?.first {
            success(brand, meta)
          }else{
            failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  
  //If need single brand then pass brand ID else will return all brands
  func getBrands(_ fetchBrandsRP:FetchBrandsRP, success:@escaping ([Brand], _ meta:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    //If brandId exist in request , that means requesting products
    if let brandId = fetchBrandsRP.brandId, brandId.characters.count > 0 {
      requestURL = "\(API.getProducts)\(WSConstantFetcher.getProductsSubURL(fetchBrandsRP))".encodedURL()
      //"\(URL_PREFIX)\(brandId)/\(URL_POSTFIX)".encodedURL()
    }else if let nextPage = fetchBrandsRP.nextPageURL, nextPage.characters.count > 0 {
      requestURL = "\(ONLY_BASE_URL)\(nextPage)".encodedURL()
    }
    else {
      requestURL = "\(API.getLabels)\(WSConstantFetcher.getLabelsSubURL(fetchBrandsRP))\(URL_POSTFIX)".encodedURL()
    }
    
    print(requestURL!)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj+"get").responseJSON { (response) in
        //    Alamofire.request(.GET, requestURLObj).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          let meta = json["meta"]
          //                    debugPrint(json)
          if let arrBrands = self.getBrandModels(fromJSON: json){
            success(arrBrands, meta)
          }else{
            failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
          }
          
          
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  
  
  func getBrandModels(fromJSON json:JSON)->[Brand]?{
    var arrBrands = [Brand]()
    
    if let brandList = json.dictionaryObject!["results"]{
      
      for (index,thisBrand) in (brandList as! [[String:AnyObject]]).enumerated(){
        var brand = Brand()
        
        brand.currentIndex = index
        
        if let isActive = thisBrand["is_active"] as? Bool{
          brand.isActive = isActive
        }
        
        //Add only active brands
 //       if brand.isActive{
          
          if let id = thisBrand[PRM_ID] as? NSNumber {
            brand.ID = "\(id)"
          }
        
        if let followed = thisBrand["followed"] as? Bool {
            brand.isFollowing = followed
        }
        
          if let id = thisBrand[PRM_ID] as? NSNumber {
            brand.ID = "\(id)"
          }
          
          if let brandCity = thisBrand["location"] as? [AnyHashable: Any] {
            if let city = brandCity["city"] as? String{
              brand.city = city
            }
            
            if let location = brandCity["country"]as? String{
              brand.location = location
            }
          }
          
          if let featureImage = thisBrand["image"] as? String{
            brand.FeatureImage = featureImage
          }
          
          if let description = thisBrand["description"] as? String{
            brand.Description = description
          }
          
          if let name = thisBrand["name"] as? String{
            brand.Name = name
          }
          
          if let slug = thisBrand[PRM_SLUG] as? String{
            brand.Slug = slug
          }
          
          if let stateOrCountry = thisBrand["country"] as? String{
            brand.StateOrCountry = stateOrCountry
          }
          
          //                    if let createdDate = thisBrand[PRM_CREATED] as? String{
          //                        brand.CreatedDateString = createdDate
          //
          //                        let dateFormatter = DateFormatter()
          //                        dateFormatter.dateFormat = "yyyy-MM-dd"
          //
          //                        let newDateString:String = String(brand.CreatedDateString.characters.prefix(10))
          //                        if let createdDate = dateFormatter.date(from: newDateString){
          //                            brand.CreatedDate = createdDate
          //                        }
          //                    }
          
          if let originCity = thisBrand["country"] as? String{
            brand.OriginCity = originCity
          }
          
          //                    if let brandWebsiteURL = thisBrand[PRM_BRAND_WEBSITE_URL] as? String{
          //                        brand.BrandWebsiteURL = brandWebsiteURL
          //                    }
          
          //                    if let arrProducts:[[String : AnyObject]] = thisBrand[PRM_PRODUCTS] as? [[String : AnyObject]]{
          //                        brand.arrProducts = getProductsArrayFromJSON(arrProducts)
          //                    }
          //
          //                    if let menswear = thisBrand[PRM_MENSWEAR] as? Bool{
          //                        brand.Menswear = menswear
          //                    }
          //
          //                    if let womenswear = thisBrand[PRM_WOMENSWEAR] as? Bool{
          //                        brand.Womenswear = womenswear
          //                    }
          
          //                    if let brandCategory = thisBrand[PRM_BRAND_CATEGORY] as? String{
          //                        brand.BrandCategory = brandCategory
          //                    }
          
          arrBrands.append(brand)
        }
 //     }
      
      debugPrint(arrBrands)
      return arrBrands
    }else{
      return nil
    }
  }
  func getProduct(fromJSON json:JSON)->[Product]?{
    var arrProducts = [Product]()
    if let productList = json.dictionaryObject!["results"]{
      
      for (_,thisProduct) in (productList as! [[String:AnyObject]]).enumerated(){
        let product = Product()

        if let productName:String = thisProduct["title"] as? String{
          product.ProductName = productName
        }
        if let productSKU:String = thisProduct["sku"] as? String{
          product.ProductItemSKU = productSKU
        }
        if let productPrice:NSNumber = thisProduct["retail_price"] as? NSNumber{
          product.ProductPrice = "\(productPrice)"
        }
        if let productDescription:String = thisProduct["description"] as? String{
          product.ProductDescription = productDescription
        }
        if let productInformation:String = thisProduct["information"] as? String{
          product.ProductMaterialCareInfo = productInformation
        }
        if let id = thisProduct[PRM_ID] as? NSNumber {
          product.ProductID = "\(id)"
        }
        
        if let productImageArray:[[String : AnyObject]] = thisProduct["images"] as? [[String : AnyObject]]{
         
          for thisImage in productImageArray{
            product.arrProductsImages.append(thisImage["original"]!)
          }
        }
        arrProducts.append(product)
      }
      
      //Sorting arrBrands by created date
      //            arrBrands.sortInPlace({ $0.CreatedDate.compare($1.CreatedDate) == NSComparisonResult.OrderedDescending })
      debugPrint(arrProducts)
      return arrProducts
    }else{
      return nil
    }

  }
  
  func getProductsArrayFromJSON(_ arrProductsJSON:[[String:AnyObject]])->[Product]{
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
        
        if let isMale = product[PRM_PRODUCTIS_IS_MALE] as? Bool{
          productObj.isMale = isMale
        }
        
        if let isFemale = product[PRM_PRODUCTIS_IS_FEMALE] as? Bool{
          productObj.isFemale = isFemale
        }
        
        if let isUnisex = product[PRM_PRODUCTIS_IS_UNISEX] as? Bool{
          productObj.isUnisex = isUnisex
        }
        
        arrProducts.append(productObj)
      }
    }
    
    return arrProducts
  }
  
  
  //Filter
  func getFilterCategories(_ categoryType:CategoryStyleEnum, success:@escaping ([JSON], _ meta:JSON)->(),failed:@escaping (_ error:NSError)->()){
    var requestURL:String?
    if categoryType == CategoryStyleEnum.category {
      requestURL = API.getCategories.encodedURL()
    } else if categoryType == CategoryStyleEnum.style {
      requestURL = API.getStyles.encodedURL()
    }
    
    //    print(requestURL)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj+"get").responseJSON { (response) in
        // Alamofire.request(.GET, requestURLObj).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          let meta = json["meta"]
          //                debugPrint(json)
          
          if let arrCategories = json["categories"].array {
            success(arrCategories, meta)
          }else{
            failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
          }
          
          
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
    
  }
  
  func getLocations(_ completion:@escaping ([Location]?)->()){
    Alamofire.request(API.getLocations).responseJSON { (response) in
      switch response.result {
        
      case .success(let data):
        let json = JSON(data)
        
        let data = json[APIParams.locations].arrayObject
        
        print("\(data) and this \(json) ")
        if let arrAllLocation:[Location] = Mapper<Location>().mapArray(JSONArray: data as! [[String : Any]]){
          completion(arrAllLocation)
        }else{
          completion(nil)
        }
      case .failure(_):
        completion(nil)
      }
    }
  }
  
  
  //Mark: - Version 4 API method
  
  func loginToUnlabel(_ loginParams:User,onVC:UIViewController, success:@escaping ( _ json:JSON,_ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    requestURL = v4BaseUrl + "api_v2/login/"
    print(requestURL!)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4username:loginParams.email,v4password:loginParams.password], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
          
          debugPrint(response)
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            debugPrint(json)
            
            if response.response?.statusCode == 200{
              self.setCookieFromResponse((response.request?.url)!)
              
            }
            else if response.response?.statusCode == 401{
              
            }
            success(json,(response.response?.statusCode)!)
          case .failure(let error):
            debugPrint("hhhh === \(error.localizedDescription)")
            failed(error as NSError)
            break
          }
      }
    }
  }
  func registerToUnlabel(_ regParams:User,onVC:UIViewController, success:@escaping ( _ json:JSON,_ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/customer_register/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post, parameters: [v4email:regParams.email,v4password:regParams.password,v4first_name:regParams.fullName], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            debugPrint(json)
            UnlabelLoadingView.sharedInstance.stop(onVC.view)
            if response.response?.statusCode == 201{
              self.setCookieFromResponse((response.request?.url)!)
              success(json,(response.response?.statusCode)!)
            }
            else if response.response?.statusCode == 203{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Email already registered.", onOk: { () -> () in })
            }
            else if response.response?.statusCode == 401{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Invalid Login.", onOk: { () -> () in })
            }
          case .failure(let error):
            failed(error as NSError)
            debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
      }
    }
  }
  
  func loginToUnlabelWithFB(_ onVC:UIViewController, success:@escaping ( _ json:JSON, _ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    requestURL = v4BaseUrl + "api_v2/rest-auth/facebook/"
    print(requestURL!)
    
    print("***** access token \(FBUser.sharedInstance.accessToken)")
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4accessToken:FBUser.sharedInstance.accessToken], encoding: JSONEncoding.default, headers: nil)
        
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            debugPrint(json)
            
            if response.response?.statusCode == 200{
              self.setCookieFromResponse((response.request?.url)!)
              
            }
            else{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Something went wrong.", onOk: { () -> () in })
            }
            success(json,(response.response?.statusCode)!)
          case .failure(let error):
            UnlabelLoadingView.sharedInstance.stop(onVC.view)
            UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Something went wrong.", onOk: { () -> () in })
            debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
          
      }
      
    }
  }
  
  
  func forgotPassword(_ loginParams:User,onVC:UIViewController, success:@escaping ( _ json:JSON,_ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    requestURL = v4BaseUrl + "api_v2/influencer_forgot_password/"
    print(loginParams.email)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4email:loginParams.email], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
          debugPrint(response)
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            debugPrint(json)
            if response.response?.statusCode == 200{
              self.setCookieFromResponse((response.request?.url)!)
              
            }
            else if response.response?.statusCode == 401{
              
            }
            success(json,(response.response?.statusCode)!)
          case .failure(let error):
            debugPrint("hhhh === \(error.localizedDescription)")
            failed(error as NSError)
            break
          }
      }
    }
  }
  
  
  func deleteAccount(_ onVC:UIViewController, success:@escaping ( _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/customer_profile_deactivate/"
    print(requestURL!)
    debugPrint("xcsrf   \(getCSRFToken())")
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
          debugPrint(response)
          switch response.result {
          case .success(let data):
            
            let json = JSON(data)
            // debugPrint(response.response?.statusCode)
            success(json)
            if response.response?.statusCode == 200{
              
            }
            else if response.response?.statusCode == 401{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Invalid Login", onOk: { () -> () in })
            }
          case .failure(let error):
            debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
          
      }
    }
    
  }
  
  func logoutFromUnlabel(_ onVC:UIViewController, success:@escaping ( _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/login/"
    print(requestURL!)
    debugPrint("xcsrf   \(getCSRFToken())")
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
          debugPrint("Code \(response.response?.statusCode)")
          switch response.result {
          case .success(let data):
            
            let json = JSON(data)
            debugPrint(json)
            success(json)
            if response.response?.statusCode == 200{
              
            }
            else if response.response?.statusCode == 401{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Invalid Login", onOk: { () -> () in })
            }
          case .failure(let error):
            debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
          
      }
    }
    
  }
  
  func getAllBrands(_ fetchBrandsRP:FetchBrandsRP, success:@escaping ([Brand], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    if let nextPage = fetchBrandsRP.nextPageURL, nextPage.characters.count > 0 {
      requestURL = nextPage
    }
    else {
      requestURL = v4BaseUrl + "api_v2/Influencer_partnerList/"
    }
    print(requestURL!)
    let params: [String: String] = [sort_Params:fetchBrandsRP.sortMode!]
    print(params)
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
        debugPrint(response)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
         // debugPrint(json)
          if let arrBrands = self.getBrandModels(fromJSON: json){
            success(arrBrands, json)
          //  debugPrint(arrBrands)
          }else{
            failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
    
    func getFollowedBrands(_ fetchBrandsRP:FetchBrandsRP, success:@escaping ([Brand], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
        let requestURL:String?
        
        if let nextPage = fetchBrandsRP.nextPageURL, nextPage.characters.count > 0 {
            requestURL = nextPage
        }
        else {
            requestURL = v4BaseUrl + "api_v2/influencer_followed_partners/"
        }
        print(requestURL!)
        let params: [String: String] = [sort_Params:fetchBrandsRP.sortMode!]
        print(params)
        if let requestURLObj = requestURL{
            
            Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    
                case .success(let data):
                    let json = JSON(data)
                    // debugPrint(json)
                    if let arrBrands = self.getBrandModels(fromJSON: json){
                        success(arrBrands, json)
                        //  debugPrint(arrBrands)
                    }else{
                        failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
                    }
                case .failure(let error):
                    failed(error as NSError)
                }
            }
        }
    }
  
  func getProductOfBrand(_ fetchProductParams:FetchProductParams, success:@escaping ([Product], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    if let nextPage = fetchProductParams.nextPageURL, nextPage.characters.count > 0 {
      requestURL = nextPage
    }
    else {
      requestURL = v4BaseUrl + "api_v2/influencer_product_list/"
    }
    print(requestURL!)
    let params: [String: String] = [sort_Params:fetchProductParams.sortMode,product_brand_id:fetchProductParams.brandId]
    
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
      //  debugPrint(response)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          debugPrint(json)

          if let arrProducts = self.getProduct(fromJSON: json){
            success(arrProducts, json)
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  func followBrand(_ brandId:String,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/partner_follow/"+brandId+"/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  //api_v2/influencer_reserve_product/(?P<product_id>[0-9]+)/
  func reserveProduct(_ productId:String,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_reserve_product/"+productId+"/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: nil).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  
  //Mark: - API Common helper method
  
  func setCookieFromResponse(_ url:URL) {
    let allCookies:[HTTPCookie] = HTTPCookieStorage.shared.cookies(for: url)!
    for cookie: HTTPCookie in allCookies {
      if (cookie.name == "sessionid") {
        let cookieArray = [cookie]
        HTTPCookieStorage.shared.setCookies(cookieArray, for: url, mainDocumentURL: nil)
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        print("session id :: \(cookie.value)")
        //Save Cookie
        self.setCookie(cookie: cookie)
      }
      else if (cookie.name == "csrftoken") {
        // Save CSRF Token
        print("csrftoken :: \(cookie.value)")
        UnlabelHelper.setDefaultValue(cookie.value, key: "X-CSRFToken")
      }
    }
    print(allCookies)
    
  }
  func getCSRFToken() -> String{
    if let xcsrf:String =  UnlabelHelper.getDefaultValue("X-CSRFToken")! as String{
      return xcsrf
    }
    else{
      return ""
    }
  }
  func getCookie () -> HTTPCookie
  {
    let cookie = HTTPCookie(properties: UserDefaults.standard.object(forKey: "ULCookie") as!  [HTTPCookiePropertyKey : Any])
    return cookie!
  }
  
  func setCookie(cookie:HTTPCookie)
  {
    UserDefaults.standard.set(cookie.properties, forKey: "ULCookie")
    UserDefaults.standard.synchronize()
  }
  
}
