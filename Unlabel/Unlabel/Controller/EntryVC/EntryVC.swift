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
    
    @IBOutlet weak var IBconstraintLogoY: NSLayoutConstraint!
    @IBOutlet weak var IBlblAbout: UILabel!
    @IBOutlet weak var IBviewBottom: UIView!
    @IBOutlet weak var IBbtnSkip: UIButton!
    @IBOutlet weak var IBbtnLogin: UIButton!
    //
    //MARK:- VC Lifecycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        IBconstraintLogoY.constant = -(SCREEN_HEIGHT/4)
        UIView.animateWithDuration(0.5) {
            self.IBlblAbout.alpha = 1
            self.IBviewBottom.alpha = 1
            self.IBbtnSkip.alpha = 1
            self.IBbtnLogin.alpha = 1
            self.view.layoutIfNeeded()
        }
        UnlabelHelper.setBoolValue(true, key: sENTRY_ONCE_SEEN)
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
            destinationVC.delegate = self
        }else if segue.identifier == SEGUE_SIGNUP{
            destinationVC.loginSignupType = .Signup
        }
    }
}

//
//MARK:- LoginSignupVCDelegate
//
extension EntryVC:LoginSignupVCDelegate{
    func willDidmissViewController() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

//
//MARK:- IBActions
//
extension EntryVC{
    @IBAction func IBActionSkip(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}