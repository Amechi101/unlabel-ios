//
//  EnterCityVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 20/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

@objc protocol EnterCityVCDelegate {
  func popupDidClickUpdate(_ selectedCity: String)
}

class EnterCityVC: UIViewController {
  
  @IBOutlet weak var IBLabelCity: UILabel!
  @IBOutlet weak var IBTextfieldCity: UITextField!
  @IBOutlet weak var IBViewCity: UIView!
  @IBOutlet weak var IBButtonUpdate: UIButton!
  var currentCity: String = ""
  var passwordField: PasswordFieldStatus = .empty
  var delegate:EnterCityVCDelegate?
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonUpdate.isHidden = true
    IBTextfieldCity.text = currentCity
    if (IBTextfieldCity.text != ""
      ) {
      IBLabelCity.textColor = DARK_GRAY_COLOR
      IBTextfieldCity.textColor = DARK_GRAY_COLOR
      IBViewCity.backgroundColor = DARK_GRAY_COLOR

    }
    else{
      IBLabelCity.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldCity.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewCity.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    
    delegate?.popupDidClickUpdate(self.IBTextfieldCity.text!)
    _ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func IBActionEditingChanged(_ sender: Any) {
    if (IBTextfieldCity.text != ""
      ) {
      IBButtonUpdate.isHidden = false
    }
    else{
      IBButtonUpdate.isHidden = true
    }
  }
  func updateCurrentPasswordFields(){
    if passwordField == PasswordFieldStatus.filled{
      IBLabelCity.textColor = DARK_GRAY_COLOR
      IBTextfieldCity.textColor = DARK_GRAY_COLOR
      IBViewCity.backgroundColor = DARK_GRAY_COLOR
    }
    else{
      IBLabelCity.textColor = LIGHT_GRAY_TEXT_COLOR
      IBTextfieldCity.textColor = LIGHT_GRAY_TEXT_COLOR
      IBViewCity.backgroundColor = LIGHT_GRAY_TEXT_COLOR
    }
  }
  
}
extension EnterCityVC: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == IBTextfieldCity{
      passwordField = PasswordFieldStatus.filled
      updateCurrentPasswordFields()
    }
    return true
  }
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == IBTextfieldCity{
      passwordField = PasswordFieldStatus.filled
      updateCurrentPasswordFields()
    }
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if IBTextfieldCity.text == "" {
      passwordField = PasswordFieldStatus.empty
      updateCurrentPasswordFields()
    }
  }
}
