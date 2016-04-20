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
                    
                    block(followingBrandIDs)
                 }else{
                    print("not following")
                    block([String]())
                }
            })
        })
        
//        dispatch_async(dispatch_get_main_queue()) {
//            FirebaseHelper.checkIfUserExists(forID: userID, withBlock: { (snapshot:FDataSnapshot!) in
//                
//                //Following some brands
//                if let followingBrands:[String] = snapshot.value[PRM_FOLLOWING_BRANDS] as? [String]{
//                    dispatch_async(dispatch_get_main_queue(), {
//                      block(followingBrands)
//                    })
//                }
//            })
//        }
    }
    
    /**
     // Add new user data after successfull authentication
     */
    class func followUnfollowBrand(follow shouldFollow:Bool,brandID:String,userID:String, withCompletionBlock block: ((NSError!, Firebase!) -> Void)!){
            if shouldFollow{
                let followValues:[NSObject:AnyObject] = [brandID:true]
                dispatch_async(dispatch_get_main_queue()) {
                    FIREBASE_USERS_REF.childByAppendingPath(UnlabelHelper.getDefaultValue(PRM_USER_ID)).childByAppendingPath(PRM_FOLLOWING_BRANDS).updateChildValues(followValues, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                        block(error,firebase)
                        if error == nil{
                            print("brand followed")
                        }else{
                            print("brand not followed : \(error)")
                        }
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    FIREBASE_USERS_REF.childByAppendingPath(UnlabelHelper.getDefaultValue(PRM_USER_ID)).childByAppendingPath(PRM_FOLLOWING_BRANDS).childByAppendingPath(brandID).removeValueWithCompletionBlock({ (error:NSError!, firebase:Firebase!) in
                        block(error,firebase)
                        if error == nil{
                            print("brand removed")
                        }else{
                            print("brand not removed : \(error)")
                        }
                    })
                }
            }
            
          
            
//            FirebaseHelper.checkIfUserExists(forID: userID, withBlock: { (snapshot:FDataSnapshot!) in
//                
//                //If following brands exist,add new brand
//                if let followingBrands = snapshot.value[PRM_FOLLOWING_BRANDS] as? [String:AnyObject]{
//                    
//                    FIREBASE_USERS_REF.childByAppendingPath(FIREBASE_REF.authData.uid).childByAppendingPath(PRM_FOLLOWING_BRANDS).updateChildValues(followingBrands) { (error:NSError!, firebase:Firebase!) in
//                        block(error,firebase)
//                    }
//                    
//                //If not following any brand
//                }else{
//                
//                }
//            })
        
    }
    
//                var newFollowingBrands:[String]?
//                
//                //Following some brands
//                if var followingBrands:[String] = snapshot.value[PRM_FOLLOWING_BRANDS] as? [String]{
//                    
//                    //Follow brand
//                    if shouldFollow{
//                        followingBrands.append(brandID)
//                        newFollowingBrands = followingBrands
//                        
//                    //Unfollow brand
//                    }else{
//                        for (index,currentBrandID) in followingBrands.enumerate(){
//                            if currentBrandID == brandID{
//                                followingBrands.removeAtIndex(index)
//                            }
//                        }
//                    }
//                    
//                //Not following any brand
//                }else{
//                    if shouldFollow{
//                        newFollowingBrands = [brandID]
//                    }
//                }
//                
//                let newSnap:[NSObject:AnyObject]?
//                
//                if newFollowingBrands?.count > 0{
//                    newSnap = [
//                        PRM_FOLLOWING_BRANDS: newFollowingBrands as! AnyObject
//                    ]
//                }else{
//                    newSnap = [:]
//                }
//                
//                dispatch_async(dispatch_get_main_queue()) {
                
//        }
        
//        FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(FIREBASE_REF.authData.uid).updateChildValues(newBrand) { (error:NSError!, firebase:Firebase!) in
//         block(error,firebase)   
//        }
//    }
    
    class func logout(){
        let ref = Firebase(url: sFIREBASE_URL)
        ref.unauth()
    }
}
