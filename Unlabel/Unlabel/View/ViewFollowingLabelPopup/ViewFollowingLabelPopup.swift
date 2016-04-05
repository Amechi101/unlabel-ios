//
//  ViewFollowingLabelPopup.swift
//  Unlabel
//
//  Created by Zaid Pathan on 05/04/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

@objc protocol PopupviewDelegate {
    optional func popupDidClickCancel()
    optional func popupDidClickDelete()
    func popupDidClickClose()
}

enum PopupType{
    case Delete
    case Follow
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
    var popupType:PopupType = .Delete
    
    
    //
    //MARK:- View Lifecycle
    //
    override func awakeFromNib() {
       
    }
    
    
    //
    //MARK:- IBAction Methods
    //
    @IBAction func IBActionClose(sender: UIButton) {
        close()
        delegate?.popupDidClickClose()
    }
    
    @IBAction func IBActionCancel(sender: UIButton) {
        close()
        delegate?.popupDidClickCancel!()
    }
    
    @IBAction func IBActionDelete(sender: UIButton) {
        delegate?.popupDidClickDelete!()
    }
    
    
    //
    //MARK:- Custom Methods
    //
    
    func close(){
        UIView.animateWithDuration(0.2, animations: {
            self.frame.origin.y = SCREEN_HEIGHT
        }) { (value:Bool) in
            self.removeFromSuperview()
        }
    }
    
    func updateView(){
        if popupType == .Delete{
            IBlblTitle.text = "DELETE ACCOUNT"
            IBlblSubTitle.text = "Are you sure you want to delete your account? This can not be undone."
            IBlblSubTitle.numberOfLines = 2
            IBviewRoundContainer.hidden = true
            IBviewDeleteContainer.hidden = false
        }else if popupType == .Follow{
            IBlblTitle.text = "VIEW FOLLOWING LABELS"
            IBviewRoundContainer.hidden = false
            IBviewDeleteContainer.hidden = true
            print(IBviewRoundContainer.frame.size.height/2)
            IBviewRoundContainer.layer.cornerRadius = IBviewRoundContainer.frame.size.height/2
        }else{
            print("Popup type unknown")
        }
    }
    
    func setFollowSubTitle(labelName:String){
        IBlblSubTitle.text = "You're following \(labelName). To see all of the labels you're following tap on the menu icon and go into 'Following'."
        IBlblSubTitle.numberOfLines = 3
    }
    
}
