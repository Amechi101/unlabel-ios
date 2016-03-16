//
//  EntryVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToEntry(segue:UIStoryboardSegue){
    
    }
    
    @IBAction func IBActionContinueWithFB(sender: UIButton) {
      handleFBLogin()
    }

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
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
