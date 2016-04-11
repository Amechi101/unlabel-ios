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
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    let ref = Firebase(url: sFIREBASE_URL)
                    
                    ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error:NSError!, authData:FAuthData!) in
                        if error != nil {
                            failureBlock(error)
                            print("Login failed. \(error)")
                        } else {
                            if let userName = authData.providerData[sDISPLAY_NAME]{
                                UnlabelHelper.setDefaultValue(userName as! String, key: sDISPLAY_NAME)
                            }
                            
                            if let userProfilePic = authData.providerData[sPROFILE_IMAGE_URL]{
                                UnlabelHelper.setDefaultValue(userProfilePic as! String, key: sPROFILE_IMAGE_URL)
                            }
                            
                            let newUser = [
                                sPROVIDER: authData.provider,
                                sDISPLAY_NAME: authData.providerData[sDISPLAY_NAME] as? NSString as? String
                            ]
                            
                            ref.childByAppendingPath("users")
                                .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            
                            successBlock()
                        }
                    })
                    print("Login success")
                    return
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
