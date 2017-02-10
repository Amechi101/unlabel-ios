//
//  RentOrLiveProductDetailVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 09/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class RentOrLiveProductDetailVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var productImageCollectionView: UICollectionView!
  @IBOutlet weak var productPageControl: UIPageControl!
  @IBOutlet weak var IBSelectSize: UIButton!
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBProductTitle: UILabel!
  @IBOutlet weak var IBProductPrice: UILabel!
  @IBOutlet weak var IBBtnProductDetail: UIButton!
  @IBOutlet weak var IBBtnProductImage: UIButton!
  @IBOutlet weak var IBBtnProductNote: UIButton!
  @IBOutlet weak var IBBtnProductStats: UIButton!
  @IBOutlet weak var IBBtnGoLive: UIButton!
  @IBOutlet weak var IBConstraintStatsHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintSelectSizeHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintGoLive: NSLayoutConstraint!
  @IBOutlet weak var IBScrollView: UIScrollView!
  @IBOutlet weak var IBViewStats: UIView!
  var contentStatus: ContentStatus = .unreserved
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBScrollView.contentInset = UIEdgeInsetsMake(-64.0, 0.0, 0.0, 0.0)
    IBScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(-64.0, 0.0, 0.0, 0.0)
    if contentStatus == ContentStatus.live{
      IBConstraintGoLive.constant = 0.0
    }
    else if contentStatus == ContentStatus.rent{
      IBConstraintStatsHeight.constant = 0.0
      IBViewStats.isHidden = true
      IBConstraintSelectSizeHeight.constant = 0.0
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionDismissView(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
