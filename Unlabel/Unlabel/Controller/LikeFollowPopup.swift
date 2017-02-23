//
//  LikeFollowPopup.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

//MARK: -  Protocol declaration

@objc protocol LikeFollowPopupviewDelegate {
  func popupDidClickClosePopup()
}
//MARK: -  Follow typeenum

enum FollowType{
  case product
  case brand
  case productStatus
  case profileIncomplete
}
class LikeFollowPopup: UIView {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var productLikeView: UIView!
  @IBOutlet weak var brandFollowView: UIView!
  @IBOutlet weak var productStatusPopup: UIView!
  @IBOutlet weak var IBStatusTitle: UILabel!
  @IBOutlet weak var IBStatusMessage: UILabel!
  
  
  var delegate:LikeFollowPopupviewDelegate?
  var followType:FollowType = .product
  var productStatusTile = ""
  var productStatusMessage = ""
  
  //MARK: -  View lifecycle methods
  
  override func awakeFromNib() {
    productLikeView.isHidden = true
    brandFollowView.isHidden = true
    productStatusPopup.isHidden = true
  }
  //MARK: -  IBAction methods
  
  @IBAction func closeAction(_ sender: UIButton) {
    close()
    delegate?.popupDidClickClosePopup()
  }
  
  //MARK: -  Custom methods
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
  func updateView(){
    if followType == .product{
      productLikeView.isHidden = false
    }else if followType == .brand{
      brandFollowView.isHidden = false
    }
    else if followType == .productStatus{
      
     // print("ss \(productStatusTile)")
     // print(productStatusMessage)
      productStatusPopup.isHidden = false
      IBStatusTitle.text = "VIEW RESERVED PRODUCT"
      IBStatusMessage.text = "To check out your reserved item(s) go to your ‘Manage Content’ tab."
    }
    else if followType == .profileIncomplete{
      productStatusPopup.isHidden = false
      IBStatusTitle.text = "ENTER REQUIRED INFO"
      IBStatusMessage.text = "Please enter the required within your profile tab: Physical Attributes, Location and Image/Bio. Before you can begin to reserve."
    }
  }
  
  
}
