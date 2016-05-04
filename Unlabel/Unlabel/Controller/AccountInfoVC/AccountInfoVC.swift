//
//  AccountInfoVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class AccountInfoVC: UITableViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBlblLoggedInWith: UILabel!
    @IBOutlet weak var IBlblUserName: UILabel!
    @IBOutlet weak var IBlblEmailOrPhone: UILabel!
    @IBOutlet var IBtblAccountInfo: UITableView!
    
    var userDetails:(displayName:String,EmailOrPhone:String,SignedInWith:String) = {
        if let provider = UnlabelHelper.getDefaultValue(PRM_PROVIDER){
            
            //Facebook user
            if provider == S_PROVIDER_FACEBOOK{
                if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
                    if let email = UnlabelHelper.getDefaultValue(PRM_EMAIL){
                        return (displayName,email,"Facebook")
                    }else{
                        return (displayName,"Unlabel User","Facebook")
                    }
                }else{
                    return ("Unlabel User","Unlabel User","Facebook")
                }
                
                
            //AccountKit
            }else{
                if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
                    if let email = UnlabelHelper.getDefaultValue(PRM_EMAIL){
                        return (displayName,email,"Email Only")
                    }else if let phone = UnlabelHelper.getDefaultValue(PRM_PHONE){
                        return (displayName,phone,"Mobile Number")
                    }else{
                        return ("Unlabel User","Unlabel User","Email or Phone")
                    }
                }else{
                    return ("Unlabel User","Unlabel User","Email or Phone")
                }
            }
        }else{
            return ("Unlabel User","Unlabel User","Facebook or Email or Phone")
        }
    }()
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setupOnWillAppear()
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UITableViewDelegate Methods
//
extension AccountInfoVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1{
            goToChangeName()
        }else if indexPath.row == 2{
            UnlabelHelper.logout()
        }
    }
    
    func goToChangeName(){
    
    }
}

//
//MARK:- ViewFollowingLabelPopup Methods
//

extension AccountInfoVC:PopupviewDelegate{
    /**
     If user not following any brand, show this view
     */
    func addPopupView(popupType:PopupType,initialFrame:CGRect){
        if let viewFollowingLabelPopup:ViewFollowingLabelPopup = NSBundle.mainBundle().loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil) [0] as? ViewFollowingLabelPopup{
            viewFollowingLabelPopup.delegate = self
            viewFollowingLabelPopup.popupType = popupType
            viewFollowingLabelPopup.frame = initialFrame
            viewFollowingLabelPopup.alpha = 0
            view.addSubview(viewFollowingLabelPopup)
            UIView.animateWithDuration(0.2) {
                viewFollowingLabelPopup.frame = self.view.frame
                viewFollowingLabelPopup.frame.origin = CGPointMake(0, 0)
                viewFollowingLabelPopup.alpha = 1
            }
            viewFollowingLabelPopup.updateView()
        }
    }
    
    func popupDidClickCancel(){
        
    }
    
    func popupDidClickDelete(){
        print("delete account")
    }
    
    func popupDidClickClose(){
        
    }
}

//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension AccountInfoVC:UIGestureRecognizerDelegate{
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
extension AccountInfoVC{
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension AccountInfoVC{
    
    /**
     Setup UI on VC Load.
     */
    func setupOnWillAppear(){
        if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
            userDetails.displayName = displayName
        }
        IBlblUserName.text = userDetails.displayName
        IBlblEmailOrPhone.text = userDetails.EmailOrPhone
        IBlblLoggedInWith.text = "Signed In with \(userDetails.SignedInWith):"
    }
}
