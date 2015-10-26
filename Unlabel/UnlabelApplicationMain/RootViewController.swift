//
//  RootViewController.swift
//  Unlabel
//
//  Created by Amechi Egbe on 10/25/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import ParseUI

class RootViewController: UIViewController, PFLogInViewControllerDelegate {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            let loginViewController = PFLogInViewController();
            loginViewController.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil);
        }
    }
    
}
