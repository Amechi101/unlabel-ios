//
//  LoginEntryVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 23/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum LoginScenario{
  case idle
  case wrong
  case ok
}

class LoginEntryVC: UIViewController {
  
  //MARK:- IBOutlets, vars and constants
  @IBOutlet weak var IBLblEmail: UILabel!
  @IBOutlet weak var IBLblPassword: UILabel!
  @IBOutlet weak var IBEmailLine: UIView!
  @IBOutlet weak var IBPasswordLine: UIView!
  @IBOutlet weak var IBLoginButton: UIButton!
  
  @IBOutlet weak var IBscrollView: UIScrollView!
  @IBOutlet weak var IBTextfieldEmail: UITextField!
  @IBOutlet weak var IBTextfieldPassword: UITextField!
  var user = User()
  var loginScenario: LoginScenario = LoginScenario.idle
  
  
  //MARK:- View lifecyle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  

}

//MARK:- Custom methods
extension LoginEntryVC{
  func updateEmailFields(){
    if loginScenario == LoginScenario.idle{
      IBLblEmail.textColor = LIGHT_GRAY_TEXT_COLOR
      IBEmailLine.backgroundColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldEmail.textColor = LIGHT_GRAY_TEXT_COLOR
    }
    else if loginScenario == LoginScenario.ok{
      IBLblEmail.textColor = MEDIUM_GRAY_TEXT_COLOR
      IBEmailLine.backgroundColor = MEDIUM_GRAY_TEXT_COLOR
      IBTextfieldEmail.textColor = MEDIUM_GRAY_TEXT_COLOR
    }
    else if loginScenario == LoginScenario.wrong{
      IBLblEmail.textColor = DARK_RED_COLOR
      IBEmailLine.backgroundColor = DARK_RED_COLOR
      IBTextfieldEmail.textColor = DARK_RED_COLOR
    }
    
  }
  func updatePasswordFields(){
    if loginScenario == LoginScenario.idle{
      IBLblPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBPasswordLine.backgroundColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldPassword.textColor = LIGHT_GRAY_TEXT_COLOR
    }
    else if loginScenario == LoginScenario.ok{
      IBLblPassword.textColor = MEDIUM_GRAY_TEXT_COLOR
      IBPasswordLine.backgroundColor = MEDIUM_GRAY_TEXT_COLOR
      IBTextfieldPassword.textColor = MEDIUM_GRAY_TEXT_COLOR
    }
    else if loginScenario == LoginScenario.wrong{
      IBLblPassword.textColor = DARK_RED_COLOR
      IBPasswordLine.backgroundColor = DARK_RED_COLOR
      IBTextfieldPassword.textColor = DARK_RED_COLOR
    }
  }
}

//MARK:- IBAction methods

extension LoginEntryVC{
  @IBAction func IBActionClose(_ sender: Any) {
    self.dismiss(animated: true) { () -> Void in
      
    }
  }
  @IBAction func IBLoginAction(_ sender: Any) {
    IBTextfieldEmail.resignFirstResponder()
    IBTextfieldPassword.resignFirstResponder()
    user.email = IBTextfieldEmail.text!
    user.password = IBTextfieldPassword.text!
    if isValidEmail() && isValidUserPassword(){
      
      if ReachabilitySwift.isConnectedToNetwork(){
        UnlabelLoadingView.sharedInstance.start(view)
        wsLoginWithEmail()
      }else{
        UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
    }else{
    }
    
  }
  @IBAction func IBForgotPassword(_ sender: Any) {
    self.addForgotPopupView(PopupAction.recover, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionEditingChanged(_ sender: Any) {
    if (IBTextfieldEmail.text != "" && IBTextfieldPassword.text != "") {
      IBLoginButton.backgroundColor = DARK_GRAY_COLOR
      IBLoginButton.isEnabled = true
    }
    else{
      IBLoginButton.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      IBLoginButton.isEnabled = false
    }
  }

}

//MARK:- API methods

extension LoginEntryVC{
  
  func wsForgotPassword(){
    UnlabelAPIHelper.sharedInstance.forgotPassword(user, onVC: self, success: {
      (json: JSON,statusCode:Int) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      if statusCode == s_OK{
        
        self.addForgotPopupView(PopupAction.ok, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
      else{
        self.addForgotPopupView(PopupAction.fail, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
    }, failed: { (error) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }
  

  func getInfluencerDetails(){
    UnlabelAPIHelper.sharedInstance.getProfileDetails({ (
      meta: JSON) in
      print(meta)
      UnlabelHelper.setDefaultValue(meta["email"].stringValue, key: "influencer_email")
      UnlabelHelper.setDefaultValue(meta["last_name"].stringValue, key: "influencer_last_name")
      UnlabelHelper.setDefaultValue(meta["auto_id"].stringValue, key: "influencer_auto_id")
      UnlabelHelper.setDefaultValue(meta["image"].stringValue, key: "influencer_image")
      UnlabelHelper.setDefaultValue(meta["first_name"].stringValue, key: "influencer_first_name")
    }, failed: { (error) in
    })
  }
  
  func wsRegisterDevice(){
    var udid = UIDevice.current.identifierForVendor!.uuidString
    udid = udid.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
    print("UDID == \(udid)")
    let deviceToken = UnlabelHelper.getDefaultValue("device_token")
    let params = ["udid":udid,"push_token":deviceToken,"device_type":"iOS"]
    UnlabelAPIHelper.sharedInstance.registerDeviceToUnlabel(params as! [String : String],onVC:self, success:
      { (json: JSON,statusCode:Int) in
    },failed: { (error) in
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }
  
  func wsLoginWithEmail(){
    let loginParams = User()
    loginParams.email = IBTextfieldEmail.text!
    loginParams.password = IBTextfieldPassword.text!
    UnlabelAPIHelper.sharedInstance.loginToUnlabel(loginParams,onVC:self, success:
      { (json: JSON,statusCode:Int) in
        UnlabelLoadingView.sharedInstance.stop(self.view)
        if statusCode == s_OK{
          self.getInfluencerDetails()
          self.wsRegisterDevice()
          UnlabelHelper.goToBrandVC(self.storyboard!)
        }
        else if statusCode == s_Unauthorised{
          self.loginScenario = LoginScenario.wrong
          self.updateEmailFields()
          self.updatePasswordFields()
          UnlabelHelper.showAlert(onVC: self, title: "Email/Password Error", message: "Wrong email and password combination", onOk: { () -> () in
            self.loginScenario = LoginScenario.ok
            self.updateEmailFields()
            self.updatePasswordFields()
          })
        }
    },failed: { (error) in
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }
}

//MARK: -  UITextFieldDelegate Methods

extension LoginEntryVC: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == IBTextfieldEmail{
      if isValidEmail(){
        IBTextfieldPassword.becomeFirstResponder()
      }else{
        
      }
    }else if textField == IBTextfieldPassword{
      if isValidUserPassword(){
        
      }else{
        
      }
      IBTextfieldPassword.resignFirstResponder()
    }else{
      
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == IBTextfieldEmail{
      //IBTextfieldEmail.text = ""
      loginScenario = LoginScenario.ok
      updateEmailFields()
    }
    else{
     // IBTextfieldPassword.text = ""
      loginScenario = LoginScenario.ok
      updatePasswordFields()
    }

  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == IBTextfieldEmail{
     if IBTextfieldEmail.text == "" && isValidEmail(){
      loginScenario = LoginScenario.idle
      updateEmailFields()
      }
    }
    else if textField == IBTextfieldPassword{
      if IBTextfieldPassword.text == "" && isValidUserPassword(){
        loginScenario = LoginScenario.idle
        updatePasswordFields()
      }
    }
  }
  
}

//MARK: -  Text Field Validation Methods

extension LoginEntryVC{
  fileprivate func isValidEmail()->Bool{
    if let email = IBTextfieldEmail.text, email.characters.count > 0{
      if UnlabelHelper.isValidEmail(IBTextfieldEmail.text!){
        if let email = IBTextfieldEmail.text, email.characters.count > 30{
          UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Email must be less than 30 characters", onOk: { () -> () in })
          loginScenario = LoginScenario.wrong
          updateEmailFields()
          return false
        }
        else{
          loginScenario = LoginScenario.ok
          updateEmailFields()
          return true
        }
      }else{
        UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "This email address doesn’t look quite right", onOk: { () -> () in })
        loginScenario = LoginScenario.wrong
        updateEmailFields()
        return false
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Please provide your email to proceed", onOk: { () -> () in })
      loginScenario = LoginScenario.wrong
      updateEmailFields()
      return false
    }
  }
  
  fileprivate func isValidUserPassword()->Bool{
    
    if let iCharacters = IBTextfieldPassword.text?.characters.count, iCharacters > 0{
      if let pwCharacters = IBTextfieldPassword.text?.characters.count, pwCharacters < 8{
        UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Password too short at least 8 characters", onOk: { () -> () in })
        loginScenario = LoginScenario.wrong
        updatePasswordFields()
        return false
      }
      else{
        loginScenario = LoginScenario.ok
        updatePasswordFields()
        return true
      }
      
    }
    else{
      UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Please provide password to proceed", onOk: { () -> () in })
      loginScenario = LoginScenario.wrong
      updatePasswordFields()
      return false
    }
  }
}

//MARK: -  ForgotPasswordPopup Delegate methods

extension LoginEntryVC: ForgotPasswordPopupviewDelegate{
  
  func addForgotPopupView(_ popupAction:PopupAction,initialFrame:CGRect){
    if let viewForgotLabelPopup:ViewForgotPasswordPopup = Bundle.main.loadNibNamed(FORGET_PASSWORD_POPUP, owner: self, options: nil)? [0] as? ViewForgotPasswordPopup{
      viewForgotLabelPopup.delegate = self
      viewForgotLabelPopup.popupAction = popupAction
      viewForgotLabelPopup.frame = initialFrame
      viewForgotLabelPopup.alpha = 0
      
      //debugPrint(viewForgotLabelPopup)
      view.addSubview(viewForgotLabelPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewForgotLabelPopup.frame = self.view.frame
        viewForgotLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewForgotLabelPopup.alpha = 1
      })
      viewForgotLabelPopup.updateView()
    }
  }
  
  func popupDidClickCancel(){
    
  }
  
  func popupClickAction(_ email:String){
  //  debugPrint(email)
    user.email = email
    if ReachabilitySwift.isConnectedToNetwork(){
      UnlabelLoadingView.sharedInstance.start(view)
      wsForgotPassword()
    }else{
      UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
    }
    
  }
  
  func popupDidClickClose(){
    
  }
}

