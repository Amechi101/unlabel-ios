//
//  BankConfirmVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 20/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class BankConfirmVC: UIViewController {
  
  @IBOutlet weak var IBLabelBankConfirmLabel: UILabel!
  var isTransfer: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if !isTransfer {
      IBLabelBankConfirmLabel.text = "Your Bank of America account has been successfully linked"
    } else {
      IBLabelBankConfirmLabel.text = "Your earnings have been transferred to your bank of america account successfully."
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
}
