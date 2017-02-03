//
//  SignUpEntryVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 23/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class SignUpEntryVC: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet weak var IBTextfieldFullname: UITextField!
  @IBOutlet weak var IBTextfieldEmail: UITextField!
  @IBOutlet weak var IBTextfieldPassword: UITextField!
  @IBOutlet weak var IBscrollView: UIScrollView!
  var user = User()
  
  //MARK:- View Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//MARK:-   IBAction methods

extension SignUpEntryVC{
  @IBAction func IBActionSignup(_ sender: Any) {
    IBTextfieldFullname.resignFirstResponder()
    IBTextfieldEmail.resignFirstResponder()
    IBTextfieldPassword.resignFirstResponder()
    user.email = IBTextfieldEmail.text!
    user.password = IBTextfieldPassword.text!
    user.fullName = IBTextfieldFullname.text!
    
    
    if isValidName() && isValidEmail() && isValidUserPassword(){
      if ReachabilitySwift.isConnectedToNetwork(){
        UnlabelLoadingView.sharedInstance.start(view)
        wsSignupWithEmail()
      }else{
        UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
    }else{
      
    }
  }
  @IBAction func IBActionClose(_ sender: Any) {
    self.dismiss(animated: true) { () -> Void in
    }
  }
  @IBAction func IBActionTerms(_ sender: Any) {
    openSafariForURL(URL_TERMS)
  }
  @IBAction func IBActionPrivacy(_ sender: Any) {
    openSafariForURL(URL_PRIVACY_POLICY)
  }
}

//MARK:- UITextFieldDelegate Methods

extension SignUpEntryVC:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == IBTextfieldFullname{
      if isValidName(){
        IBTextfieldEmail.becomeFirstResponder()
      }else{
        
      }
    }else if textField == IBTextfieldEmail{
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
    if textField == IBTextfieldFullname{
      
    }else if textField == IBTextfieldEmail{
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.IBscrollView.contentOffset = CGPoint(x: 0, y: 60)
      })
    }else if textField == IBTextfieldPassword{
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.IBscrollView.contentOffset = CGPoint(x: 0, y: 160)
      })
    }
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      self.IBscrollView.contentOffset = CGPoint(x: 0, y: 0)
    })
  }
}

//MARK:- Custom Methods

extension SignUpEntryVC{
  fileprivate func wsSignupWithEmail(){
    let regParams = User()
    regParams.email = IBTextfieldEmail.text!
    regParams.password = IBTextfieldPassword.text!
    regParams.fullName = IBTextfieldFullname.text!
    UnlabelAPIHelper.sharedInstance.registerToUnlabel(regParams,onVC:self, success:
      { (json: JSON,statusCode:Int) in
        UnlabelHelper.goToBrandVC(self.storyboard!)
    },failed: { (error) in
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }
  fileprivate func isValidName()->Bool{
    if let iCharacters = IBTextfieldFullname.text?.characters.count, iCharacters > 0{
      if let iCharacters = IBTextfieldFullname.text?.characters.count, iCharacters > 30{
        UnlabelHelper.showAlert(onVC: self, title: "Invalid Fullname", message: "Full name should be less than 30 characters.", onOk: { () -> () in })
        return false
      }
      else{
        if UnlabelHelper.isValidName(IBTextfieldFullname.text!){
          return true
        }else{
          UnlabelHelper.showAlert(onVC: self, title: "Invalid Fullname", message: "Full name should contain letters only.", onOk: { () -> () in })
          return false
        }
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: "Name Can't Be Empty", message: "Please Provide Your Name To Proceed.", onOk: { () -> () in })
      return false
    }
  }
  
  fileprivate func isValidEmail()->Bool{
    if let email = IBTextfieldEmail.text, email.characters.count > 0{
      if UnlabelHelper.isValidEmail(IBTextfieldEmail.text!){
        if let email = IBTextfieldEmail.text, email.characters.count > 30{
          UnlabelHelper.showAlert(onVC: self, title: "Invalid Email", message: "Email must be less than 30 characters.", onOk: { () -> () in })
          return false
        }
        else{
          return true
        }
        
      }else{
        UnlabelHelper.showAlert(onVC: self, title: "Invalid Email", message: "Please Provide Correct Email To Proceed.", onOk: { () -> () in })
        return false
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: "Email Can't Be Empty", message: "Please Provide Your Email To Proceed.", onOk: { () -> () in })
      return false
    }
  }
  
  fileprivate func isValidUserPassword()->Bool{
    
    if let iCharacters = IBTextfieldPassword.text?.characters.count, iCharacters > 0{
      return true
    }
    else{
      UnlabelHelper.showAlert(onVC: self, title: "Password Can't Be Empty", message: "Please Provide Password To Proceed.", onOk: { () -> () in })
      return false
    }
  }
  
  
}

//MARK: - Safari ViewController Delegate Methods

extension SignUpEntryVC: SFSafariViewControllerDelegate{
  func openSafariForURL(_ urlString:String){
    if let productURL:URL = URL(string: urlString){
      APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
      let safariVC = SFSafariViewController(url: productURL)
      safariVC.delegate = self
      self.present(safariVC, animated: true) { () -> Void in
        
      }
    }else{ showAlertWebPageNotAvailable() }
  }
  
  func showAlertWebPageNotAvailable(){
    UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
      
    }
  }
  
  func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity]{
    return []
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController){
    APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
  }
  
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
    
  }
}


