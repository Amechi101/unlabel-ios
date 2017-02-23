//
//  RentLiveProductDescription.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class RentLiveProductDescription: UIViewController {
  
  var selectedProduct:Product?
  @IBOutlet weak var IBProductDescription: UILabel!
  @IBOutlet weak var IBMaterialCareInfo: UILabel!
  @IBOutlet weak var IBItemSKU: UILabel!
  @IBOutlet weak var IBCreator: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if selectedProduct == nil{
      selectedProduct = Product()
    }
    
    IBProductDescription.text = selectedProduct?.ProductDescription
    IBMaterialCareInfo.text = selectedProduct?.ProductMaterialCareInfo
    IBItemSKU.text = selectedProduct?.ProductItemSKU
    IBCreator.text = selectedProduct?.ProductCreatorInfo
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  
}
