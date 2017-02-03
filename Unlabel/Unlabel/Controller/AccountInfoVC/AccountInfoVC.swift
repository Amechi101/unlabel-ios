//
//  AccountInfoVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountInfoVC: UITableViewController {
  
  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet weak var IBlblLoggedInWith: UILabel!
  @IBOutlet weak var IBlblUserName: UILabel!
  @IBOutlet weak var IBlblEmailOrPhone: UILabel!
  @IBOutlet var IBtblAccountInfo: UITableView!
  @IBOutlet weak var IBProfileImage: UIImageView!
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let _ = self.navigationController{
      navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


//MARK:- UITableViewDelegate Methods

extension AccountInfoVC{
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 1{
      goToChangeName()
    }
    else if indexPath.row == 5{
      self.addPopupView(PopupType.delete, initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    }else if indexPath.row == 7{
      wsLogout()
    }
  }
  
  func goToChangeName(){
    
  }
  
  func wsLogout(){
    UnlabelAPIHelper.sharedInstance.logoutFromUnlabel(self, success:
      { (json: JSON) in
        UnlabelLoadingView.sharedInstance.stop(self.view)
        UnlabelHelper.logout()
    },
    failed: { (error) in
     UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
    
  }
  
  func wsDeleteAccount(){
    UnlabelAPIHelper.sharedInstance.deleteAccount(self, success:
      { (json: JSON) in
        UnlabelLoadingView.sharedInstance.stop(self.view)
        UnlabelHelper.logout()
    },
    failed: { (error) in
        UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
  }
  
}

//MARK:- ViewFollowingLabelPopup Methods

extension AccountInfoVC:PopupviewDelegate{
  /**
   If user not following any brand, show this view
   */
  func addPopupView(_ popupType:PopupType,initialFrame:CGRect){
    if let viewFollowingLabelPopup:ViewFollowingLabelPopup = Bundle.main.loadNibNamed(VIEW_FOLLOWING_POPUP, owner: self, options: nil)? [0] as? ViewFollowingLabelPopup{
      viewFollowingLabelPopup.delegate = self
      viewFollowingLabelPopup.popupType = popupType
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
  
  func popupDidClickCancel(){
    
  }
  
  func popupDidClickDelete(){
    debugPrint("delete account")
    wsDeleteAccount()
  }
  
  func popupDidClickClose(){
    
  }
}

//MARK:- UIGestureRecognizerDelegate Methods

extension AccountInfoVC:UIGestureRecognizerDelegate{
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let navVC = navigationController{
      if navVC.viewControllers.count > 1{
        return true
      }else{
        return false
      }
    }else{
      return false
    }
  }
}


//MARK:- IBAction Methods

extension AccountInfoVC{
  @IBAction func IBActionBack(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }
}






