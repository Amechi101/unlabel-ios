//
//  SignupVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtxtFieldName: UITextField!
    @IBOutlet weak var IBtxtFieldEmail: UITextField!
    @IBOutlet weak var IBtxtFieldPassword: UITextField!
    
    @IBOutlet weak var IBbtnSignUp: UIButton!
    @IBOutlet weak var IBscrollView: UIScrollView!
    
    var kbHeight: CGFloat!
    

//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(animated:Bool) {
//        super.viewWillAppear(animated)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}


//
//MARK:- UITextFieldDelegate Methods
//
extension SignupVC:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == IBtxtFieldName{
            if isValidName(){
                IBtxtFieldEmail.becomeFirstResponder()
            }else{
            
            }
        }else if textField == IBtxtFieldEmail{
            if isValidEmail(){
                IBtxtFieldPassword.becomeFirstResponder()
            }else{
                
            }
        }else if textField == IBtxtFieldPassword{
            if isValidUserPassword(){
                
            }else{
                
            }
        }else{
        
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
       
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    
    }
}


//
//MARK:- IBAction Methods
//
extension SignupVC{
    @IBAction func IBActionClose(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func IBActionSignupWithFB(sender: UIButton) {
        
    }
}

//
//MARK:- Custom Methods
//
extension SignupVC{
    func isValidName()->Bool{
        if let iCharacters = IBtxtFieldName.text?.characters.count where iCharacters > 0{
            return true
        }else{
            UnlabelHelper.showAlert(onVC: self, title: "Name Can't Be Empty", message: "Please Provide Your Name To Proceed.", onOk: { () -> () in })
            return false
        }
    }
    
    func isValidEmail()->Bool{
        if let email = IBtxtFieldEmail.text where email.characters.count > 0{
            if UnlabelHelper.isValidEmail(IBtxtFieldEmail.text!){
                return true
            }else{
                UnlabelHelper.showAlert(onVC: self, title: "Invalid Email", message: "Please Provide Correct Email To Proceed.", onOk: { () -> () in })
                return false
            }
        }else{
            UnlabelHelper.showAlert(onVC: self, title: "Email Can't Be Empty", message: "Please Provide Your Email To Proceed.", onOk: { () -> () in })
            return false
        }
    }
    
    func isValidUserPassword()->Bool{
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        for subview in self.view.subviews{
            if subview.isFirstResponder(){
                if subview == IBtxtFieldName{

                }else if subview == IBtxtFieldEmail{
                    UIView.animateWithDuration(0, animations: { () -> Void in
                        self.view.center.y = self.view.frame.size.height/2 - 100
                    })
                }else if subview == IBtxtFieldPassword{
                    UIView.animateWithDuration(0, animations: { () -> Void in
                        self.view.center.y = self.view.frame.size.height/2 - 150
                    })
                }
            }
        }
//        if let userInfo = notification.userInfo {
//            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//                kbHeight = keyboardSize.height
//                self.animateTextField(true)
//            }
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.view.center.y = self.view.frame.size.height/2
        })
    }
    
    func animateTextField(up: Bool) {
//        let movement = (up ? -kbHeight : kbHeight)
        
        
    
    }
}
