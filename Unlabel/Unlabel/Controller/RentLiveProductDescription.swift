//
//  RentLiveProductDescription.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class RentLiveProductDescription: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  var selectedProduct:Product?
  @IBOutlet weak var IBProductDescription: UILabel!
  @IBOutlet weak var IBMaterialCareInfo: UILabel!
  @IBOutlet weak var IBItemSKU: UILabel!
  @IBOutlet weak var IBCreator: UILabel!
 
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedProduct == nil {
      selectedProduct = Product()
    }
    IBProductDescription.text = selectedProduct?.ProductDescription
    IBMaterialCareInfo.text = selectedProduct?.ProductMaterialCareInfo
    IBItemSKU.text = selectedProduct?.ProductItemSKU
    IBCreator.text = selectedProduct?.ProductCreatorInfo
   // print(selectedProduct?.ProductDescription)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
