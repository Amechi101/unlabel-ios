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

let fbAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
class UnlabelFBHelper: NSObject {
    class func login(fromViewController viewController:UIViewController,successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()){
        
        if let _ = FBSDKAccessToken.currentAccessToken(){
            failureBlock(NSError(domain: FB_ALREADY_LOGGED_IN.1, code: FB_ALREADY_LOGGED_IN.0, userInfo: nil))
        }else{
            let facebookReadPermissions = ["public_profile", "email"]
            
            let login = FBSDKLoginManager()
    
            login.logInWithReadPermissions(facebookReadPermissions, fromViewController: viewController) { (result:FBSDKLoginManagerLoginResult!,error:NSError!) -> Void in
            
                if let _ = error{
                    failureBlock(error)
                    return
                }else if result.isCancelled{
                    print("isCancelled")
                    failureBlock(NSError(domain: FB_LOGIN_FAILED.1, code: FB_LOGIN_FAILED.0, userInfo: nil))
                    return
                }else{
                    //Firebase call for authentication
                    FIREBASE_REF.authWithOAuthProvider("facebook", token: fbAccessToken, withCompletionBlock: { (error:NSError!, authData:FAuthData!) in
                        if error != nil {
                            failureBlock(error)
                            print("Login failed. \(error)")
                        } else {
                            //Add user data after successfull authentication
                            FirebaseHelper.addNewUser(authData, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                                if error != nil{
                                    print("Login failed. \(error)")
                                    failureBlock(error)
                                }else{
                                    print("Login success")
                                    successBlock()
                                }
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
