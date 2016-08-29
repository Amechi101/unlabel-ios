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
   
   @IBOutlet weak var IBviewHorizontal: UIView!
    var delegate:NotFoundViewDelegate?
   
   
   var showViewLabelBtn:Bool = false {
      didSet {
         if showViewLabelBtn == true {
            IBviewHorizontal.hidden = false
             IBbtnViewLabels.hidden = false         
         } else {
             IBviewHorizontal.hidden = true
             IBbtnViewLabels.hidden = true
         }
      }
   }
   
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      IBbtnViewLabels.hidden = true
      IBviewHorizontal.hidden = true
      
      IBbtnViewLabels.addTarget(self, action: #selector(NotFoundView.IBActionViewLabels(_:)), forControlEvents: .TouchUpInside)
//      let _textColor =  UIColor(red:151.1/255.0,green:81.0/255.0,blue:86.0/255.0,alpha:255.0/255.0)

      /*let _title = "View Labels".uppercaseString
      let titleString : NSMutableAttributedString = NSMutableAttributedString(string: _title)
      
    
      titleString.addAttributes([
         NSFontAttributeName: UIFont(name: "Neutraface2Text-Book", size: 15)!,
         NSForegroundColorAttributeName: _textColor,
         NSUnderlineStyleAttributeName:  NSUnderlineStyle.StyleSingle.rawValue
         ], range: NSMakeRange(0, _title.utf8.count))
      */
      
//      IBbtnViewLabels.setTitleColor(_textColor, forState: .Normal)
      IBbtnViewLabels.titleLabel?.font = UIFont(name: "Neutraface2Text-Book", size: 15)!
      IBbtnViewLabels.setTitle("View Labels".uppercaseString, forState: .Normal)
      
   }
   
    
    func IBActionViewLabels(sender: AnyObject) {
        delegate?.didSelectViewLabels()
    }
   
   
   
}
