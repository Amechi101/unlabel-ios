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
    
    //Default selected gender Male
    var isSelectedGenderMale:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isSelectedGenderMale{
            changeButtonState(makeEnabled: IBbtnMale, makeDisabled: IBbtnFemale)
        }else{
            changeButtonState(makeEnabled: IBbtnFemale, makeDisabled: IBbtnMale)
        }
        
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
        //Male Clicked
        if sender.tag == 1{
            isSelectedGenderMale = true
            changeButtonState(makeEnabled: IBbtnMale, makeDisabled: IBbtnFemale)
            
            //Female Clicked
        }else{
            isSelectedGenderMale = false
            changeButtonState(makeEnabled: IBbtnFemale, makeDisabled: IBbtnMale)
        }
    }
}


//
//MARK:- Custom Methods
//
extension GenderCell{
    /**
     Change button state, i.e.For GenderCell
     */
    func changeButtonState(makeEnabled makeEnabled:UIButton,makeDisabled:UIButton){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            makeEnabled.titleLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
            makeEnabled.layer.borderColor = MEDIUM_GRAY_TEXT_COLOR.CGColor
            makeDisabled.titleLabel?.textColor = LIGHT_GRAY_BORDER_COLOR
            makeDisabled.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
        }
    }
}