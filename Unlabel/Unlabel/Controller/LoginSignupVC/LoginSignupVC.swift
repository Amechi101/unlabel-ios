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


let AccountKit = AKFAccountKit(responseType: .AccessToken)

class LoginSignupVC: UIViewController{

    @IBOutlet weak var IBviewFooterContainer: UIView!
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
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
    
}

//---------------------------------------------------------------------------------------------
//MARK:- FB Methods
//---------------------------------------------------------------------------------------------
extension LoginSignupVC {
    //Login Methods
    func loginWithFB(){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            handleFBLogin()
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }
    
    func handleFBLogin(){
        let windowTintColor = APP_DELEGATE.window?.tintColor
        APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
        
        UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
            APP_DELEGATE.window?.tintColor = windowTintColor
            
            if let authData = FIREBASE_REF.authData{
                dispatch_async(dispatch_get_main_queue(), {
                    self.isUserAlreadyExist(authData.uid, userLoginSubType: .Facebook) { (snapshot:FDataSnapshot) in
                        
                        if snapshot.exists() {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.handleUserExist(snapshot)
                            })
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.handleUserDoesntExist(.Facebook)
                            })
                        }
                    }
                })
            }else{
                self.stopLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
            }
            
        }) { (error:NSError?) -> () in
            self.stopLoading()
            UnlabelHelper.showAlert(onVC: self, title: "Facebook login failed!", message: "Please try again.", onOk: {})
        }
        
    }
    
}
//---------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------
//MARK:- AccountKit Methods
//---------------------------------------------------------------------------------------------
extension LoginSignupVC:AKFViewControllerDelegate {
    
    func loginWithAccountKit(loginSubType:LoginSignupSubType){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            handleAccountKitLogin(loginSubType)
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }
    
    func handleAccountKitLogin(loginSubType:LoginSignupSubType){
        pendingLoginViewController = AccountKit.viewControllerForLoginResume()
        
        var viewController:AKFViewController?
        
        if loginSubType == .Phone{
            viewController = AccountKit.viewControllerForPhoneLoginWithPhoneNumber(nil, state: generateState()) as? AKFViewController
        }else if loginSubType == .Email{
            viewController = AccountKit.viewControllerForEmailLoginWithEmail(nil, state: generateState()) as? AKFViewController
        }else{
            viewController = AccountKit.viewControllerForEmailLoginWithEmail(nil, state: generateState()) as? AKFViewController
        }
        
        if let viewControllerObj = viewController{
            viewControllerObj.enableSendToFacebook = true
            viewControllerObj.delegate = self
            presentViewController(viewControllerObj as! UIViewController, animated: true, completion: nil)
        }else{
            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
        }
    }
    
    private func generateState() -> String {
        let uuid = NSUUID().UUIDString
        let indexOfDash = uuid.rangeOfString("-")!.startIndex
        return uuid.substringToIndex(indexOfDash)
    }
    
    //-------------------------------------------------------------------------
    //MARK:- AKFViewControllerDelegate
    //-------------------------------------------------------------------------
    func viewController(viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("1")
    }
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        startLoading()
        if let accountID:String = accessToken.accountID{
            self.isUserAlreadyExist(accountID, userLoginSubType: .Email) { (snapshot:FDataSnapshot) in
                
                if snapshot.exists() {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.handleUserExist(snapshot)
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.handleUserDoesntExist(.Email)
                    })
                }
            }
        }else{
            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
        }
    }
    
    func viewController(viewController: UIViewController!, didFailWithError error: NSError!) {
        print("3")
        stopLoading()
    }
    
    func viewControllerDidCancel(viewController: UIViewController!) {
        stopLoading()
        print("4")
    }
    
  }
//---------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------
//MARK:- Custom Methods
//---------------------------------------------------------------------------------------------
extension LoginSignupVC{
    
    private func isUserAlreadyExist(userID:String,userLoginSubType:LoginSignupSubType,block:(FDataSnapshot)->Void){
        
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            dispatch_async(dispatch_get_main_queue(), {
                FirebaseHelper.checkIfUserExists(forID: userID, withBlock: { (snapshot:FDataSnapshot!) in
                        block(snapshot)
                    })
                })
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }

    /**
     handleUserExist on Firebase
     */
    private func handleUserExist(snapshot:FDataSnapshot){
        print(snapshot)
        
        var userInfo:[String:AnyObject] = [:]
        
        if let phoneNumber = snapshot.value[PRM_PHONE]{
            userInfo[PRM_PHONE] = phoneNumber
        }
        
        if let emailAddress = snapshot.value[PRM_EMAIL]{
            userInfo[PRM_EMAIL] = emailAddress
        }
        
        if let accountID = snapshot.value[PRM_USER_ID]{
            userInfo[PRM_USER_ID] = accountID
        }
        
        if let displayName = snapshot.value[PRM_DISPLAY_NAME]{
            userInfo[PRM_DISPLAY_NAME] = displayName
        }
        
        if let provider = snapshot.value[PRM_PROVIDER]{
            userInfo[PRM_PROVIDER] = provider
        }
        
        if let displayName = snapshot.value[PRM_DISPLAY_NAME]{
            userInfo[PRM_DISPLAY_NAME] = displayName
        }
        
        if let displayName = snapshot.value[PRM_DISPLAY_NAME]{
            userInfo[PRM_DISPLAY_NAME] = displayName
        }
        
        goToFeedVC(withUserInfo: userInfo)
    }
    
    private func goToFeedVC(withUserInfo userInfo:[String:AnyObject]){
       
        self.configureBatchForPushNotification()
        
        if let userID:String = userInfo[PRM_USER_ID] as? String{
            UnlabelHelper.setDefaultValue(userID, key: PRM_USER_ID)
        }
        
        if let phoneNumber:String = userInfo[PRM_PHONE] as? String{
            UnlabelHelper.setDefaultValue(phoneNumber, key: PRM_PHONE)
        }
        
        if let emailAddress:String = userInfo[PRM_EMAIL] as? String{
            UnlabelHelper.setDefaultValue(emailAddress, key: PRM_EMAIL)
        }
        
        if let displayName:String = userInfo[PRM_DISPLAY_NAME] as? String{
            UnlabelHelper.setDefaultValue(displayName, key: PRM_DISPLAY_NAME)
        }
        
        if let provider:String = userInfo[PRM_PROVIDER] as? String{
            UnlabelHelper.setDefaultValue(provider, key: PRM_PROVIDER)
        }
    
        if let storyboardObj = storyboard{
            let rootNavVC = storyboardObj.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
            if let window = APP_DELEGATE.window {
                window.rootViewController = rootNavVC
                window.rootViewController!.view.layoutIfNeeded()
                
                if let window = APP_DELEGATE.window{
                    UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        window.rootViewController!.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        }
        

    }
    
    /**
     handleUserDoesn'tExist on Firebase
     */
    private func handleUserDoesntExist(subType: LoginSignupSubType){
        print("doesn't exist")
        var userInfo:[String:AnyObject] = [:]
        
        if subType == .Email || subType == .Phone {
            //Add user data after successfull authentication
            AccountKit.requestAccount({ (account:AKFAccount?, error:NSError?) in
                
                if let phoneNumber = account?.phoneNumber?.stringRepresentation(){
                    userInfo[PRM_PHONE] = phoneNumber
                }
                
                if let emailAddress = account?.emailAddress{
                    userInfo[PRM_EMAIL] = emailAddress
                }
                
                if let accountID = account?.accountID{
                    userInfo[PRM_USER_ID] = "\(accountID)"
                    userInfo[PRM_DISPLAY_NAME] = "User: \(accountID)"
                }
                
                userInfo[PRM_PROVIDER] = S_PROVIDER_ACCOUNTKIT
                userInfo[PRM_CURRENT_FOLLOWING_COUNT] = 0
                userInfo[PRM_FOLLOWING_BRANDS] = [:]
                
                self.handleAddNewUser(userInfo)
            })
        }else if subType == .Facebook{
            
            if let emailAddress = FIREBASE_REF.authData.providerData[PRM_EMAIL]{
                userInfo[PRM_EMAIL] = emailAddress
            }
            
            if let displayName = FIREBASE_REF.authData.providerData[PRM_DISPLAY_NAME]{
                userInfo[PRM_DISPLAY_NAME] = displayName
            }
            
            if let userID = FIREBASE_REF.authData.uid{
                userInfo[PRM_USER_ID] = "\(userID)"
            }
            
            userInfo[PRM_PROVIDER] = S_PROVIDER_FACEBOOK
            
            userInfo[PRM_CURRENT_FOLLOWING_COUNT] = 0
            userInfo[PRM_FOLLOWING_BRANDS] = [:]
            
            handleAddNewUser(userInfo)
        }else{
            
        }
    }

    private func handleAddNewUser(userInfo:[String:AnyObject]){
        dispatch_async(dispatch_get_main_queue(), {
            FirebaseHelper.addNewUser(userInfo, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                dispatch_async(dispatch_get_main_queue(), {
                if error != nil{
                    self.stopLoading()
                    print("User adding failed \(error)")
                        UnlabelHelper.showAlert(onVC: self, title: error.localizedDescription, message: S_TRY_AGAIN, onOk: {})
                }else{
                    print("User adding success")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.goToFeedVC(withUserInfo: userInfo)
                    })
                }
                    })
            })
        })
    }
    
    private func setupOnLoad(){
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
    private func configureBatchForPushNotification(){
        Batch.startWithAPIKey("DEV570AA966234C896E4E2F497CA2E") // dev
        // Batch.startWithAPIKey("570AA96621F60821C10E17741A43D1") // live
        BatchPush.registerForRemoteNotifications()
    }
    
    /**
     Start loading
     */
    private func startLoading(){
        dispatch_async(dispatch_get_main_queue()) {
            self.IBactivityIndicator.hidden = false
            self.IBactivityIndicator.startAnimating()
        }
    }
    
    /**
     Stop loading
     */
    private func stopLoading(){
        dispatch_async(dispatch_get_main_queue()) {
            self.IBactivityIndicator.hidden = true
            self.IBactivityIndicator.stopAnimating()
        }
    }

}
//---------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------
//MARK:- IBActions
//---------------------------------------------------------------------------------------------
extension LoginSignupVC{

    @IBAction func IBActionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func IBActionFacebook(sender: UIButton) {
        startLoading()
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
//---------------------------------------------------------------------------------------------
