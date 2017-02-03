//
//  SettingsVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 23/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SafariServices

class SettingsVC: UITableViewController {
  
  //
  //MARK:- IBOutlets, constants, vars
  //
  @IBOutlet weak var IBcellLogout: UITableViewCell!
  @IBOutlet weak var IBcellACInfo: UITableViewCell!
  
  

  //
  //MARK:- VC Lifecycle
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    setupOnLoad()
    
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SEGUE_LEGALSTUFF_FROM_SETTINGS{
      let destVC = segue.destination as! LegalStuffPrivacyPolicyVC
      destVC.vcType = VCType.legalStuff
    }else if segue.identifier == SEGUE_PRIVACYPOLICY_FROM_SETTINGS{
      let destVC = segue.destination as! LegalStuffPrivacyPolicyVC
      destVC.vcType = VCType.privacyPolicy
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == SEGUE_ACCOUNTINFO_FROM_SETTINGS{
      if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
        return true
      }else{
        //                UnlabelHelper.showLoginAlert(self, title: S_LOGIN, message: S_MUST_LOGGED_IN, onCancel: {}, onSignIn: {
        //                    self.openLoginSignupVC()
        //                })
        return true
      }
    }else{
      return true
    }
  }
}


//
//MARK:- UITableViewDelegate Methods
//
extension SettingsVC{
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    print("indexpath = \(indexPath.row)")
    if indexPath.row == 4{
      openSafariForURL(URL_PRIVACY_POLICY)
    }
    else if indexPath.row == 2{
      openSafariForURL("https://itunes.apple.com//us/app/unlabel-discover-todays-greatest/id1092257876?mt=8")
    }
    else if indexPath.row == 3{
      openSafariForURL(URL_TERMS)
    }else if indexPath.row == 7{
      // UnlabelHelper.logout()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if UnlabelHelper.isUserLoggedIn(){
      IBcellACInfo.isHidden = false
      IBcellLogout.isHidden = true
      IBcellLogout.isUserInteractionEnabled = false
    }else{
      IBcellLogout.isHidden = false
      IBcellACInfo.isHidden = true
      IBcellLogout.isUserInteractionEnabled = true
    }
    
    
    return 8;
  }
}

//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension SettingsVC:SFSafariViewControllerDelegate{
  func openSafariForURL(_ urlString:String){
    if let productURL:URL = URL(string: urlString){
      APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
      let safariVC = SFSafariViewController(url: productURL)
      safariVC.delegate = self
      self.present(safariVC, animated: true) { () -> Void in
        
      }
    }else{ showAlertWebPageNotAvailable() }
  }
  
  func showAlertWebPageNotAvailable(){
    UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
      
    }
  }
  
  func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity]{
    return []
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController){
    APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
  }
  
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
    
  }
}

//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension SettingsVC:UIGestureRecognizerDelegate{
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

//
//MARK:- IBAction Methods
//
extension SettingsVC{
  @IBAction func IBActionBack(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }
  @IBAction func IBActionLoginSignup(_ sender: UIButton) {
  }
}


//
//MARK:- Custom Methods
//
extension SettingsVC{
  
  /**
   Setup UI on VC Load.
   */
  fileprivate func setupOnLoad(){
    
  }
  

}
