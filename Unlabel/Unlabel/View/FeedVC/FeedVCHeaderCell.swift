//
//  FeedVCHeaderCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 15/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FeedVCHeaderCell: UICollectionReusableView {
        
    @IBOutlet weak var IBviewWomenUnderline: UIView!
    @IBOutlet weak var IBviewMenUnderline: UIView!
    
    @IBOutlet weak var IBbtnFilter: UIButton!
    @IBOutlet weak var IBimgArrow: UIImageView!
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
    
    func updateFilterHeader(shouldHideMen:Bool){
        if shouldHideMen && selectedTab == .Women || !shouldHideMen && selectedTab == .Men{
            debugPrint("Tab already selected")
        }else{
            var animation:UIViewAnimationOptions = UIViewAnimationOptions.TransitionFlipFromRight
            if shouldHideMen {
                selectedTab = .Women
                animation = .TransitionFlipFromLeft
            }else{
                selectedTab = .Men
                animation = .TransitionFlipFromRight
            }
            
            if let superViewObj = superview {
                UIView.transitionWithView(superViewObj, duration: 0.5, options: animation, animations: {() -> Void in
                    self.IBviewMenUnderline.hidden = shouldHideMen
                    self.IBviewWomenUnderline.hidden = !shouldHideMen
                    }, completion: { _ in })
            }else{
                self.IBviewMenUnderline.hidden = shouldHideMen
                self.IBviewWomenUnderline.hidden = !shouldHideMen
            }
        }
    }
}
