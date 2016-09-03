//
//  UnlabelHelper.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class UnlabelHelper: NSObject {
    
    //
    //MARK:- UIFont Methods
    //
    class func getNeutraface2Text(style style:String, size:CGFloat)->UIFont{
        return UIFont(name: "Neutraface2Text-\(style)", size: size)!
    }
    
    //
    //MARK:- Anonymous Methods
    //
    
    /**
     Set user defaults
     */
    class func setDefaultValue(value:String,key:String){
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
    }
    
    class func setBoolValue(value:Bool,key:String){
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
    }
    
    /**
     Get user defaults
     */
    class func getDefaultValue(key:String)->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey(key) as? String
    }
    
    class func getBoolValue(key:String)->(Bool){
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    /**
     Remove user defaults
     */
    class func removePrefForKey(key:String){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     handleLogout
     */
    class func logout(){
        FirebaseHelper.logout()
        UnlabelFBHelper.logout()
        UnlabelHelper.removePrefForKey(PRM_USER_ID)
        UnlabelHelper.removePrefForKey(PRM_PHONE)
        UnlabelHelper.removePrefForKey(PRM_EMAIL)
        UnlabelHelper.removePrefForKey(PRM_DISPLAY_NAME)
        UnlabelHelper.removePrefForKey(PRM_PROVIDER)
        UnlabelHelper.removePrefForKey(sPOPUP_SEEN_ONCE)
        
        
        let rootNavVC:UINavigationController? = UIStoryboard(name: "Unlabel", bundle: nil).instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
        
        
        if let window = APP_DELEGATE.window {
            window.rootViewController = rootNavVC
            window.rootViewController!.view.layoutIfNeeded()
            
            UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                window.rootViewController!.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    /**
     handle delete account
     
     Note:- For Facebook only removing following brands, because there is no way to delete it from Firebase
     For AccountKit deleting acccount.
     */
//    class func deleteAccount(userID:String){
//            if let provider = UnlabelHelper.getDefaultValue(PRM_PROVIDER){
//                
//                //Facebook user
//                if provider == S_PROVIDER_FACEBOOK{
//                    dispatch_async(dispatch_get_main_queue()) {
//                        FIREBASE_USERS_REF.childByAppendingPath(userID).childByAppendingPath(PRM_FOLLOWING_BRANDS).removeValueWithCompletionBlock({ (error:NSError!, firebase:Firebase!) in
//                            if error == nil{
//                                debugPrint("all following brands removed")
//                            }else{
//                                debugPrint("all following brands not removed : \(error)")
//                            }
//                        })
//                    }
//                    
//                    
//                    //AccountKit
//                }else{
//                    dispatch_async(dispatch_get_main_queue()) {
//                        FIREBASE_USERS_REF.childByAppendingPath(userID).removeValueWithCompletionBlock({ (error:NSError!, firebase:Firebase!) in
//                            if error == nil{
//                                debugPrint("account removed")
//                            }else{
//                                debugPrint("account not removed : \(error)")
//                            }
//                        })
//                    }
//                }
//            }else{
//              
//            }
//       
//        
//        UnlabelHelper.logout()
//    }

    class func setAppDelegateDelegates(delegate:AppDelegateDelegates){
        let appDelegate = APP_DELEGATE as AppDelegate
        appDelegate.delegate = delegate
    }
    
    class func showAlert(onVC OnVC:UIViewController,title:String,message:String,onOk:()->()){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                onOk()
            }))
    
            dispatch_async(dispatch_get_main_queue(), {
                OnVC.presentViewController(alert, animated: true, completion: nil)
            })   
        }
    }
    
    class func showConfirmAlert(onVC:UIViewController,title:String,message:String,onCancel:()->(),onOk:()->()){
        let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            onCancel()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            onOk()
        }))
        
        dispatch_async(dispatch_get_main_queue(), {
            onVC.presentViewController(confirmAlert, animated: true, completion: nil)
        })
    }
    
    class func showLoginAlert(onVC:UIViewController,title:String,message:String,onCancel:()->(),onSignIn:()->()){
        let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            onCancel()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            onSignIn()
        }))
        
        dispatch_async(dispatch_get_main_queue(), {
            onVC.presentViewController(confirmAlert, animated: true, completion: nil)
        })
    }

    class func isValidEmail(emailString:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(emailString)
        
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
}

