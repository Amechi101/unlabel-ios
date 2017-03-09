//
//  NotFoundView.swift
//  Unlabel
//
//  Created by Zaid Pathan on 29/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

@objc protocol NotFoundViewDelegate {
    @objc optional func didSelectViewLabels()
}
class NotFoundView: UIView {

   @IBOutlet weak var IBlblMessage: UILabel!
   
   @IBOutlet weak var IBbtnViewLabels: UIButton!
   
   @IBOutlet weak var IBviewHorizontal: UIView!
    var delegate:NotFoundViewDelegate?
   
   
  var showViewLabelBtn:Bool = false {
    didSet {
      if showViewLabelBtn == true {
        IBviewHorizontal.isHidden = false
        IBbtnViewLabels.isHidden = false
      } else {
        IBviewHorizontal.isHidden = true
        IBbtnViewLabels.isHidden = true
      }
    }
  }
  
  
   override func awakeFromNib() {
      super.awakeFromNib()
      IBbtnViewLabels.addTarget(self, action: #selector(NotFoundView.IBActionViewLabels(_:)), for: .touchUpInside)
      IBbtnViewLabels.titleLabel?.font = UIFont(name: "Neutraface2Text-Book", size: 15)!
      IBbtnViewLabels.setTitle("ADD IMAGES".uppercased(), for: UIControlState())
      
   }
   
    
    func IBActionViewLabels(_ sender: AnyObject) {
        delegate?.didSelectViewLabels!()
    }
   
   
   
}
