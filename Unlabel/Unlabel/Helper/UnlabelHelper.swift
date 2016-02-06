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
    class func showAlert(onVC OnVC:UIViewController,title:String,message:String,onOk:()->()){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                onOk()
            }))
            OnVC.presentViewController(alert, animated: true, completion: nil)
            
        }
    }

}
