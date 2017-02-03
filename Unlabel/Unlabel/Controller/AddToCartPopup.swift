//
//  AddToCartPopup.swift
//  Unlabel
//
//  Created by SayOne Technologies on 06/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

//MARK: - Protocol declaration

@objc protocol AddToCartViewDelegate {
  func popupClickReserve()
  func popupDidClickCancel()
}

class AddToCartPopup: UIView{
  
  //MARK: -  IBOutlets,vars,constants
  
  var delegate:AddToCartViewDelegate?
  
  //MARK: -  View lifecycle methods
  
  override func awakeFromNib() {
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionCancel(_ sender: Any) {
    close()
    delegate?.popupDidClickCancel()
  }
  @IBAction func IBActionReserve(_ sender: Any) {
    close()
    delegate?.popupClickReserve()
  }

  
  //MARK: -  Custom methods
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
}
