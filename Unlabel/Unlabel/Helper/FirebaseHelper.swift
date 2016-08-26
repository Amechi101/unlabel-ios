//
//  FirebaseHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

var FIREBASE_REF = Firebase(url: sFIREBASE_URL)
var FIREBASE_USERS_REF = Firebase(url: "\(sFIREBASE_URL)\(sEND_USERS)")

class FirebaseHelper: NSObject {
    
    /**
     // Update user's name
     */
    class func updateUserName(userName:String, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
            let displayName:[NSObject:AnyObject] = [PRM_DISPLAY_NAME:userName]
            dispatch_async(dispatch_get_main_queue()) {
                FIREBASE_USERS_REF.childByAppendingPath(UnlabelHelper.getDefaultValue(PRM_USER_ID)).updateChildValues(displayName, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                    block(error,firebase)
                    if error == nil{
                        debugPrint("Name Updated")
                    }else{
                        debugPrint("Name Updatation failed : \(error)")
                    }
                })
            }
    }
    
    /**
    // Add new user data after successfull authentication
    */
    class func addNewUser(userData: [String:AnyObject]!, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            if let userID:String = userData[PRM_USER_ID] as? String{
                FIREBASE_USERS_REF.childByAppendingPath(userID).setValue(userData, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                    dispatch_async(dispatch_get_main_queue(), {
                        block(error,firebase)
                    })
                })
            }
        })
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
     // Get user's following brands
     */
    class func getFollowingBrands(userID:String, withCompletionBlock block: (([String]?) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_USERS_REF.childByAppendingPath(userID).childByAppendingPath(PRM_FOLLOWING_BRANDS).observeSingleEventOfType(.Value, withBlock: { (snapshot:FDataSnapshot!) in
                 if snapshot.exists(){
                    var followingBrandIDs:[String]? = [String]()
                    
                    for children in snapshot.children{
                        followingBrandIDs?.append(children.key)
                    }
                    debugPrint("following")
                    block(followingBrandIDs)
                 }else{
                    debugPrint("not following")
                    block([String]())
                }
            })
        })
    }
    
    /**
     // Add new user data after successfull authentication
     */
    class func followUnfollowBrand(follow shouldFollow:Bool,brandID:String,userID:String, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
            if shouldFollow{
                let followValues:[NSObject:AnyObject] = [brandID:true]
                dispatch_async(dispatch_get_main_queue()) {
                  let userRef =  FIREBASE_USERS_REF.childByAppendingPath(UnlabelHelper.getDefaultValue(PRM_USER_ID))
                  
                   userRef.childByAppendingPath(PRM_FOLLOWING_BRANDS).updateChildValues(followValues, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                        block(error,firebase)
                        if error == nil{
                            debugPrint("brand followed")
                           //TODO: update firebase by something...
                        }else{
                            debugPrint("brand not followed : \(error)")
                        }
                    })
                  
//                  userRef.childByAppendingPath(PRM_FOLLOWING_BRANDS).setValue(followValues)
                }
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    FIREBASE_USERS_REF.childByAppendingPath(UnlabelHelper.getDefaultValue(PRM_USER_ID)).childByAppendingPath(PRM_FOLLOWING_BRANDS).childByAppendingPath(brandID).removeValueWithCompletionBlock({ (error:NSError!, firebase:Firebase!) in
                        block(error,firebase)
                        if error == nil{
                            debugPrint("brand removed")
                        }else{
                            debugPrint("brand not removed : \(error)")
                        }
                    })
                }
            }
    }
    
    class func logout(){
        let fireBaseRef = FIREBASE_REF
        let fireBaseUserRef = FIREBASE_USERS_REF
        
        FIREBASE_REF.unauth()
        FIREBASE_REF = nil
        
        FIREBASE_USERS_REF.unauth()
        FIREBASE_USERS_REF = nil
        
        FIREBASE_REF = fireBaseRef
        FIREBASE_USERS_REF = fireBaseUserRef
    }
}
