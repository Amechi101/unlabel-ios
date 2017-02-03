//
//  ViewFollowingLabelPopup.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

@objc protocol PopupviewDelegate {
    @objc optional func popupDidClickCancel()
    @objc optional func popupDidClickDelete()
    func popupDidClickClose()
}

enum PopupType{
    case delete
    case follow
}

class ViewFollowingLabelPopup: UIView {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBlblTitle: UILabel!
    @IBOutlet weak var IBlblSubTitle: UILabel!
    @IBOutlet weak var IBviewRoundContainer: UIView!
    @IBOutlet weak var IBviewDeleteContainer: UIView!
   
    var delegate:PopupviewDelegate?
    var popupType:PopupType = .delete
    
    
    //
    //MARK:- View Lifecycle
    //
    override func awakeFromNib() {
       
    }
    
    
    //
    //MARK:- IBAction Methods
    //
    @IBAction func IBActionClose(_ sender: UIButton) {
        close()
        delegate?.popupDidClickClose()
    }
    
    @IBAction func IBActionCancel(_ sender: UIButton) {
        close()
        delegate?.popupDidClickCancel!()
    }
    
    @IBAction func IBActionDelete(_ sender: UIButton) {
        delegate?.popupDidClickDelete!()
        if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
//            UnlabelHelper.deleteAccount(userID)
        }
    }
    
    
    //
    //MARK:- Custom Methods
    //
    
    fileprivate func close(){
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.y = SCREEN_HEIGHT
        }, completion: { (value:Bool) in
            self.removeFromSuperview()
        }) 
    }
    
    func updateView(){
        if popupType == .delete{
            IBlblTitle.text = "DELETE ACCOUNT"
            IBlblSubTitle.text = "Are you sure you want to delete your account? This can not be undone."
            IBlblSubTitle.numberOfLines = 2
            IBviewRoundContainer.isHidden = true
            IBviewDeleteContainer.isHidden = false
        }else if popupType == .follow{
            IBlblTitle.text = "VIEW FOLLOWING LABELS"
            IBviewRoundContainer.isHidden = false
            IBviewDeleteContainer.isHidden = true
            debugPrint(IBviewRoundContainer.frame.size.height/2)
            IBviewRoundContainer.layer.cornerRadius = IBviewRoundContainer.frame.size.height/2
        }else{
            debugPrint("Popup type unknown")
        }
    }
    
    func setFollowSubTitle(_ labelName:String){
        IBlblSubTitle.text = "To see all of the labels you're following tap on the menu icon and go into 'Following'."
        IBlblSubTitle.numberOfLines = 3
    }
    
}
