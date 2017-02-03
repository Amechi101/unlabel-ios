//
//  CategoryStyleCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 28/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryStyleCellDelegate {
   func didClickStyleCell(_ forTag:Int)
   func didClickStyleCell(_ type:CategoryStyleEnum)
   
}

class CategoryStyleCell: UITableViewCell {
   
   @IBOutlet weak var IBbtnCategoryStyle: UIButton!
   var delegate: CategoryStyleCellDelegate?
   
   var categoryType:CategoryStyleEnum!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      
      IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.withAlphaComponent(0.5).cgColor
   }
   
   @IBAction func IBActionClick(_ sender: AnyObject) {
      delegate?.didClickStyleCell(categoryType)
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   //   MARK:- Configure cell
   
   func configureCell(cellTitle title:String, indexPath: IndexPath) {
      self.IBbtnCategoryStyle.tag = indexPath.row
      self.IBbtnCategoryStyle.setTitle("    \(title)", for: UIControlState())
      self.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.withAlphaComponent(0.5).cgColor
      self.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, for: UIControlState())
   }
   
   func configureCell(cellTitle title:String, type:CategoryStyleEnum) {
      self.categoryType = type
      self.IBbtnCategoryStyle.setTitle("    \(title)", for: UIControlState())
      self.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.withAlphaComponent(0.5).cgColor
      self.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, for: UIControlState())
   }
   
}
