//
//  UnlabelHelper.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

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
    
    /**
     Get user defaults
     */
    class func getDefaultValue(key:String)->(String?){
        return NSUserDefaults.standardUserDefaults().valueForKey(key) as? String
    }
    
    /**
     handleLogout
     */
    class func logout(){
        UnlabelFBHelper.logout()
        let rootVC = UIStoryboard(name: "Unlabel", bundle: nil).instantiateViewControllerWithIdentifier(S_ID_ENTRY_VC) as? EntryVC
        
        if let window = APP_DELEGATE.window {
            window.rootViewController = rootVC
            window.rootViewController!.view.layoutIfNeeded()
            
            UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                window.rootViewController!.view.layoutIfNeeded()
                }, completion: nil)
        }
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

    class func isValidEmail(emailString:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(emailString)
        
        return result
        
    }
}

