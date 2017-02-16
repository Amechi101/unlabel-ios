//
//  GoLivePopupView.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

@objc protocol GoLivePopupDelegate {
  func popupDidClickCancel()
  func popupDidClickGoLive()
}

class GoLivePopupView: UIView {
  
  var delegate:GoLivePopupDelegate?
  
  
  override func awakeFromNib() {
  }
  @IBAction func IBActionCancel(_ sender: Any) {
    close()
    delegate?.popupDidClickCancel()
  }
  @IBAction func IBActionGoLive(_ sender: Any) {
    close()
    delegate?.popupDidClickGoLive()
  }
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }

}
