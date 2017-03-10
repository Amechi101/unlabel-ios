//
//  EditProfileVC.swift
//  Unlabel
//
//  Created by Ravisankar V on 19/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SwiftyJSON

class EditProfileVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBTextfieldFullname: UITextField!
  @IBOutlet weak var IBLabelFullname: UILabel!
  @IBOutlet weak var IBViewfullname: UIView!
  @IBOutlet weak var IBLabelLastname: UILabel!
  @IBOutlet weak var IBtextfieldLastname: UITextField!
  @IBOutlet weak var IBViewLastname: UIView!
  @IBOutlet weak var IBLabelEmail: UILabel!
  @IBOutlet weak var IBtextfieldEmail: UITextField!
  @IBOutlet weak var IBViewEmail: UIView!
  @IBOutlet weak var IBTextfieldContactNumber: UITextField!
  @IBOutlet weak var IBTextfieldUsername: UITextField!
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getInfluencerProfileInfo()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    if !isValidEmail() {
      // shows alert in isValidEmail() method
    }else if (IBTextfieldFullname.text?.isEmpty)! || (IBtextfieldLastname.text?.isEmpty)! || (IBTextfieldContactNumber.text?.isEmpty)!{
      UnlabelHelper.showAlert(onVC: self, title: "Empty Input", message: "Please provide value for all field.", onOk: {})
    }
    else{
      saveInfluencerProfileInfo()
    }
  }
  @IBAction func IBActionBack(_ sender: Any) {
    
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  
  //MARK: -  Custom methods
  
  func getInfluencerProfileInfo() {
    UnlabelAPIHelper.sharedInstance.getProfileInfo( self, success:{ (
      meta: JSON) in
      print(meta)
      DispatchQueue.main.async(execute: { () -> Void in
        self.IBTextfieldFullname.text = meta["first_name"].stringValue
        self.IBtextfieldLastname.text = meta["last_name"].stringValue
        self.IBtextfieldEmail.text = meta["email"].stringValue
        self.IBTextfieldContactNumber.text = meta["contact_number"].stringValue
      })
      
    }, failed: { (error) in
    })
    
  }
  func saveInfluencerProfileInfo() {
    let userParam = User()
    userParam.firstname = IBTextfieldFullname.text!
    userParam.lastname = IBtextfieldLastname.text!
    userParam.email = IBtextfieldEmail.text!
    userParam.contactNumber = IBTextfieldContactNumber.text!
    UnlabelAPIHelper.sharedInstance.saveProfileInfo( userParam,onVC: self, success:{ (
      meta: JSON,statusCode) in
      print(statusCode)
      if statusCode == 200{
        _ = self.navigationController?.popViewController(animated: true)
      }
      else if statusCode == 203{
        UnlabelHelper.showAlert(onVC: self, title: "Error", message: meta["message"].stringValue, onOk: {})
      }
      print(meta)
      
    }, failed: { (error) in
    })
  }
}

//MARK: -  UITextfield delegate methods

extension EditProfileVC: UITextFieldDelegate{
  fileprivate func isValidEmail()->Bool{
    if let email = IBtextfieldEmail.text, email.characters.count > 0{
      if UnlabelHelper.isValidEmail(IBtextfieldEmail.text!){
        if let email = IBtextfieldEmail.text, email.characters.count > 30{
          UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Email must be less than 30 characters", onOk: { () -> () in })
          return false
        }
        else{
          return true
        }
      }else{
        UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "This email address doesn’t look quite right", onOk: { () -> () in })
        return false
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Please provide your email to proceed", onOk: { () -> () in })
      return false
    }
  }
}
