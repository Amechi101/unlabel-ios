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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- MFMailComposeViewControllerDelegate Methods
//
extension AboutUsVC: MFMailComposeViewControllerDelegate{
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


//
//MARK:- IBAction Methods
//
extension AboutUsVC{
    
    @IBAction func IBActionBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func IBActionSendMail(sender: AnyObject) {
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
            mail.setToRecipients(["info@unlabel.us"])
            mail.setMessageBody("", isHTML: true)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
}