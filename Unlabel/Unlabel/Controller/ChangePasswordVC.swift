//
//  ChangePasswordVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON


//MARK:- Enums 

enum PasswordFieldStatus{
  case filled
  case empty
}

class ChangePasswordVC: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet weak var IBLabelCurrentPassword: UILabel!
  @IBOutlet weak var IBTextfieldCurrentPassword: UITextField!
  @IBOutlet weak var IBViewCurrentPassword: UIView!
  @IBOutlet weak var IBTextfieldNewPassword: UITextField!
  @IBOutlet weak var IBLabelNewPassword: UILabel!
  @IBOutlet weak var IBViewNewPassword: UIView!
  @IBOutlet weak var IBTextfieldReEnterPassword: UITextField!
  @IBOutlet weak var IBViewReEnterPassword: UIView!
  @IBOutlet weak var IBLabelReEnterPassword: UILabel!
  @IBOutlet weak var IBButtonUpdate: UIButton!
  var passwordField: PasswordFieldStatus = .empty
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonUpdate.isHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

//MARK: -  UITextFieldDelegate Methods

extension ChangePasswordVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == IBTextfieldCurrentPassword {
      if isValidPassword(IBTextfieldCurrentPassword) {
        passwordField = PasswordFieldStatus.filled
        updateCurrentPasswordFields()
        IBTextfieldNewPassword.becomeFirstResponder()
      }
    } else if textField == IBTextfieldNewPassword {
      if isValidPassword(IBTextfieldNewPassword) {
        passwordField = PasswordFieldStatus.filled
        updateNewPasswordFields()
        IBTextfieldReEnterPassword.becomeFirstResponder()
      }
    } else if textField == IBTextfieldReEnterPassword {
      if isValidPassword(IBTextfieldReEnterPassword) {
        passwordField = PasswordFieldStatus.filled
        updateReEnterPasswordFields()
      }
    }
    
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == IBTextfieldCurrentPassword {
      passwordField = PasswordFieldStatus.filled
      updateCurrentPasswordFields()
    } else if textField == IBTextfieldNewPassword {
      passwordField = PasswordFieldStatus.filled
      updateNewPasswordFields()
    } else if textField == IBTextfieldReEnterPassword {
      passwordField = PasswordFieldStatus.filled
      updateReEnterPasswordFields()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == IBTextfieldCurrentPassword {
      if IBTextfieldCurrentPassword.text == "" {
        passwordField = PasswordFieldStatus.empty
        updateCurrentPasswordFields()
      }
    } else if textField == IBTextfieldNewPassword {
      if IBTextfieldNewPassword.text == "" {
        passwordField = PasswordFieldStatus.empty
        updateNewPasswordFields()
      }
    } else if textField == IBTextfieldReEnterPassword {
      if IBTextfieldReEnterPassword.text == "" {
        passwordField = PasswordFieldStatus.empty
        updateReEnterPasswordFields()
      }
    }
  }
}

//MARK:- IBAction Methods

extension ChangePasswordVC
{
  @IBAction func IBActionUpdate(_ sender: Any) {
    if !isValidPassword(IBTextfieldCurrentPassword) {
      
      return
    } else if !isValidPassword(IBTextfieldNewPassword) {
      
      return
    } else if IBTextfieldNewPassword.text == IBTextfieldReEnterPassword.text {
      saveInfluencerProfileInfo()
    } else {
      UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Please provide matching passwords", onOk: { () -> () in })
    }
  }
  
  @IBAction func IBActionEditingChanged(_ sender: Any) {
    if (IBTextfieldCurrentPassword.text != "" && IBTextfieldNewPassword.text != "" && IBTextfieldReEnterPassword.text != "") {
      IBButtonUpdate.isHidden = false
    } else {
      IBButtonUpdate.isHidden = true
    }
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}

//MARK:- Custom Methods

extension ChangePasswordVC {
  
  func wsLogout() {
    UnlabelAPIHelper.sharedInstance.logoutFromUnlabel(self, success:
      { (json: JSON) in
        print(json)
        UnlabelHelper.logout()
    },failed: { (error) in
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }

  func saveInfluencerProfileInfo() {
    var passParams: [String: String] = [:]
    passParams["current_password"] = IBTextfieldCurrentPassword.text
    passParams["new_password"] = IBTextfieldNewPassword.text
    passParams["retype_password"] = IBTextfieldReEnterPassword.text
    UnlabelAPIHelper.sharedInstance.changePassword( passParams,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      UnlabelHelper.clearCookie()
      UnlabelHelper.removePrefForKey("ULCookie")
      UnlabelHelper.removePrefForKey("X-CSRFToken")
      let rootTabVC = UIStoryboard(name: "Unlabel", bundle: nil).instantiateViewController(withIdentifier: "BannerViewController") as? BannerViewController
      if let window = APP_DELEGATE.window {
        window.rootViewController = rootTabVC
        window.rootViewController!.view.layoutIfNeeded()
        UIView.transition(with: APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
          window.rootViewController!.view.layoutIfNeeded()
        }, completion: nil)
      }
    }, failed: { (error) in
    })
  }
  
  func updateCurrentPasswordFields(){
    if passwordField == PasswordFieldStatus.filled {
      IBLabelCurrentPassword.textColor = DARK_GRAY_COLOR
      IBTextfieldCurrentPassword.textColor = DARK_GRAY_COLOR
      IBViewCurrentPassword.backgroundColor = DARK_GRAY_COLOR
    } else {
      IBLabelCurrentPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldCurrentPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewCurrentPassword.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }
  
  func updateNewPasswordFields(){
    if passwordField == PasswordFieldStatus.filled {
      IBLabelNewPassword.textColor = DARK_GRAY_COLOR
      IBTextfieldNewPassword.textColor = DARK_GRAY_COLOR
      IBViewNewPassword.backgroundColor = DARK_GRAY_COLOR
    } else {
      IBLabelNewPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldNewPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewNewPassword.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }
  
  func updateReEnterPasswordFields(){
    if passwordField == PasswordFieldStatus.filled{
      IBLabelReEnterPassword.textColor = DARK_GRAY_COLOR
      IBTextfieldReEnterPassword.textColor = DARK_GRAY_COLOR
      IBViewReEnterPassword.backgroundColor = DARK_GRAY_COLOR
    } else {
      IBLabelReEnterPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldReEnterPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewReEnterPassword.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }

  fileprivate func isValidPassword(_ IBTextFeild: UITextField)->Bool {
    if let iCharacters = IBTextFeild.text?.characters.count, iCharacters > 0 {
      if let pwCharacters = IBTextFeild.text?.characters.count, pwCharacters < 8 {
        UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Password too short at least 8 characters", onOk: { () -> () in })
        
        return false
      } else {
        
        return true
      }
    } else {
      UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Please provide password to proceed", onOk: { () -> () in })
      
      return false
    }
  }
}
