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
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
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
            addPopupView(.Delete, initialFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT))
        }else if indexPath.row == 2{
            UnlabelHelper.logout()
        }
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
    func setupOnLoad(){
        
    }
}
