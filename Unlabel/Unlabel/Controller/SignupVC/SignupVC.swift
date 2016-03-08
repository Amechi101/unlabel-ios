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
        if textField == IBtxtFieldName{
            
        }else if textField == IBtxtFieldEmail{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.IBscrollView.contentOffset = CGPointMake(0, 60)
            })
        }else if textField == IBtxtFieldPassword{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.IBscrollView.contentOffset = CGPointMake(0, 160)
            })
        }

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.IBscrollView.contentOffset = CGPointMake(0, 0)
        })
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
        handleFBLogin()
    }
}

//
//MARK:- Custom Methods
//
extension SignupVC{
    
    func handleFBLogin(){
        UnlabelFBHelper.login(fromViewController: self, successBlock: { () -> () in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                let rootNavVC = self.storyboard!.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
                if let window = APP_DELEGATE.window {
                    UIView.transitionWithView(APP_DELEGATE.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
                        window.rootViewController = rootNavVC
                        }, completion: nil)
                }
            })
            }) { (error:NSError?) -> () in
                print(error)
        }
    }
    
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
    
}
