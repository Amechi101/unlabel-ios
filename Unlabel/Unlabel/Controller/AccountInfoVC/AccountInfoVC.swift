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
  
  func getInfluencerDetails(){
    
    UnlabelAPIHelper.sharedInstance.getProfileDetails( { (
      meta: JSON) in
      print(meta)
      UnlabelHelper.setDefaultValue(meta["email"].stringValue, key: "influencer_email")
      UnlabelHelper.setDefaultValue(meta["last_name"].stringValue, key: "influencer_last_name")
      UnlabelHelper.setDefaultValue(meta["auto_id"].stringValue, key: "influencer_auto_id")
      UnlabelHelper.setDefaultValue(meta["image"].stringValue, key: "influencer_image")
      UnlabelHelper.setDefaultValue(meta["first_name"].stringValue, key: "influencer_first_name")
      
      DispatchQueue.main.async(execute: { () -> Void in
        self.IBlblLoggedInWith.text = "ICC ID: " + UnlabelHelper.getDefaultValue("influencer_auto_id")!
        self.IBlblUserName.text =  UnlabelHelper.getDefaultValue("influencer_first_name")! + " " + UnlabelHelper.getDefaultValue("influencer_last_name")!
        self.IBlblEmailOrPhone.text = UnlabelHelper.getDefaultValue("influencer_email")!
        self.IBProfileImage.contentMode = .scaleToFill
        self.IBProfileImage.layer.cornerRadius = self.IBProfileImage.bounds.size.width/2
        self.IBProfileImage.sd_setImage(with: URL(string: UnlabelHelper.getDefaultValue("influencer_image")!))
        self.IBProfileImage.clipsToBounds = true
      })
      

      
    }, failed: { (error) in
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getInfluencerDetails()
    
    
    if let _ = self.navigationController{
      navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


//MARK:- UITableViewDelegate Methods

extension AccountInfoVC{
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 7{
      if !ReachabilitySwift.isConnectedToNetwork(){
        UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
      else{
        wsLogout()
      }
    }
  }
  

  
}

//MARK:- Custom Methods

extension AccountInfoVC{

  func wsLogout(){
    UnlabelAPIHelper.sharedInstance.logoutFromUnlabel(self, success:
      { (json: JSON) in
        UnlabelLoadingView.sharedInstance.stop(self.view)
        UnlabelHelper.logout()
    },failed: { (error) in
      UnlabelHelper.showAlert(onVC: self, title: S_NAME_UNLABEL, message: sSOMETHING_WENT_WRONG, onOk: { () -> () in })
    })
    
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






