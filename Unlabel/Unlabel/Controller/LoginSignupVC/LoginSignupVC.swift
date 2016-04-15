//
//  LoginSignupVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 16/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Batch
import Firebase

enum LoginSigupType{
    case Login
    case Signup
}

class LoginSignupVC: UIViewController {

    @IBOutlet weak var IBviewFooterContainer: UIView!
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
    var loginSignupType:LoginSigupType?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//Custom Methods
extension LoginSignupVC{
    func setupOnLoad(){
        
        stopLoading()
        
        if loginSignupType == .Login {
            IBviewFooterContainer.hidden = true
        }else{
            IBviewFooterContainer.hidden = false
        }
    }
    
    //Login Methods
    func loginWithFB(){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            handleFBLogin()
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {
                
            })
        }
    }
    
    func handleFBLogin(){
        startLoading()
        let windowTintColor = APP_DELEGATE.window?.tintColor
        APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
        UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
            APP_DELEGATE.window?.tintColor = windowTintColor
            self.stopLoading()
            self.configureBatchForPushNotification()
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
     Configure Batch
     */
    func configureBatchForPushNotification(){
        Batch.startWithAPIKey("DEV570AA966234C896E4E2F497CA2E") // dev
        // Batch.startWithAPIKey("570AA96621F60821C10E17741A43D1") // live
        BatchPush.registerForRemoteNotifications()
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


//IBActions
extension LoginSignupVC{

    @IBAction func IBActionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func IBActionFacebook(sender: UIButton) {
        if loginSignupType == .Login {
            loginWithFB()
        }else{
            loginWithFB()
        }
    }
    
    @IBAction func IBActionMobileNumber(sender: UIButton) {
        if loginSignupType == .Login {
            print("mobile login")
        }else{
          print("mobile signup")
        }
    }
    
    @IBAction func IBActionEmailOnly(sender: UIButton) {
        if loginSignupType == .Login {
            print("email login")
        }else{
          print("email signup")
        }
    }
    
}
