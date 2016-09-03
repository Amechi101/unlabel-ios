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
        
        if let currentUser = FIRAuth.auth()?.currentUser{
            successBlock()
        }else{
            let facebookReadPermissions = ["public_profile", "email"]
            
            let login = FBSDKLoginManager()
    
            login.logInWithReadPermissions(facebookReadPermissions, fromViewController: viewController) { (result:FBSDKLoginManagerLoginResult!,error:NSError!) -> Void in
                if let _ = error{
                    dispatch_async(dispatch_get_main_queue(), {
                      failureBlock(error)
                    })
                    return
                }else if result.isCancelled{
                    dispatch_async(dispatch_get_main_queue(), {
                        failureBlock(NSError(domain: FB_LOGIN_FAILED.1, code: FB_LOGIN_FAILED.0, userInfo: nil))
                    })
                    return
                }else{
                    //Firebase call for authentication
                    dispatch_async(dispatch_get_main_queue(), {
                        if let credential:FIRAuthCredential = FIRFacebookAuthProvider.credentialWithAccessToken(FB_ACCESS_TOKEN){
                            FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                                dispatch_async(dispatch_get_main_queue(), {
                                    if error != nil {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            failureBlock(error)
                                        })
                                        debugPrint("FB firebase Login failed. \(error)")
                                    } else {
                                        debugPrint("FB firebase Login success")
                                        dispatch_async(dispatch_get_main_queue(), {
                                            successBlock()
                                        })
                                    }
                                })
                            })
                        }
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
                debugPrint("result \(result)")
            }
            else
            {
                debugPrint("error \(error)")
            }
        })
    }
    
    class func logout(){
         FBSDKLoginManager().logOut()
    }
}
