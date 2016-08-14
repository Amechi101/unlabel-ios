//
//  FeedVCHeaderCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 15/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FeedVCHeaderCell: UICollectionReusableView {
    
    @IBOutlet weak var IBbtnMnW: UIButton!
    @IBOutlet weak var IBlblFilterTitle: UILabel!
    @IBOutlet weak var IBbtnWomen: UIButton!
    @IBOutlet weak var IBbtnMen: UIButton!
    @IBOutlet weak var IBconstraintGenderContainerHeight: NSLayoutConstraint!
    
    var selectedTab:FilterType = .Unknown
    
    override func awakeFromNib() {
//        if selectedTab == .Men {
            updateFilterHeader(forFilterType: selectedTab)
//            updateFilterHeader(false)
//        }else if selectedTab == .Women{
//            updateFilterHeader(true)
//        }else if selectedTab == .Both{
//            updateFilterHeader(true)
//        }else{
//            updateFilterHeader(false)
//            debugPrint("awakeFromNib unknown FilterType")
//        }
    }
    
    func getAlternateColor(currentColor:UIColor)->UIColor{
        if currentColor == EXTRA_LIGHT_GRAY_TEXT_COLOR{
            return MEDIUM_GRAY_TEXT_COLOR
        }else{
            return EXTRA_LIGHT_GRAY_TEXT_COLOR
        }
    }
    
    func updateFilterHeader(forFilterType filterType:FilterType){
            if let superViewObj = superview {
                UIView.transitionWithView(superViewObj, duration: 0.5, options: .TransitionCrossDissolve, animations: {() -> Void in
                    self.IBbtnMen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
                    self.IBbtnWomen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
                    self.IBbtnMnW.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
                    
                    if filterType == .Men{
                        self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                    }else if filterType == .Women{
                        self.IBbtnWomen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                    }else if filterType == .Both{
                        self.IBbtnMnW.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                    }else{
                        self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                    }
                    
                    }, completion: { _ in })
            }else{
                self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
                self.IBbtnWomen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
                self.IBbtnMnW.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
            }
    }
}
