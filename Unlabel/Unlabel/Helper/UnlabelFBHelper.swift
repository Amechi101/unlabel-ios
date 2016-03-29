//
//  UnlabelFBHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 09/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UnlabelFBHelper: NSObject {
    class func login(fromViewController viewController:UIViewController,successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()){
        
        if let _ = FBSDKAccessToken.currentAccessToken(){
            failureBlock(NSError(domain: FB_ALREADY_LOGGED_IN.1, code: FB_ALREADY_LOGGED_IN.0, userInfo: nil))
        }else{
            let facebookReadPermissions = ["public_profile", "email", "user_friends"]
            
            let login = FBSDKLoginManager()
            login.logInWithReadPermissions(facebookReadPermissions, fromViewController: viewController) { (result:FBSDKLoginManagerLoginResult!,error:NSError!) -> Void in
                
                if let _ = error{
                    failureBlock(error)
                    return
                }
                
                if result.isCancelled{
                    print("isCancelled")
                    failureBlock(NSError(domain: FB_LOGIN_FAILED.1, code: FB_LOGIN_FAILED.0, userInfo: nil))
                    return
                }else{
                    successBlock()
                    print("Login success")
                    return
                }
            }
        }
    }
    
    class func logout(){
         FBSDKLoginManager().logOut()
    }
}
