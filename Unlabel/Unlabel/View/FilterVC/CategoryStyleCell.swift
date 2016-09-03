//
//  CategoryStyleCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 28/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryStyleCellDelegate {
   func didClickStyleCell(forTag:Int)
   func didClickStyleCell(type:CategoryStyleEnum)
   
}

class CategoryStyleCell: UITableViewCell {
   
   @IBOutlet weak var IBbtnCategoryStyle: UIButton!
   var delegate: CategoryStyleCellDelegate?
   
   var categoryType:CategoryStyleEnum!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      
      IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
   }
   
   @IBAction func IBActionClick(sender: AnyObject) {
      delegate?.didClickStyleCell(categoryType)
   }
   
   override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   //   MARK:- Configure cell
   
   func configureCell(cellTitle title:String, indexPath: NSIndexPath) {
      self.IBbtnCategoryStyle.tag = indexPath.row
      self.IBbtnCategoryStyle.setTitle("    \(title)", forState: .Normal)
      self.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
      self.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
   }
   
   func configureCell(cellTitle title:String, type:CategoryStyleEnum) {
      self.categoryType = type
      self.IBbtnCategoryStyle.setTitle("    \(title)", forState: .Normal)
      self.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
      self.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
   }
   
}