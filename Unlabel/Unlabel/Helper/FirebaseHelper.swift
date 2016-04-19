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
    class func addNewUser(userData: [String:AnyObject]!, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
        print(userData)
        if let userID:String = userData[PRM_USER_ID] as? String{
            dispatch_async(dispatch_get_main_queue(), {
                FIREBASE_USERS_REF.childByAppendingPath(userID).setValue(userData, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                    dispatch_async(dispatch_get_main_queue(), {
                        block(error,firebase)
                    })
                })
            })
        }
    }
    
    
    /**
     Check if user exist for specific id.
     */
    class func checkIfUserExists(forID id:String, withBlock block: ((FDataSnapshot!) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_USERS_REF.childByAppendingPath(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                dispatch_async(dispatch_get_main_queue(), {
                    block(snapshot)
                })
            })
        })
    }
    
    /**
     // Add new user data after successfull authentication
     */
    class func followUnfollowBrand(follow shouldFollow:Bool,brandID:String,userID:String, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
        dispatch_async(dispatch_get_main_queue()) {
            FirebaseHelper.checkIfUserExists(forID: userID, withBlock: { (snapshot:FDataSnapshot!) in
                
                var newFollowingBrands:[String]?
                
                //Following some brands
                if var followingBrands:[String] = snapshot.value[PRM_FOLLOWING_BRANDS] as? [String]{
                    
                    //Follow brand
                    if shouldFollow{
                        followingBrands.append(brandID)
                        newFollowingBrands = followingBrands
                        
                    //Unfollow brand
                    }else{
                        for (index,currentBrandID) in followingBrands.enumerate(){
                            if currentBrandID == brandID{
                                followingBrands.removeAtIndex(index)
                            }
                        }
                    }
                    
                //Not following any brand
                }else{
                    if shouldFollow{
                        newFollowingBrands = [brandID]
                    }
                }
                
                let newSnap:[NSObject:AnyObject]?
                
                if newFollowingBrands?.count > 0{
                    newSnap = [
                        PRM_FOLLOWING_BRANDS: newFollowingBrands as! AnyObject
                    ]
                }else{
                    newSnap = [:]
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                FIREBASE_USERS_REF.childByAppendingPath(FIREBASE_REF.authData.uid).updateChildValues(newSnap) { (error:NSError!, firebase:Firebase!) in
                    block(error,firebase)
                    }
                }
                
            })
        }
        
//        FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(FIREBASE_REF.authData.uid).updateChildValues(newBrand) { (error:NSError!, firebase:Firebase!) in
//         block(error,firebase)   
//        }
    }
    
    class func logout(){
        let ref = Firebase(url: sFIREBASE_URL)
        ref.unauth()
    }
}
