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
  @IBAction func IBActionGoLive(_ sender: Any) {
    self.addGoLivePopupView(CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionSelectSize(_ sender: Any) {
    self.addSortPopupView(SlideUpView.sizeSelection,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
}

//MARK: -  AddToCart Popup delegate methods

extension RentOrLiveProductDetailVC: GoLivePopupDelegate{
  
  func addGoLivePopupView(_ initialFrame:CGRect){
    if let viewForgotLabelPopup:GoLivePopupView = Bundle.main.loadNibNamed("GoLivePopupView", owner: self, options: nil)? [0] as? GoLivePopupView{
      viewForgotLabelPopup.delegate = self
      viewForgotLabelPopup.frame = initialFrame
      viewForgotLabelPopup.alpha = 0
      
      view.addSubview(viewForgotLabelPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewForgotLabelPopup.frame = self.view.frame
        viewForgotLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewForgotLabelPopup.alpha = 1
      })
    }
  }
  
  func popupDidClickCancel(){
    //delegate method to be implemented after API integration
  }
  func popupDidClickGoLive(){
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: -  Size selection popup delegate methods

extension RentOrLiveProductDetailVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.popupTitle = "SELECT A SIZE"
      viewSortPopup.frame = initialFrame
      viewSortPopup.alpha = 0
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
    }
  }
  func popupDidClickCloseButton(){
    //delegate method to be implemented after API integration
  }
  func popupDidClickDone(_ sortMode: String){
    IBSelectSize.setTitle(sortMode, for: .normal)
  }
}
