//
//  SettingsViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController,MFMailComposeViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 2 {
      contachUsAction()
    }
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func contachUsAction() {
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }
  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients(["info@unlabel.us"])
    mailComposerVC.setSubject("Unlabel: ICC Support")
    mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
    
    return mailComposerVC
  }
  
  func showSendMailErrorAlert() {
    UnlabelHelper.showAlert(onVC: self, title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", onOk: {})
  }
  
  // MARK: MFMailComposeViewControllerDelegate Method
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
  
  
}
