//
//  DepositEarningVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 20/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class DepositEarningVC: UIViewController {
  @IBOutlet weak var IBlabelEarnedAmount: UILabel!

  var popupKind : PopupType = .transferFund
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  @IBAction func IBActionTransferToBank(_ sender: Any) {
   //  UnlabelHelper.showAlert(onVC: self, title: "Transfer error", message: "No funds to deposit", onOk: {})
    
    self.addPopupView(PopupType.transferFund, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionRemoveBank(_ sender: Any) {
   self.addPopupView(PopupType.removeBank, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
    
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}

//MARK:- ViewFollowingLabelPopup Methods

extension DepositEarningVC: PopupviewDelegate{
  /**
   If user not following any brand, show this view
   */
  func addPopupView(_ popupType:PopupType,initialFrame:CGRect){
    if let viewFollowingLabelPopup:ViewFollowingLabelPopup = Bundle.main.loadNibNamed(VIEW_FOLLOWING_POPUP, owner: self, options: nil)? [0] as? ViewFollowingLabelPopup{
      viewFollowingLabelPopup.delegate = self
      viewFollowingLabelPopup.popupType = popupType
      popupKind = popupType
      viewFollowingLabelPopup.frame = initialFrame
      viewFollowingLabelPopup.alpha = 0
      APP_DELEGATE.window?.addSubview(viewFollowingLabelPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewFollowingLabelPopup.frame = self.view.frame
        viewFollowingLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewFollowingLabelPopup.alpha = 1
      })
      viewFollowingLabelPopup.updateView()
    }
  }
  
  func popupDidClickClose(){
    
  }
  
  func popupDidClickGrey(){
    if popupKind == PopupType.transferFund {
      let bankConfirmVC = storyboard?.instantiateViewController(withIdentifier: "bankConfirmVC") as? BankConfirmVC
      bankConfirmVC?.isTransfer = true
      navigationController?.pushViewController(bankConfirmVC!, animated: true)
    }
    else{
      
    }
  }
  
  func popupDidClickRed(){
    
  }
}
