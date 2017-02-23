//
//  UnlabelHelper.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Cloudinary

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
  
  //Cloudnary setup
  class func getCloudnaryObj()->CLCloudinary{
    let cloudinary: CLCloudinary = CLCloudinary()
    cloudinary.config()["cloud_name"] = "hqz2myoz0"
    cloudinary.config()["api_key"] = "849968616415457"
    cloudinary.config()["api_secret"] = "KEHl083N5M7NsHrVVR4TXnR4Xg4"
    return cloudinary
  }
  
  
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
  
  class func getHeightList() -> [String]{
    var heightList: [String] = []
    for ft in 4...7 {
      for i in 0...11{
        let htText: String = "\(ft)" + " feet " + "\(i)" + " inches"
        heightList.append(htText)
      }
    }
    return heightList
  }
  
  class func getOtherPhysicalAttributes() -> [String]{
    var attributeList: [String] = []
      for i in 20...50{
        let phyText: String = "\(i)" + " inches"
        attributeList.append(phyText)
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
  
  
}

