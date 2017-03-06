//
//  LegalAgreementVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class LegalAgreementVC: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let unlabelLegalVC:UnlabelLegalVC = segue.destination as? UnlabelLegalVC{
      
      if segue.identifier == "OperationAgreement"{
        unlabelLegalVC.urlString = UnlabelHelper.getDefaultValue("operations_agreement_url")!
      }
      else if segue.identifier == "PrivatePolicy"{
        unlabelLegalVC.urlString = UnlabelHelper.getDefaultValue("privacy_policy_url")!
      }
      else if segue.identifier == "TermsAndConditions"{
        unlabelLegalVC.urlString = UnlabelHelper.getDefaultValue("terms_conditions_url")!
      }
    }
  }
}
