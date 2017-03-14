//
//  SeeMoreDescriptionVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/03/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class SeeMoreDescriptionVC: UIViewController {
  
  var selectedBrand:Brand?
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBLabelDescription: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedBrand == nil {
      selectedBrand = Brand()
    }
    IBbtnTitle.setTitle(selectedBrand?.Name.uppercased(), for: UIControlState())
    IBLabelDescription.text = self.selectedBrand?.Description
  }
  @IBAction func backAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
