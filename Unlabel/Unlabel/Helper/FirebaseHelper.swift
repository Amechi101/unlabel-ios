//
//  FirebaseHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

let FIREBASE_REF = Firebase(url: sFIREBASE_URL)
let FIREBASE_USERS_REF = Firebase(url: "\(sFIREBASE_URL)\(sEND_USERS)")

class FirebaseHelper: NSObject {
    
    /**
    // Add new user data after successfull authentication
    */
    class func addNewUser(authData: FAuthData!, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
        
        if let userName = authData.providerData[PRM_DISPLAY_NAME]{
            UnlabelHelper.setDefaultValue(userName as! String, key: PRM_DISPLAY_NAME)
        }
        
        if let userProfilePic = authData.providerData[PRM_PROFILE_IMAGE_URL]{
            UnlabelHelper.setDefaultValue(userProfilePic as! String, key: PRM_PROFILE_IMAGE_URL)
        }
        
        let newUser = [
            PRM_PROVIDER: authData.provider,
            PRM_DISPLAY_NAME: authData.providerData[PRM_DISPLAY_NAME] as? NSString as? String
        ]
        
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_USERS_REF.childByAppendingPath(authData.uid).setValue(newUser, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                dispatch_async(dispatch_get_main_queue(), {
                    block(error,firebase)
                })
            })
        })
    }
    
   
    
    /**
     Check if user exist for specific id.
     */
    class func checkIfUserExists(forID id:String, withBlock block: ((FDataSnapshot!) -> Void)!){
        FIREBASE_USERS_REF.childByAppendingPath(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            block(snapshot)
        })
    }
    
    
    /**
     // Add new user data after successfull authentication
     */
    class func followBrand(brandID:String,userID:String, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
        
        let newBrand = [
            PRM_FOLLOWING_LABALES_COUNT: 2,
            PRM_FOLLOWING_LABALES: ["1","2"]
        ]
        FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(FIREBASE_REF.authData.uid).updateChildValues(newBrand) { (error:NSError!, firebase:Firebase!) in
         block(error,firebase)   
        }
    }
    
    class func logout(){
        let ref = Firebase(url: sFIREBASE_URL)
        ref.unauth()
    }
}
