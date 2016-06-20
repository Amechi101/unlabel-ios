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
    @IBOutlet weak var IBbtnLogout: UILabel!
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
       setupOnLoad()
    }

    override func viewWillAppear(animated: Bool) {
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_LEGALSTUFF_FROM_SETTINGS{
            let destVC = segue.destinationViewController as! LegalStuffPrivacyPolicyVC
            destVC.vcType = VCType.LegalStuff
        }else if segue.identifier == SEGUE_PRIVACYPOLICY_FROM_SETTINGS{
            let destVC = segue.destinationViewController as! LegalStuffPrivacyPolicyVC
            destVC.vcType = VCType.PrivacyPolicy
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == SEGUE_ACCOUNTINFO_FROM_SETTINGS{
            if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
                return true
            }else{
                UnlabelHelper.showLoginAlert(self, title: S_LOGIN, message: S_MUST_LOGGED_IN, onCancel: {}, onSignIn: {
                    self.openLoginSignupVC()
                })
                return false
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0{
            openSafariForURL(URL_PRIVACY_POLICY)
        }else if indexPath.row == 1{
            openSafariForURL(URL_TERMS)
        }else if indexPath.row == 3{
            UnlabelHelper.logout()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            IBbtnLogout.hidden = false
            IBcellLogout.userInteractionEnabled = true
        }else{
            IBbtnLogout.hidden = true
            IBcellLogout.userInteractionEnabled = false
        }
        return 4;
    }
}

//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension SettingsVC:SFSafariViewControllerDelegate{
    func openSafariForURL(urlString:String){
        if let productURL:NSURL = NSURL(string: urlString){
            APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
            let safariVC = SFSafariViewController(URL: productURL)
            safariVC.delegate = self
            self.presentViewController(safariVC, animated: true) { () -> Void in
                
            }
        }else{ showAlertWebPageNotAvailable() }
    }
    
    func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
    }
    
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]{
        return []
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
        
    }
}

//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension SettingsVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
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
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}

//
//MARK:- Custom Methods
//
extension SettingsVC:LoginSignupVCDelegate{
    func willDidmissViewController() {
        tableView.reloadData()
    }
}

//
//MARK:- Custom Methods
//
extension SettingsVC{
    
    /**
     Setup UI on VC Load.
     */
    private func setupOnLoad(){
       
    }
    
    private func openLoginSignupVC(){
        if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
            loginSignupVC.delegate = self
            self.presentViewController(loginSignupVC, animated: true, completion: nil)
        }
    }
}
