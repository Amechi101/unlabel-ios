//
//  FeedVCHeaderCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 15/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FeedVCHeaderCell: UICollectionReusableView {
    
    @IBOutlet weak var IBlblFilterTitle: UILabel!
    @IBOutlet weak var IBbtnWomen: UIButton!
    @IBOutlet weak var IBbtnMen: UIButton!
    @IBOutlet weak var IBconstraintGenderContainerHeight: NSLayoutConstraint!
    
    var selectedTab:FilterType = .Unknown
    
    override func awakeFromNib() {
        if selectedTab == .Men {
            updateFilterHeader(false)
        }else if selectedTab == .Women{
            updateFilterHeader(true)
        }else{
            updateFilterHeader(false)
            debugPrint("awakeFromNib unknown FilterType")
        }
    }
    
    func getAlternateColor(currentColor:UIColor)->UIColor{
        if currentColor == EXTRA_LIGHT_GRAY_TEXT_COLOR{
            return MEDIUM_GRAY_TEXT_COLOR
        }else{
            return EXTRA_LIGHT_GRAY_TEXT_COLOR
        }
    }
    
    func updateFilterHeader(shouldHideMen:Bool){
        if shouldHideMen && selectedTab == .Women || !shouldHideMen && selectedTab == .Men{
            debugPrint("Tab already selected")
        }else{
            
            if shouldHideMen {
                selectedTab = .Women
            }else{
                selectedTab = .Men
            }
            
            if let superViewObj = superview {
                UIView.transitionWithView(superViewObj, duration: 0.5, options: .TransitionCrossDissolve, animations: {() -> Void in
                    self.IBbtnMen.setTitleColor(self.getAlternateColor((self.IBbtnMen.titleLabel?.textColor)!), forState: .Normal)
                    self.IBbtnWomen.setTitleColor(self.getAlternateColor((self.IBbtnMen.titleLabel?.textColor)!), forState: .Normal)
                    }, completion: { _ in })
            }else{
                self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                self.IBbtnWomen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
            }
        }
    }
}
