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
//    @IBOutlet weak var IBconstraintGenderContainerHeight: NSLayoutConstraint!
    
    var selectedTab:FilterType = .men
    
    override func awakeFromNib() {
      //updateFilterHeader(forFilterType: selectedTab)

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
                                       }, completion: { _ in })
            }else{
              
            }
    }
}
