//
//  AboutUsVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 28/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import MessageUI

class AboutUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- MFMailComposeViewControllerDelegate Methods
//
extension AboutUsVC: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension AboutUsVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navVC = navigationController{
            if navVC.viewControllers.count > 1{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}


//
//MARK:- IBAction Methods
//
extension AboutUsVC{
    
    @IBAction func IBActionBack(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func IBActionSendMail(_ sender: AnyObject) {
        sendEmail()
    }
}


//
//MARK:- Custom Methods
//
extension AboutUsVC{
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            S_NO_INTERNET
            mail.setToRecipients([UNLABEL_EMAIL_ID])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            UnlabelHelper.showAlert(onVC: self, title: "Your Mail is not configured!", message: "Please confugure your mail and try again!", onOk: {
                
            })
        }
    }
}
