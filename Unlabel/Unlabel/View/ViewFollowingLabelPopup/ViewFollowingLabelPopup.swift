//
//  ViewFollowingLabelPopup.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

@objc protocol PopupviewDelegate {
  @objc optional func popupDidClickGrey()
  @objc optional func popupDidClickRed()
  func popupDidClickClose()
}

enum PopupType{
  case removeBank
  case transferFund
}

class ViewFollowingLabelPopup: UIView {
  

  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet weak var IBlblTitle: UILabel!
  @IBOutlet weak var IBlblSubTitle: UILabel!
  
  @IBOutlet weak var IBButtonRed: UIButton!
  @IBOutlet weak var IBButtonGrey: UIButton!
  var delegate:PopupviewDelegate?
  var popupType:PopupType = .removeBank
  let fundAmount : String = "0.00"

  //MARK:- View Lifecycle
  
  override func awakeFromNib() {
    
  }
  
  
  //MARK:- IBAction Methods
  
  @IBAction func IBActionClose(_ sender: UIButton) {
    close()
    delegate?.popupDidClickClose()
  }
  
  @IBAction func IBActionCancel(_ sender: UIButton) {
    close()
    delegate?.popupDidClickGrey!()
  }
  
  @IBAction func IBActionDelete(_ sender: UIButton) {
    close()
    delegate?.popupDidClickRed!()
    
  }
  
  
  //MARK:- Custom Methods
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
  
  func updateView(){
    if popupType == .removeBank{
      IBlblTitle.text = "REMOVE BANK ACCOUNT"
      IBlblSubTitle.text = "Are you sure you want to remove your " + " account? "
      IBButtonGrey.setTitle("NO", for: .normal)
      IBButtonRed.setTitle("YES", for: .normal)
    }else if popupType == .transferFund{
      IBlblTitle.text = "TRANSFER TO BANK"
      IBlblSubTitle.text = "You are about to deposit " + " into your account, do you wish to proceed?"
      IBButtonGrey.setTitle("DEPOSIT FUNDS", for: .normal)
      IBButtonRed.setTitle("CANCEL", for: .normal)
    }else{
      debugPrint("Popup type unknown")
    }
  }
  
  func setFollowSubTitle(_ labelName:String){
    IBlblSubTitle.text = "To see all of the labels you're following tap on the menu icon and go into 'Following'."
    IBlblSubTitle.numberOfLines = 3
  }
  
}
