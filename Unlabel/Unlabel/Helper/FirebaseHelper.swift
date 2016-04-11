//
//  FirebaseHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHelper: NSObject {
    class func logout(){
        let ref = Firebase(url: sFIREBASE_URL)
        ref.unauth()
    }
}
