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
import AccountKit

enum LoginSigupType{
    case Login
    case Signup
}

enum LoginSignupSubType{
    case Phone
    case Email
    case Facebook
}


class LoginSignupVC: UIViewController{

    @IBOutlet weak var IBviewFooterContainer: UIView!
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
    let accountKit = AKFAccountKit(responseType: .AccessToken)
    var pendingLoginViewController: UIViewController?

    
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

//MARK:- FB Methods
//---------------------------------------------------------------------------------------------
extension LoginSignupVC {
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
    
    func isUserAlreadyExist(userLoginSubType:LoginSignupSubType) -> Bool{
        if userLoginSubType == .Facebook{
            dispatch_async(dispatch_get_main_queue(), {

                FIREBASE_USER_REF.queryEqualToValue(FIREBASE_REF.authData.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if snapshot.exists() {
                    print("yes")
                    }else{
                    print("not")
                    }
                })
//                FIREBASE_USER_REF.queryEqualToValue(FIREBASE_REF.authData.uid, childKey: "users").observeEventType(.Value, withBlock: { (snap:FDataSnapshot!) in
//                    print(snap)
//                })

            })
        }else if (userLoginSubType == .Email || userLoginSubType == .Phone){
            
        }else{
            return false
        }
        return false//+++++++
    }
    
    func handleFBLogin(){
        startLoading()
        let windowTintColor = APP_DELEGATE.window?.tintColor
        APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
        UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
            APP_DELEGATE.window?.tintColor = windowTintColor
            
            if self.isUserAlreadyExist(.Facebook){
            
            }else{
            
            }
            
//            //Add user data after successfull authentication
//            dispatch_async(dispatch_get_main_queue(), {
//                FirebaseHelper.addNewUser(authData, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
//                    if error != nil{
//                        print("Login failed. \(error)")
//                        dispatch_async(dispatch_get_main_queue(), {
//                            failureBlock(error)
//                        })
//                    }else{
//                        print("Login success")
//                        dispatch_async(dispatch_get_main_queue(), {
//                            successBlock()
//                        })
//                    }
//                })
//            })
            
            
//            self.stopLoading()
//            self.configureBatchForPushNotification()
//            //
//            let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
//            if let window = APP_DELEGATE.window {
//                window.rootViewController = rootNavVC
//                window.rootViewController!.view.layoutIfNeeded()
//                
//                UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
//                    window.rootViewController!.view.layoutIfNeeded()
//                    }, completion: nil)
//            }
        }) { (error:NSError?) -> () in
            self.stopLoading()
            UnlabelHelper.showAlert(onVC: self, title: "Facebook login failed!", message: "Please try again.", onOk: {
                
            })
        }
    }
}
//*********************************************************************************************


//MARK:- AccountKit Methods
//---------------------------------------------------------------------------------------------
extension LoginSignupVC:AKFViewControllerDelegate {
    
    func loginWithAccountKit(loginSubType:LoginSignupSubType){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            handleAccountKitLogin(loginSubType)
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {
                
            })
        }
    }
    
    func handleAccountKitLogin(loginSubType:LoginSignupSubType){
        pendingLoginViewController = accountKit.viewControllerForLoginResume()
        
        var viewController:AKFViewController?
        
        if loginSubType == .Phone{
            viewController = accountKit.viewControllerForPhoneLoginWithPhoneNumber(nil, state: generateState()) as? AKFViewController
        }else if loginSubType == .Email{
            viewController = accountKit.viewControllerForEmailLoginWithEmail(nil, state: generateState()) as? AKFViewController
        }else{
            viewController = accountKit.viewControllerForEmailLoginWithEmail(nil, state: generateState()) as? AKFViewController
        }
        
        if let viewControllerObj = viewController{
            viewControllerObj.enableSendToFacebook = true
            viewControllerObj.delegate = self
            presentViewController(viewControllerObj as! UIViewController, animated: true, completion: nil)
        }else{
            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {
                
            })
        }
    }
    
    private func generateState() -> String {
        let uuid = NSUUID().UUIDString
        let indexOfDash = uuid.rangeOfString("-")!.startIndex
        return uuid.substringToIndex(indexOfDash)
    }
    
    //MARK:- AKFViewControllerDelegate
    func viewController(viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("1")
    }
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("2")
        
        let newUser = [
            PRM_PROVIDER: "AccountKit",
            PRM_DISPLAY_NAME: "Zaid",//authData.providerData[PRM_DISPLAY_NAME] as? NSString as? String
            "displayImage": "jsflsjflsajfklsjf"
        ]
        
        dispatch_async(dispatch_get_main_queue(), {
            FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(accessToken.accountID).setValue(newUser, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                dispatch_async(dispatch_get_main_queue(), {
//                    block(error,firebase)
                })
            })
        })
        
        
        
        print(accessToken.accountID)
    }
    
    func viewController(viewController: UIViewController!, didFailWithError error: NSError!) {
        print("3")
    }
    
    func viewControllerDidCancel(viewController: UIViewController!) {
        print("4")
    }
  }
//*********************************************************************************************

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
            loginWithAccountKit(.Phone)
            print("mobile login")
        }else{
            loginWithAccountKit(.Phone)
          print("mobile signup")
        }
    }
    
    @IBAction func IBActionEmailOnly(sender: UIButton) {
        if loginSignupType == .Login {
            loginWithAccountKit(.Email)
            print("email login")
        }else{
            loginWithAccountKit(.Email)
          print("email signup")
        }
    }
    
}
