//
//  ChangePasswordVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

enum PasswordFieldStatus{
  case filled
  case empty
}

class ChangePasswordVC: UIViewController {
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonUpdate.isHidden = true
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func IBActionUpdate(_ sender: Any) {
  }
  @IBAction func IBActionEditingChanged(_ sender: Any) {
    if (IBTextfieldCurrentPassword.text != "" && IBTextfieldNewPassword.text != "" && IBTextfieldReEnterPassword.text != "") {
      IBButtonUpdate.isHidden = false
    }
    else{
      IBButtonUpdate.isHidden = true
    }
  }
  
  fileprivate func isValidEmail(_ IBTextFeild: UITextField)->Bool{
    
    if let iCharacters = IBTextFeild.text?.characters.count, iCharacters > 0{
      if let pwCharacters = IBTextFeild.text?.characters.count, pwCharacters < 8{
        UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Password too short at least 8 characters", onOk: { () -> () in })
      
        return false
      }
      else{
       
        return true
      }
      
    }
    else{
      UnlabelHelper.showAlert(onVC: self, title: "Password Error", message: "Please provide password to proceed", onOk: { () -> () in })
      return false
    }
  }
  func updateCurrentPasswordFields(){
    if passwordField == PasswordFieldStatus.filled{
      IBLabelCurrentPassword.textColor = DARK_GRAY_COLOR
      IBTextfieldCurrentPassword.textColor = DARK_GRAY_COLOR
      IBViewCurrentPassword.backgroundColor = DARK_GRAY_COLOR
    }
    else{
      IBLabelCurrentPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldCurrentPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewCurrentPassword.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }
  func updateNewPasswordFields(){
    if passwordField == PasswordFieldStatus.filled{
      IBLabelNewPassword.textColor = DARK_GRAY_COLOR
      IBTextfieldNewPassword.textColor = DARK_GRAY_COLOR
      IBViewNewPassword.backgroundColor = DARK_GRAY_COLOR
    }
    else{
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
    }
    else{
      IBLabelReEnterPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldReEnterPassword.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewReEnterPassword.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }
}

//MARK: -  UITextFieldDelegate Methods

extension ChangePasswordVC: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == IBTextfieldCurrentPassword{
      if isValidEmail(IBTextfieldCurrentPassword){
        IBTextfieldCurrentPassword.becomeFirstResponder()
      }else{
        
      }
    }else if textField == IBTextfieldNewPassword{
      if isValidEmail(IBTextfieldNewPassword){
        
      }else{
        
      }
    }else if textField == IBTextfieldReEnterPassword{
      if isValidEmail(IBTextfieldReEnterPassword){
      }else{
        
      }
    }
       return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == IBTextfieldCurrentPassword{
    }else if textField == IBTextfieldNewPassword{
    }else if textField == IBTextfieldReEnterPassword{
    }
    
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == IBTextfieldCurrentPassword{
    }else if textField == IBTextfieldNewPassword{
    }else if textField == IBTextfieldReEnterPassword{
    }
  }
}
