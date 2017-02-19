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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
