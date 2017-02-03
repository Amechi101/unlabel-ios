//
//  FilterViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionStoreType(_ sender: Any) {
    performSegue(withIdentifier: SEGUE_FILTER_LABELS, sender: sender)
  }
  @IBAction func IBActionCategory(_ sender: Any) {

  }
  
   @IBAction func IBActionStyle(_ sender: Any) {
    
  }
  @IBAction func IBActionLocation(_ sender: Any) {
    
  }
  @IBAction func IBActionShowFilteredResults(_ sender: Any) {
    
  }
}
