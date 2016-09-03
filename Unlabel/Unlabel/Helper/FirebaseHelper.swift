//
//  FirebaseHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


//var FIREBASE_REF = Firebase(url: sFIREBASE_URL)
//var FIREBASE_USERS_REF = Firebase(url: "\(sFIREBASE_URL)\(sEND_USERS)")

let FIREBASE_REF = FIRDatabase.database().reference()
let FIREBASE_USERS_REF = FIREBASE_REF.child(sEND_USERS)

class FirebaseHelper: NSObject {
    
    /**
     Info.plist method
     */
    class func configure(){
        FIRApp.configure()
    }
    
    /**
     // Update user's name
     */
    class func updateUser(userDict userDict:[String:AnyObject],completion:(NSError?)->()){
        if let currentUser = FIRAuth.auth()?.currentUser{
            FIREBASE_REF.child(sEND_USERS).child(currentUser.uid).updateChildValues(userDict) { (error, reference) in
                completion(error)
                
            }
        }else{
            debugPrint("updateUser failed")
        }
    }
    
    /**
    // Add new user data after successfull authentication
    */
    class func addNewUser(userData: [String:AnyObject]!, withCompletionBlock block: ((NSError!, FIRDatabaseReference!) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            if let userID:String = userData[PRM_USER_ID] as? String{
                FIREBASE_USERS_REF.child(userID).setValue(userData, withCompletionBlock: { (error,dbRef) in
                    dispatch_async(dispatch_get_main_queue(), {
                        block(error,dbRef)
                    })
                })
            }
        })
    }
    
    
    /**
     Check if user exist for specific id.
     */
    class func checkIfUserExists(forID id:String, withBlock block: ((FIRDataSnapshot) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_USERS_REF.child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                dispatch_async(dispatch_get_main_queue(), {
                    block(snapshot)
                })
            })
        })
    }
 
    
//    
//    /**
//     // Get user's following brands
//     */
    class func getFollowingBrands(userID:String, withCompletionBlock block: (([String]?) -> Void)!){
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_USERS_REF.child(userID).child(PRM_FOLLOWING_BRANDS).observeSingleEventOfType(.Value, withBlock: { (snapshot:FIRDataSnapshot!) in
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
//
//    /**
//     // Add new user data after successfull authentication
//     */
    class func followUnfollowBrand(follow shouldFollow:Bool,brandID:String,userID:String, withCompletionBlock block: ((NSError!, FIRDatabaseReference!) -> Void)!){
            if shouldFollow{
                let followValues:[NSObject:AnyObject] = [brandID:true]
                dispatch_async(dispatch_get_main_queue()) {
                  let userRef =  FIREBASE_USERS_REF.child(UnlabelHelper.getDefaultValue(PRM_USER_ID)!)
                  
                   userRef.child(PRM_FOLLOWING_BRANDS).updateChildValues(followValues, withCompletionBlock: { (error, firebase) in
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
                    FIREBASE_USERS_REF.child(UnlabelHelper.getDefaultValue(PRM_USER_ID)!).child(PRM_FOLLOWING_BRANDS).child(brandID).removeValueWithCompletionBlock({ (error, firebase) in
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
        if let _ = FIRAuth.auth()?.currentUser{
            try! FIRAuth.auth()!.signOut()
        }else{
            debugPrint("User is not signed In")
        }
    }
}
