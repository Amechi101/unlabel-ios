//
//  UnlabelHelper.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class UnlabelHelper: NSObject {
  
  //MARK:- UIFont Methods
  class func getNeutraface2Text(style:String, size:CGFloat)->UIFont{
    return UIFont(name: "Neutraface2Text-\(style)", size: size)!
  }
  
  //MARK:- Anonymous Methods
  
  /**
   Set user defaults
   */
  class func setDefaultValue(_ value:String,key:String){
    UserDefaults.standard.setValue(value, forKey: key)
  }
  class func setBoolValue(_ value:Bool,key:String){
    UserDefaults.standard.set(value, forKey: key)
  }
  
  /**
   Get user defaults
   */
  class func getDefaultValue(_ key:String)->(String?){
    return UserDefaults.standard.value(forKey: key) as? String
  }
  class func getBoolValue(_ key:String)->(Bool){
    return UserDefaults.standard.bool(forKey: key)
  }
  
  /**
   Remove user defaults
   */
  class func removePrefForKey(_ key:String){
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  /**
   handleLogout
   */
  
  class func clearCookie(){
    let cstorage = HTTPCookieStorage.shared
    
    UserDefaults.standard.removeObject(forKey: "ULCookie")
    
    if let cookies = cstorage.cookies {
      for cookie in cookies {
        cstorage.deleteCookie(cookie)
      }
    }
  //  print("cs cookie  \(cstorage)")
  }
  
  class func logout(){
    UnlabelHelper.clearCookie()
    UnlabelHelper.removePrefForKey(PRM_USER_ID)
    UnlabelHelper.removePrefForKey(PRM_PHONE)
    UnlabelHelper.removePrefForKey(PRM_EMAIL)
    UnlabelHelper.removePrefForKey(PRM_DISPLAY_NAME)
    UnlabelHelper.removePrefForKey(PRM_PROVIDER)
    UnlabelHelper.removePrefForKey(sPOPUP_SEEN_ONCE)
    UnlabelHelper.removePrefForKey(sFOLLOW_SEEN_ONCE)
    UnlabelHelper.removePrefForKey(sENTRY_ONCE_SEEN)
    
    UnlabelHelper.removePrefForKey("influencer_email")
    UnlabelHelper.removePrefForKey("influencer_last_name")
    UnlabelHelper.removePrefForKey("influencer_auto_id")
    UnlabelHelper.removePrefForKey("influencer_image")
    UnlabelHelper.removePrefForKey("influencer_first_name")
   // UnlabelHelper.removePrefForKey("device_token")
    UnlabelHelper.removePrefForKey("ULCookie")
    UnlabelHelper.removePrefForKey("X-CSRFToken")
    
    let rootTabVC = UIStoryboard(name: "Unlabel", bundle: nil).instantiateViewController(withIdentifier: "BannerViewController") as? BannerViewController
    if let window = APP_DELEGATE.window {
      window.rootViewController = rootTabVC
      window.rootViewController!.view.layoutIfNeeded()
      UIView.transition(with: APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
        window.rootViewController!.view.layoutIfNeeded()
      }, completion: nil)
    }
    
  }
  
  /**
   Common Methods
   */
  
  class func setAppDelegateDelegates(_ delegate:AppDelegateDelegates){
    let appDelegate = APP_DELEGATE as AppDelegate
    appDelegate.delegate = delegate
  }
  
  class func showAlert(onVC OnVC:UIViewController,title:String,message:String,onOk:@escaping ()->()){
    DispatchQueue.main.async { () -> Void in
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        onOk()
      }))
      
      DispatchQueue.main.async(execute: {
        OnVC.present(alert, animated: true, completion: nil)
      })
    }
  }
  
  class func showConfirmAlert(_ onVC:UIViewController,title:String,message:String,onCancel:@escaping ()->(),onOk:@escaping ()->()){
    let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      onCancel()
    }))
    
    confirmAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      onOk()
    }))
    
    DispatchQueue.main.async(execute: {
      onVC.present(confirmAlert, animated: true, completion: nil)
    })
  }
  
  class func showLoginAlert(_ onVC:UIViewController,title:String,message:String,onCancel:@escaping ()->(),onSignIn:@escaping ()->()){
    let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      onCancel()
    }))
    
    confirmAlert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.default, handler: { (action) -> Void in
      onSignIn()
    }))
    
    DispatchQueue.main.async(execute: {
      onVC.present(confirmAlert, animated: true, completion: nil)
    })
  }
  
  class func isValidEmail(_ emailString:String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: emailString)
    
    return result
    
  }
  
  class func isValidName(_ nameString:String) -> Bool {
    
    let nameRegEx = "[A-Za-z ]+"
    let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
    let result = nameTest.evaluate(with: nameString)
    
    return result
    
  }
  
//  //Cloudnary setup
//  class func getCloudnaryObj()->CLCloudinary{
//    let cloudinary: CLCloudinary = CLCloudinary()
//    cloudinary.config()["cloud_name"] = "hqz2myoz0"
//    cloudinary.config()["api_key"] = "849968616415457"
//    cloudinary.config()["api_secret"] = "KEHl083N5M7NsHrVVR4TXnR4Xg4"
//    return cloudinary
//  }
//  
  
  //User Logged In check
  class func isUserLoggedIn() -> Bool{
    if (UserDefaults.standard.object(forKey: "ULCookie") != nil){
      HTTPCookieStorage.shared.setCookie(getCookie())
      return true
    }else{
      return false
    }
  }
  
  //Get stored cookie from Userdefaults
  
  class func getCookie () -> HTTPCookie
  {
    let cookie = HTTPCookie(properties: UserDefaults.standard.object(forKey: "ULCookie") as!  [HTTPCookiePropertyKey : Any])
    return cookie!
  }
  
  class func goToBrandVC(_ storyBoard: UIStoryboard){
    let rootTabVC = storyBoard.instantiateViewController(withIdentifier: S_ID_TAB_CONTROLLER) as? UITabBarController
    if let window = APP_DELEGATE.window {
      UIView.transition(with: APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
        window.rootViewController = rootTabVC
      }, completion: nil)
    }
  }
  
  class func getHeightList() -> [UnlabelStaticList]{
    var arrHeight = [UnlabelStaticList]()
    for ft in 4...7 {
      for i in 0...11{
        let pSize = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
        let htText: String = "\(ft)" + " feet " + "\(i)" + " inches"
        pSize.uName = htText
        let inInches = (ft*12)+i
        pSize.uId = "\(inInches)"
        arrHeight.append(pSize)
      }
    }
    return arrHeight
  }
  
  class func getGenderType() -> [UnlabelStaticList]{
    var attributeList =  [UnlabelStaticList]()
    let pType1 = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
    pType1.uId = "M"
    pType1.uName = "Male"
    attributeList.append(pType1)
    let pType2 = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
    pType2.uId = "F"
    pType2.uName = "Female"
    attributeList.append(pType2)
    return attributeList
  }
  class func getRadius() -> [FilterModel]{
    var attributeList =  [FilterModel]()
    let pType1 = FilterModel()
    pType1.typeId = "10"
    pType1.typeName = "10 miles"
    attributeList.append(pType1)
    let pType2 = FilterModel()
    pType2.typeId = "20"
    pType2.typeName = "20 miles"
    attributeList.append(pType2)
    let pType3 = FilterModel()
    pType3.typeId = "50"
    pType3.typeName = "50 miles"
    attributeList.append(pType3)
    let pType4 = FilterModel()
    pType4.typeId = "100"
    pType4.typeName = "100 miles"
    attributeList.append(pType4)
    return attributeList
  }

  class func getOtherPhysicalAttributes() -> [UnlabelStaticList]{
    var attributeList =  [UnlabelStaticList]()
      for i in 20...50{
        let pSize = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
        let phyText: String = "\(i)" + " inches"
        pSize.uId = "\(i)"
        pSize.uName = phyText
        attributeList.append(pSize)
      }
    return attributeList
  }
  
  class func getcurrentDateTime() -> String{
    let todaysDate: NSDate = NSDate()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ddMMyyyyHHmmss"
    let dateInFormat: String = dateFormatter.string(from: todaysDate as Date)
    return dateInFormat
  }
  
  class func daySuffix(from date: Date) -> String {
    let calendar = Calendar.current
    let dayOfMonth = calendar.component(.day, from: date)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
  }
  class func getFormattedTodaysDate() -> String {
    let suffix: String = daySuffix(from: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.system
    dateFormatter.dateFormat = "EEEE, MMM dd"
    var dateConverted: Date? = Date()
    let partialDate = dateFormatter.string(from: dateConverted!) + suffix
    dateFormatter.dateFormat = "YYYY"
    dateConverted = Date()
    let finalDate = partialDate + ", " + dateFormatter.string(from: dateConverted!)
    return finalDate
  }
  
  class func getPickUpDays(indices: [Int]) -> [UnlabelStaticList]{
    var finalDays : [String] = [String]()
    var dates : [Date] = []
    var matchingComponents = DateComponents()
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE,MMM dd, yyyy"
    let nextDayToFind: Date = Date()
    for index in indices {
      matchingComponents.weekday = index
      let nextDay = calendar.nextDate(after: nextDayToFind, matching: matchingComponents, matchingPolicy:.nextTime)!
      dates.append(nextDay)
      dates.append(Calendar.current.date(byAdding: .day, value: 7, to: nextDay)!)
      dates.sort(by: {$0.compare($1) == .orderedAscending})
    }
    for date in dates {
      let dateString = formatter.string(from: date)
      finalDays.append(dateString)
    }
    var attributeList =  [UnlabelStaticList]()
    for day in finalDays{
      let pDay = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
      pDay.uId = day
      pDay.uName = day
      attributeList.append(pDay)
    }
    return attributeList
  }
  
  class func getReturnDays(indices: [Int], starDate: String) -> [UnlabelStaticList]{
    var finalDays : [String] = [String]()
    var dates : [Date] = []
    var matchingComponents = DateComponents()
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE,MMM dd, yyyy"
    let nextDayToFind: Date = formatter.date(from: starDate)!
    print(nextDayToFind)
    for index in indices {
      matchingComponents.weekday = index
      let nextDay = calendar.nextDate(after: nextDayToFind, matching: matchingComponents, matchingPolicy:.nextTime)!
      dates.append(nextDay)
      dates.sort(by: {$0.compare($1) == .orderedAscending})
    }
    for date in dates {
      let dateString = formatter.string(from: date)
      finalDays.append(dateString)
    }
    var attributeList =  [UnlabelStaticList]()
    for day in finalDays{
      let pDay = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
      pDay.uId = day
      pDay.uName = day
      attributeList.append(pDay)
    }
    return attributeList
  }

  
  
}

