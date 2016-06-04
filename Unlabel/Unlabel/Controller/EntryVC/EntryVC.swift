//
//  EntryVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Batch
import Firebase

class EntryVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    
    
    //
    //MARK:- VC Lifecycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC:LoginSignupVC = segue.destinationViewController as! LoginSignupVC
        
        if segue.identifier == SEGUE_LOGIN{
            destinationVC.loginSignupType = .Login
        }else if segue.identifier == SEGUE_SIGNUP{
            destinationVC.loginSignupType = .Signup
        }
    }
}