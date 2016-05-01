//
//  UnlabelFBHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 09/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let FB_ACCESS_TOKEN = FBSDKAccessToken.currentAccessToken().tokenString
class UnlabelFBHelper: NSObject {
    class func login(fromViewController viewController:UIViewController,successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()){
        
        if let _ = FIREBASE_REF.authData{
            successBlock()
        }else{
            let facebookReadPermissions = ["public_profile", "email"]
            
            let login = FBSDKLoginManager()
    
            login.logInWithReadPermissions(facebookReadPermissions, fromViewController: viewController) { (result:FBSDKLoginManagerLoginResult!,error:NSError!) -> Void in
                print("fb---1")
                if let _ = error{
                    print("fb---2")
                    dispatch_async(dispatch_get_main_queue(), {
                      failureBlock(error)
                    })
                    return
                }else if result.isCancelled{
                    print("fb---3")
                    print("isCancelled")
                    dispatch_async(dispatch_get_main_queue(), {
                        failureBlock(NSError(domain: FB_LOGIN_FAILED.1, code: FB_LOGIN_FAILED.0, userInfo: nil))
                    })
                    return
                }else{
                    //Firebase call for authentication
                    print("fb---4")
                    dispatch_async(dispatch_get_main_queue(), {
                        FIREBASE_REF.authWithOAuthProvider("facebook", token: FB_ACCESS_TOKEN, withCompletionBlock: { (error:NSError!, authData:FAuthData!) in
                            dispatch_async(dispatch_get_main_queue(), {
                                if error != nil {
                                    print("fb---5")
                                    dispatch_async(dispatch_get_main_queue(), {
                                        failureBlock(error)
                                    })
                                    print("FB firebase Login failed. \(error)")
                                } else {
                                    print("fb---6")
                                    print("FB firebase Login success")
                                    dispatch_async(dispatch_get_main_queue(), {
                                        successBlock()
                                    })
                                }
                            })
                        })
                    })
                }
            }
        }
    }
    
    class func getUserDetails(response:(AnyObject?)->()){
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                response(result)
                print("result \(result)")
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    class func logout(){
         FBSDKLoginManager().logOut()
    }
}
