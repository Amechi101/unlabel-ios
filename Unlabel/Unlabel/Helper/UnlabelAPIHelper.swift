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
    
  //  print(requestURL!)
    
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
        let brand = Brand()
        
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
      
   //   debugPrint(arrBrands)
      return arrBrands
    }else{
      return nil
    }
  }
  
  
  func getBrandWiseProductModels(fromJSON json:JSON)->[Brand]?{
    var arrBrands = [Brand]()

  //  let brandList1 = json.dictionaryObject
 //   print(json)
    if let brandList = json.dictionaryObject!["results"]{
      
      for (index,thisBrand) in (brandList as! [[String:AnyObject]]).enumerated(){
        let brand = Brand()
        let currentBrand = thisBrand["brand"] as! [String:AnyObject]
      //  print(currentBrand)
        brand.currentIndex = index
        
        if let isActive = currentBrand["is_active"] as? Bool{
          brand.isActive = isActive
        }

        if let id = currentBrand[PRM_ID] as? NSNumber {
          brand.ID = "\(id)"
        }
        
        if let followed = thisBrand["followed"] as? Bool {
          brand.isFollowing = followed
        }
        
    //    print(currentBrand["description"] as! String)
        
        if let rentalInfo: [AnyHashable: Any] = currentBrand["rental_info"] as? [AnyHashable: Any] {
          let rental = RentalInfo()
          if let country = rentalInfo["country"] as? String{
            rental.Country = country
          }
          if let city = rentalInfo["city"] as? String{
            rental.City = city
          }
          if let contact_number = rentalInfo["contact_number"] as? String{
            rental.ContactNumber = contact_number
          }
          if let post_box = rentalInfo["post_box"] as? String{
            rental.AptUnit = post_box
          }
          if let zipcode = rentalInfo["zipcode"] as? String{
            rental.ZipCode = zipcode
          }
          if let state = rentalInfo["state"] as? String{
            rental.State = state
          }
//          if let start_time = rentalInfo["start_time"] as? String{
//          }
//          if let start_time_period = rentalInfo["start_time_period"] as? String{
//          }
//          if let end_time = rentalInfo["end_time"] as? String{
//          }
//          if let end_time_period = rentalInfo["end_time_period"] as? String{
//          }

          
          let startTime: String = (rentalInfo["start_time"]as! String) + (rentalInfo["start_time_period"] as! String)
          let endTime: String = (rentalInfo["end_time"] as! String) + (rentalInfo["end_time_period"] as! String)
          if let days: [String] = rentalInfo["day"] as? [String]{
            for thisDay in days{
              rental.PickUpTime.append(thisDay+": " + startTime + " - " + endTime)
            }
          }
          brand.rentalInfo = rental
        }
        

        
        if let name = currentBrand["name"] as? String{
          brand.Name = name
        }
        
        if let slug = currentBrand[PRM_SLUG] as? String{
          brand.Slug = slug
        }

        if let productList = thisBrand["products"] as! [[String : AnyObject]]?{
     //   print(productList)
        for thisProduct in productList{
        //    print(thisProduct)
            let product = Product()
            if let name = thisProduct["title"] as? String{
                product.ProductName = name
            }
          if let description = thisProduct["description"] as? String{
            product.ProductDescription = description
          }
          if let material_info = thisProduct["material_info"] as? String{
            product.ProductMaterialCareInfo = material_info
          }
            if let id = thisProduct["id"] as? NSNumber{
                product.ProductID = "\(id)"
            }
            if let price = thisProduct["price"] as? NSNumber{
                product.ProductPrice = "\(price)"
            }
          if let productSizeArray:[[String : AnyObject]] = thisProduct["attributes"] as? [[String : AnyObject]]{
            for thisImage in productSizeArray{
              product.ProductsSize = (thisImage["value"]!) as! String
            }
          }
          
            if let productImageArray:[[String : AnyObject]] = thisProduct["images"] as? [[String : AnyObject]]{
                 product.arrProductsImages = []
                for thisImage in productImageArray{
                    product.arrProductsImages.append(thisImage["original"]!)
                }
            }
            brand.arrProducts.append(product)
        }
        }
        arrBrands.append(brand)
      }
    //  debugPrint(arrBrands)
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
        
        if let price = thisProduct["price"] as? [AnyHashable: Any] {
          if let retailPrice = price["price_retail"] as? NSNumber{
            product.ProductPrice = "\(retailPrice)"
          }
        }
        
        if let productDescription:String = thisProduct["description"] as? String{
          product.ProductDescription = productDescription
        }
        if let productInformation:String = thisProduct["material_info"] as? String{
          product.ProductMaterialCareInfo = productInformation
        }
        if let id = thisProduct[PRM_ID] as? NSNumber {
          product.ProductID = "\(id)"
        }
        if let productSizeArray:[[String : AnyObject]] = thisProduct["attributes"] as? [[String : AnyObject]]{
          product.arrProductsSizes = []
          for thisSize in productSizeArray{
            product.arrProductsSizes.append(thisSize["value"]!)
            product.ProductsSize = (thisSize["value"]!) as! String
          }
        }
        if let productImageArray:[[String : AnyObject]] = thisProduct["images"] as? [[String : AnyObject]]{
          //  print(productImageArray)
         product.arrProductsImages = []
          for thisImage in productImageArray{
            
          //  print(thisImage)
            product.arrProductsImages.append(thisImage["original"]!)
          }
        }
        arrProducts.append(product)
      }
      
      //Sorting arrBrands by created date
      //            arrBrands.sortInPlace({ $0.CreatedDate.compare($1.CreatedDate) == NSComparisonResult.OrderedDescending })
   //   debugPrint(arrProducts)
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
  
  func getStateModels(fromJSON json:JSON)->[UnlabelStaticList]?{
    var arrStates = [UnlabelStaticList]()
    if let stateList = json.dictionaryObject!["results"]{
      for (_,thisState) in (stateList as! [[String:AnyObject]]).enumerated(){
        let state = UnlabelStaticList(uId: "", uName: "",isSelected:false)
        if let stateName:String = thisState["name"] as? String{
          state.uName = stateName
        }
        if let stateID:NSNumber = thisState["pk"] as? NSNumber{
          state.uId = "\(stateID)"
        }
        state.isSelected = false
      //  print(thisState)
        arrStates.append(state)
      }
      //     }
      
      //   debugPrint(arrBrands)
      return arrStates
    }else{
      return nil
    }
  }
  
  func getCountriesModels(fromJSON json:JSON)->[UnlabelStaticList]?{
    var arrCountries = [UnlabelStaticList]()
    if let countriesList = json.dictionaryObject!["results"]{
      for (_,thisCountries) in (countriesList as! [[String:AnyObject]]).enumerated(){
        let countries = UnlabelStaticList(uId: "", uName: "",isSelected:false)
        if let stateName:String = thisCountries["printable_name"] as? String{
          countries.uName = stateName
        }
        if let stateID:String = thisCountries["pk"] as? String{
          countries.uId = stateID
        }
        countries.isSelected = false
        arrCountries.append(countries)
      }
      return arrCountries
    }else{
      return nil
    }
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
        
     //   print("\(data) and this \(json) ")
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
   // print(requestURL!)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4username:loginParams.email,v4password:loginParams.password], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
          
       //   debugPrint(response)
          switch response.result {
          case .success(let data):
            let json = JSON(data)
          //  debugPrint(json)
            
            if response.response?.statusCode == 200{
              self.setCookieFromResponse((response.request?.url)!)
              
            }
            else if response.response?.statusCode == 401{
              
            }
            success(json,(response.response?.statusCode)!)
          case .failure(let error):
         //   debugPrint("hhhh === \(error.localizedDescription)")
            failed(error as NSError)
            break
          }
      }
    }
  }
  func registerToUnlabel(_ regParams:User,onVC:UIViewController, success:@escaping ( _ json:JSON,_ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/customer_register/"
 //   print(requestURL!)
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post, parameters: [v4email:regParams.email,v4password:regParams.password,v4first_name:regParams.fullName], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
          //  debugPrint(json)
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
          //  debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
      }
    }
  }
  
  func loginToUnlabelWithFB(_ onVC:UIViewController, success:@escaping ( _ json:JSON, _ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    requestURL = v4BaseUrl + "api_v2/rest-auth/facebook/"
  //  print(requestURL!)
    
 //   print("***** access token \(FBUser.sharedInstance.accessToken)")
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4accessToken:FBUser.sharedInstance.accessToken], encoding: JSONEncoding.default, headers: nil)
        
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
          //  debugPrint(json)
            
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
         //   debugPrint("hhhh === \(error.localizedDescription)")
            break
          }
          
      }
      
    }
  }
  
  
  func forgotPassword(_ loginParams:User,onVC:UIViewController, success:@escaping ( _ json:JSON,_ statusCode:Int)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    requestURL = v4BaseUrl + "api_v2/influencer_forgot_password/"
  //  print(loginParams.email)
    
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post,  parameters: [v4email:loginParams.email], encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
        //  debugPrint(response)
          switch response.result {
          case .success(let data):
            let json = JSON(data)
          //  debugPrint(json)
            if response.response?.statusCode == 200{
              self.setCookieFromResponse((response.request?.url)!)
              
            }
            else if response.response?.statusCode == 401{
              
            }
            success(json,(response.response?.statusCode)!)
          case .failure(let error):
         //   debugPrint("hhhh === \(error.localizedDescription)")
            failed(error as NSError)
            break
          }
      }
    }
  }
  
  
  func deleteAccount(_ onVC:UIViewController, success:@escaping ( _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/customer_profile_deactivate/"
 //   print(requestURL!)
 //   debugPrint("xcsrf   \(getCSRFToken())")
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
       //   debugPrint(response)
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
  //  print(requestURL!)
  //  debugPrint("xcsrf   \(getCSRFToken())")
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
          debugPrint("Code \(response.response?.statusCode)")
          switch response.result {
          case .success(let data):
            
            let json = JSON(data)
         //   debugPrint(json)
            success(json)
            if response.response?.statusCode == 200{
              
            }
            else if response.response?.statusCode == 401{
              UnlabelHelper.showAlert(onVC: onVC, title: "UNLABEL", message: "Invalid Login", onOk: { () -> () in })
            }
          case .failure(let error):
            debugPrint("hhhh === \(error.localizedDescription)")
            UnlabelHelper.showAlert(onVC: onVC, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
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
   // print(requestURL!)
    let params: [String: String] = [sort_Params:fetchBrandsRP.sortMode!]
  //  print(params)
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
      //  debugPrint(response)
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
      //  print(requestURL!)
        let params: [String: String] = [sort_Params:fetchBrandsRP.sortMode!]
      //  print(params)
        if let requestURLObj = requestURL{
            
            Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
              //  debugPrint(response)
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
  
  func getSizeProduct(_ prodID:String, success:@escaping ([Product], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_product_variants/"
  //  print(requestURL!)
    let params: [String: String] = [product_id: prodID]
    
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
        //  debugPrint(response)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
         // debugPrint(json)
          
          if let arrProducts = self.getProduct(fromJSON: json){
            success(arrProducts, json)
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
  //  print(requestURL!)
    let params: [String: String] = [sort_Params:fetchProductParams.sortMode,product_brand_id:fetchProductParams.brandId]
    
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
      //  debugPrint(response)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
       //   debugPrint(json)

          if let arrProducts = self.getProduct(fromJSON: json){
            success(arrProducts, json)
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  func getReserveProduct(_ fetchProductParams:FetchProductParams, success:@escaping ([Brand], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    
    if let nextPage = fetchProductParams.nextPageURL, nextPage.characters.count > 0 {
      requestURL = nextPage
    }
    else {
      requestURL = v4BaseUrl + "api_v2/influencer_reserved_products/"
    }
  //  print(requestURL!)
//    let params: [String: String] = [sort_Params:fetchProductParams.sortMode,product_brand_id:fetchProductParams.brandId]
    
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
       //   debugPrint(response)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          if let arrBrands = self.getBrandWiseProductModels(fromJSON: json){
            success(arrBrands, json)
            //  debugPrint(arrBrands)
          }else{
            failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
          }        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
    func getRentedProduct(_ fetchProductParams:FetchProductParams, success:@escaping ([Brand], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
        let requestURL:String?
        
        if let nextPage = fetchProductParams.nextPageURL, nextPage.characters.count > 0 {
            requestURL = nextPage
        }
        else {
            requestURL = v4BaseUrl + "api_v2/influencer_rented_products/"
        }
        if let requestURLObj = requestURL{
            
            Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
                //   debugPrint(response)
                switch response.result {
                    
                case .success(let data):
                    let json = JSON(data)
                    if let arrBrands = self.getBrandWiseProductModels(fromJSON: json){
                        success(arrBrands, json)
                        //  debugPrint(arrBrands)
                    }else{
                        failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
                    }        case .failure(let error):
                        failed(error as NSError)
                }
            }
        }
    }
    
    func getLiveProduct(_ fetchProductParams:FetchProductParams, success:@escaping ([Brand], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
        let requestURL:String?
        
        if let nextPage = fetchProductParams.nextPageURL, nextPage.characters.count > 0 {
            requestURL = nextPage
        }
        else {
            requestURL = v4BaseUrl + "api_v2/influencer_live_products/"
        }
     //   print(requestURL!)
        //        let params: [String: String] = [sort_Params:fetchProductParams.sortMode,product_brand_id:fetchProductParams.brandId]
        
        if let requestURLObj = requestURL{
            
            Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
                //   debugPrint(response)
                switch response.result {
                    
                case .success(let data):
                    let json = JSON(data)
                    if let arrBrands = self.getBrandWiseProductModels(fromJSON: json){
                        success(arrBrands, json)
                        //  debugPrint(arrBrands)
                    }else{
                        failed(NSError(domain: "No brand found", code: 0, userInfo: nil))
                    }        case .failure(let error):
                        failed(error as NSError)
                }
            }
        }
    }

  func followBrand(_ brandId:String,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/partner_follow/"
    let params: [String: String] = ["id":brandId]
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
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
  
  func getProductNote(_ productID: String, onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
     let params: [String: String] = ["prod_id":productID]
    
    requestURL = v4BaseUrl + "api_v2/influencer_add_product_note/"
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
        
        
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          print(json)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }
  
  func saveProductNote(_ prodID: String, note: String, onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    let params: [String: String] = ["prod_id":prodID,"note":note]
    requestURL = v4BaseUrl + "api_v2/influencer_add_product_note/"
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()]).responseJSON { response in
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          print(json)
          success(json)
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  
  func getInfluencerBio(_ onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_image_bio/"
  //  print(requestURL!)
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
  
  func getProductImageModels(fromJSON json:JSON)->[ProductImages]?{
    var arrImages = [ProductImages]()
    if let imageList = json.dictionaryObject!["results"]{
      for (_,thisImage) in (imageList as! [[String:AnyObject]]).enumerated(){
        let image = ProductImages()
        if let imageURL:String = thisImage["original"] as? String{
          image.pImageUrl = imageURL
        }
        if let imageID:NSNumber = thisImage["id"] as? NSNumber{
          image.pId = "\(imageID)"
        }
        if let displayOrder:NSNumber = thisImage["display_order"] as? NSNumber{
          image.pDisplayOrder = "\(displayOrder)"
        }
        if let imageCaption:String = thisImage["caption"] as? String{
          image.pCaption = imageCaption
        }
        arrImages.append(image)
      }
      return arrImages
    }else{
      return nil
    }
  }
  
  func getProductImage(_ productId:String, onVC:UIViewController, success:@escaping ([ProductImages],_  json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_add_product_images/"
    let params: [String: String] = ["prod_id":productId]
      print(productId)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .get, parameters: params).responseJSON { response in
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          
          print(json)
          if let arrImages = self.getProductImageModels(fromJSON: json){
            success(arrImages, json)
          }else{
            failed(NSError(domain: "No Image found", code: 0, userInfo: nil))
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  //api_v2/influencer_reserve_product/(?P<product_id>[0-9]+)/
  func reserveProduct(_ productId:String,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_reserve_product/"
    let params: [String: String] = ["id":productId]
    print(productId)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
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
  
  func goLiveProduct(_ productId:String,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_product_go_live/"
    let params: [String: String] = ["prod_id":productId]
    print(productId)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
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
  
  func saveProfileInfo(_ user:User,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    let params = ["contact_number":user.contactNumber,"email":user.email,"first_name":user.firstname,"last_name":user.lastname]
    requestURL = v4BaseUrl + "api_v2/influencer_profile_update/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()]).responseJSON { response in
        
        
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }
  
  func removeProductPhot(_ product:ProductImages,onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    let params = ["prod_id":product.pProduct,"display_order":product.pDisplayOrder]
    requestURL = v4BaseUrl + "api_v2/influencer_remove_product_image/"
    print("id \(product.pProduct) and order \(product.pDisplayOrder)")
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["X-CSRFToken":getCSRFToken()])
        .responseJSON { response in
        
        
        print(response.request)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }
  
  
  func getProfileInfo(_ onVC: UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_profile_update/"
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
  
    func getInfluencerLocation(_ onVC: UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
        let requestURL:String?
        requestURL = v4BaseUrl + "api_v2/influencer_current_locations/"
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
  
  func saveInfluencerLocation(_ params:[String:String],onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_current_locations/"
    print(params)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()]).responseJSON { response in
        
        
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }
  
  func getPhysicalAttributes(_ onVC: UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_physical_attributes/"
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
  
  
  func savePhysicalAttributes(_ params: [String: String],onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_physical_attributes/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()]).responseJSON { response in
        
        
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }

  func changePassword(_ passDict:[String:String],onVC:UIViewController, success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    let params = ["old_password":passDict["current_password"],"new_password":passDict["new_password"] ]
    requestURL = v4BaseUrl + "api_v2/influencer_change_password/"
    print(requestURL!)
    if let requestURLObj = requestURL{
      
      Alamofire.request(requestURLObj, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["X-CSRFToken":getCSRFToken()]).responseJSON { response in
        print(response.result)
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          success(json)
        case .failure(let error):
          print(error.localizedDescription)
          failed(error as NSError)
        }
      }
    }
  }
  
  func getProfileDetails(_ success:@escaping (_ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/influencer_profile_details/"
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
  
  
  func getAllStates(_ success:@escaping ([UnlabelStaticList], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/get_states/"
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          // debugPrint(json)
          if let arrStates = self.getStateModels(fromJSON: json){
            success(arrStates, json)
          }else{
            failed(NSError(domain: "No State found", code: 0, userInfo: nil))
          }
        case .failure(let error):
          failed(error as NSError)
        }
      }
    }
  }
  
  func getAllCountry(_ success:@escaping ([UnlabelStaticList], _ json:JSON)->(),failed:@escaping (_ error:NSError)->()){
    let requestURL:String?
    requestURL = v4BaseUrl + "api_v2/get_countries/"
    if let requestURLObj = requestURL{
      Alamofire.request(requestURLObj, method: .get, parameters: nil).responseJSON { response in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          // debugPrint(json)
          if let arrStates = self.getCountriesModels(fromJSON: json){
            success(arrStates, json)
          }else{
            failed(NSError(domain: "No country found", code: 0, userInfo: nil))
          }
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
      //  print("session id :: \(cookie.value)")
        //Save Cookie
        self.setCookie(cookie: cookie)
      }
      else if (cookie.name == "csrftoken") {
        // Save CSRF Token
      //  print("csrftoken :: \(cookie.value)")
        UnlabelHelper.setDefaultValue(cookie.value, key: "X-CSRFToken")
      }
    }
//    print(allCookies)
    
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
