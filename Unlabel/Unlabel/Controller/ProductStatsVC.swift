//
//  ProductStatsVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ProductStatsVC: UITableViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet var IBtblAccountInfo: UITableView!
 
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBtblAccountInfo.tableFooterView = UIView()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
