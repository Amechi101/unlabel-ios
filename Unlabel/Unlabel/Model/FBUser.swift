//
//  FBUser.swift
//  Unlabel
//
//  Created by SayOne Technologies on 04/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class FBUser{

    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: FBUser = FBUser()
    
    //MARK: Local Variable
    
    var email : String = String()
    var fullName : String = String()
    var accessToken : String = String()
    var fbID : String = String()

}
