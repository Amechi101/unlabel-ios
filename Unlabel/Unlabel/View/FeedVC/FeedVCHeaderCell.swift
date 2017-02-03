//
//  FeedVCHeaderCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 15/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FeedVCHeaderCell: UICollectionReusableView {
    
  @IBOutlet weak var IBSortButton: UIButton!
    @IBOutlet weak var IBlblFilterTitle: UILabel!
    @IBOutlet weak var IBbtnWomen: UIButton!
    @IBOutlet weak var IBbtnMen: UIButton!
//    @IBOutlet weak var IBconstraintGenderContainerHeight: NSLayoutConstraint!
    
    var selectedTab:FilterType = .men
    
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
    
    func getAlternateColor(_ currentColor:UIColor)->UIColor{
        if currentColor == EXTRA_LIGHT_GRAY_TEXT_COLOR{
            return MEDIUM_GRAY_TEXT_COLOR
        }else{
            return EXTRA_LIGHT_GRAY_TEXT_COLOR
        }
    }
    
    func updateFilterHeader(forFilterType filterType:FilterType){
        selectedTab = filterType
            if let superViewObj = superview {
                UIView.transition(with: superViewObj, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.IBbtnMen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: UIControlState())
                    self.IBbtnWomen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: UIControlState())
                    
                    if filterType == .men{
                        self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: UIControlState())
                    }else if filterType == .women{
                        self.IBbtnWomen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: UIControlState())
                    }else{
                        self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: UIControlState())
                    }
                    
                    }, completion: { _ in })
            }else{
                self.IBbtnMen.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: UIControlState())
                self.IBbtnWomen.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: UIControlState())
//                self.IBbtnMnW.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
            }
    }
}
