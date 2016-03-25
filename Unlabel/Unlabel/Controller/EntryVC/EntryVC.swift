//
//  EntryVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {

    
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
            handleFBLogin()
        }
    }

    
    //
    //MARK:- Custom Methods
    //

    extension EntryVC {
        func handleFBLogin(){
            UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
                self.registerForPushNotifications()
                self.setupCognitoForFB()
                
                let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
                if let window = APP_DELEGATE.window {
                    window.rootViewController = rootNavVC
                    window.rootViewController!.view.layoutIfNeeded()
                    
                        UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            window.rootViewController!.view.layoutIfNeeded()
                        }, completion: nil)
                    }
                }) { (error:NSError?) -> () in
                    print(error)
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
        
        func setupCognitoForFB(){
            AWSHelper.configureAWSWithFBToken()
            AWSHelper.getCredentialsProvider().getIdentityId().continueWithBlock { (task: AWSTask!) -> AnyObject! in
                
                if (task.error != nil) {
                    print("Error: " + task.error!.localizedDescription)
                    
                } else {
                    // the task result will contain the identity id
                    let cognitoId = task.result
                    print(cognitoId)
                }
                return nil
            }
        }
    }