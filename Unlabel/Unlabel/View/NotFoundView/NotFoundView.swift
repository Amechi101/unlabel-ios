//
//  NotFoundView.swift
//  Unlabel
//
//  Created by Zaid Pathan on 29/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol NotFoundViewDelegate {
    func didSelectViewLabels()
}
class NotFoundView: UIView {

   @IBOutlet weak var IBlblMessage: UILabel!
   
   @IBOutlet weak var IBbtnViewLabels: UIButton!
   
    var delegate:NotFoundViewDelegate?
   
   
   var showViewLabelBtn:Bool = false {
      didSet {
         if showViewLabelBtn == true {
             IBbtnViewLabels.hidden = false
             delegate?.didSelectViewLabels()
         } else {
              IBbtnViewLabels.hidden = true
         }
      }
   }
   
   
   override func awakeFromNib() {
      super.awakeFromNib()
        IBbtnViewLabels.hidden = true
   }
   
    
    func IBActionViewLabels(sender: AnyObject) {
        delegate?.didSelectViewLabels()
    }
   
   
   
}
