//
//  EntryVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase

class EntryVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
    
    //
    //MARK:- VC Lifecycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        IBactivityIndicator.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC:LegalStuffPrivacyPolicyVC = segue.destinationViewController as! LegalStuffPrivacyPolicyVC
        
        if segue.identifier == SEGUE_LEGAL_STUFF{
            destinationVC.vcType = .LegalStuff
        }else if segue.identifier == SEGUE_PRIVACY_POLICY{
            destinationVC.vcType = .PrivacyPolicy
        }
    }
}

    //
    //MARK:- IBAction Methods
    //

    extension EntryVC {
        @IBAction func IBActionContinueWithFB(sender: UIButton) {
            //Internet available
            if ReachabilitySwift.isConnectedToNetwork(){
                handleFBLogin()
            }else{
                UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {
                    
                })
            }
        }
    }

    
    //
    //MARK:- Custom Methods
    //

    extension EntryVC {
        func handleFBLogin(){
            startLoading()
            let windowTintColor = APP_DELEGATE.window?.tintColor

            APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
            UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
            APP_DELEGATE.window?.tintColor = windowTintColor
                self.stopLoading()
                self.registerForPushNotifications()
                //
                let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
                if let window = APP_DELEGATE.window {
                    window.rootViewController = rootNavVC
                    window.rootViewController!.view.layoutIfNeeded()
                    
                    UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        window.rootViewController!.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }) { (error:NSError?) -> () in
                    self.stopLoading()
                UnlabelHelper.showAlert(onVC: self, title: "Facebook login failed!", message: "Please try again.", onOk: {
                    
                })
            }
        }
        
        /**
         Register current device to recieve push notifications
         */
        func registerForPushNotifications(){
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        
        /**
         Start loading
         */
        func startLoading(){
            dispatch_async(dispatch_get_main_queue()) {
                self.IBactivityIndicator.hidden = false
                self.IBactivityIndicator.startAnimating()
            }
        }
        
        /**
         Stop loading
         */
        func stopLoading(){
            dispatch_async(dispatch_get_main_queue()) {
                self.IBactivityIndicator.hidden = true
                self.IBactivityIndicator.stopAnimating()
            }
        }
    }