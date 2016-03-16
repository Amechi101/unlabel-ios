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
}

    //
    //MARK:- IBAction Methods
    //

    extension EntryVC {
        @IBAction func unwindToEntry(segue:UIStoryboardSegue){
            
        }
        
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
                
                self.setupCognitoForFB()
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
                    if let window = APP_DELEGATE.window {
                        UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            window.rootViewController = rootNavVC
                            }, completion: nil)
                    }
                })
                }) { (error:NSError?) -> () in
                    print(error)
            }
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