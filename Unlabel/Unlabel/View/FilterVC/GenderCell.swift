//
//  GenderCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 28/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {

    @IBOutlet weak var IBbtnMale: UIButton!
    @IBOutlet weak var IBbtnFemale: UIButton!
    
    //Default both gender selected
    var isMaleSelected:Bool = true
    var isFemaleSelected:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


//
//MARK:- IBAction Methods
//
extension GenderCell{
    //Tag 1 for Male, 2 for Female
    @IBAction func IBActionGenderClicked(sender: UIButton) {
        handleGenderSelection(sender)
    }
}


//
//MARK:- Custom Methods
//
extension GenderCell{
    
    func handleGenderSelection(sender:UIButton){
        //Male Clicked
        if sender.tag == 1{
            isMaleSelected = !isMaleSelected
            if isMaleSelected{
                enableButton(IBbtnMale)
            }else{
                disableButton(IBbtnMale)
            }
            
        //Female Clicked
        }else{
            isFemaleSelected = !isFemaleSelected
            if isFemaleSelected{
                enableButton(IBbtnFemale)
            }else{
                disableButton(IBbtnFemale)
            }
        }
    }
    
    /**
     Enable button
     */
    func enableButton(makeEnabled:UIButton){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            makeEnabled.titleLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
            makeEnabled.layer.borderColor = MEDIUM_GRAY_TEXT_COLOR.CGColor
        }
    }
    
    /**
     Disable button
     */
    func disableButton(makeDisabled:UIButton){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            makeDisabled.titleLabel?.textColor = LIGHT_GRAY_BORDER_COLOR
            makeDisabled.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
        }
    }
    
}