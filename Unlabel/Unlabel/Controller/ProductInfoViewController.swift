//
//  ProductInfoViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBProductDescription: UILabel!
  @IBOutlet weak var IBMaterialCareInfo: UILabel!
  @IBOutlet weak var IBItemSKU: UILabel!
  var selectedProduct:Product?
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedProduct == nil{
      selectedProduct = Product()
    }
    
    IBProductDescription.text = selectedProduct?.ProductDescription
    IBMaterialCareInfo.text = selectedProduct?.ProductMaterialCareInfo
    IBItemSKU.text = selectedProduct?.ProductItemSKU
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func backAction(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
}
