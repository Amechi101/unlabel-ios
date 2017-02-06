//
//  ViewForgotPasswordPopup.swift
//  Unlabel
//
//  Created by SayOne on 21/12/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

//MARK: -  Protocol declaration

@objc protocol ForgotPasswordPopupviewDelegate {
  @objc optional func popupClickAction(_ email:String)
  func popupDidClickClose()
}

//MARK: -  Popup action enums

enum PopupAction{
  case recover
  case ok
  case fail
}

class ViewForgotPasswordPopup: UIView,UITextFieldDelegate{
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var failStatusLabel: UILabel!
  @IBOutlet weak var popupTitle: UILabel!
  @IBOutlet weak var successStatusLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var emailContainerView: UIView!
  @IBOutlet weak var emailTextfield: UITextField!
  
  var delegate:ForgotPasswordPopupviewDelegate?
  var popupAction:PopupAction = .recover
  
  
  
  
  //MARK:- View Lifecycle
  
  override func awakeFromNib() {
    if popupAction == .recover || popupAction == .fail{
      emailTextfield.becomeFirstResponder()
    }
    successStatusLabel.isHidden = true
    failStatusLabel.isHidden = true
    failStatusLabel.text = "We couldn’t find your email. Please try again!"
  }
  
  
  //MARK:- IBAction Methods
  
  @IBAction func closeAction(_ sender: UIButton) {
    emailTextfield.resignFirstResponder()
    close()
    delegate?.popupDidClickClose()
  }
  
  @IBAction func IBActionEditingChanged(_ sender: Any) {
    if emailTextfield.text != "" {
      emailTextfield.textColor = DARK_GRAY_COLOR
      failStatusLabel.isHidden = true
      actionButton.backgroundColor = DARK_GRAY_COLOR
      actionButton.isEnabled = true
      emailContainerView.backgroundColor = DARK_GRAY_COLOR
    }
    else{
      emailContainerView.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      actionButton.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      actionButton.isEnabled = false
    }
  }

  
  @IBAction func passwordAction(_ sender: UIButton) {
    
    if popupAction == .recover || popupAction == .fail{
      if isValidEmail(){
        emailTextfield.resignFirstResponder()
        intialClose()
        delegate?.popupClickAction!(emailTextfield.text!)
      }
      else{
        
      }
    }
    else if popupAction == .ok{
      close()
      delegate?.popupDidClickClose()
    }
  }

  //MARK: -  Custom methods
  
  fileprivate func intialClose(){
    self.frame.origin.y = SCREEN_HEIGHT
    self.removeFromSuperview()
  }
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
  func updateView(){
    if popupAction == .recover{
      emailContainerView.backgroundColor = DARK_GRAY_COLOR
      emailTextfield.textColor = DARK_GRAY_COLOR
      successStatusLabel.isHidden = true
      failStatusLabel.isHidden = true
    }else if popupAction == .ok{
      emailContainerView.backgroundColor = DARK_GRAY_COLOR
      emailTextfield.textColor = DARK_GRAY_COLOR
      successStatusLabel.isHidden = false
      failStatusLabel.isHidden = true
      emailContainerView.isHidden = true
      actionButton.setTitle("OK", for: .normal)
      actionButton.isHidden = false
      actionButton.backgroundColor = DARK_GRAY_COLOR
      popupTitle.isHidden = true
      actionButton.isEnabled = true
    }else if popupAction == .fail{
      actionButton.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      emailContainerView.backgroundColor = DARK_RED_COLOR
      emailTextfield.textColor = DARK_RED_COLOR
      successStatusLabel.isHidden = true
      failStatusLabel.isHidden = false
      emailContainerView.isHidden = false
      actionButton.setTitle("RECOVER PASSWORD", for: .normal)
    }else{
      debugPrint("Popup type unknown")
    }
  }
  fileprivate func isValidEmail()->Bool{
    if let email = emailTextfield.text, email.characters.count > 0{
      if UnlabelHelper.isValidEmail(emailTextfield.text!){
        emailContainerView.backgroundColor = DARK_GRAY_COLOR
        actionButton.isEnabled = true
        return true
      }else{
        failStatusLabel.text = "This email address doesn’t look quite right"
        emailContainerView.backgroundColor = DARK_RED_COLOR
        emailTextfield.textColor = DARK_RED_COLOR
        return false
      }
    }
    else{
      return false
    }
  }
  
  //MARK: -  Textfield delegate methods
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == emailTextfield{
      if isValidEmail(){
        emailTextfield.resignFirstResponder()
      }else{
        
      }
    }
    
    return true
  }
  
 // func text
  
  
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if (emailTextfield.text?.isEmpty)!{
    }
    else{
      actionButton.backgroundColor = DARK_GRAY_COLOR
      emailContainerView.backgroundColor = DARK_GRAY_COLOR
      actionButton.isEnabled = true
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if emailTextfield.text?.characters.count == 0{
      actionButton.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      emailContainerView.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      actionButton.isEnabled = false
    }
  }
}
