//
//  RentOrLiveProductDetailVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 09/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class RentOrLiveProductDetailVC: UIViewController {
  
  @IBOutlet weak var productImageCollectionView: UICollectionView!
  @IBOutlet weak var productPageControl: UIPageControl!
  @IBOutlet weak var IBSelectSize: UIButton!
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBProductTitle: UILabel!
  @IBOutlet weak var IBProductPrice: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionDismissView(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
