//
//  ProductStatsVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ProductStatsVC: UITableViewController {
  
  @IBOutlet var IBtblAccountInfo: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    IBtblAccountInfo.tableFooterView = UIView()
    
  }
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
