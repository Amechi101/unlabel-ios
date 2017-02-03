//
//  FilterHeaderCell.swift
//  Unlabel
//
//  Created by jasmin on 04/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class FilterHeaderCell: UITableViewCell {

   @IBOutlet weak var topHeaderSeperator: UIView!
   @IBOutlet weak var bottomHeaderSeperator: UIView!
   
   @IBOutlet weak var FilterHeaderTitle: UILabel!
   @IBOutlet weak var IBimgViewRightSide: UIImageView!
   
   weak var delegate:FilterListDelegates?
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
      
      topHeaderSeperator.backgroundColor = LIGHT_GRAY_TEXT_COLOR.withAlphaComponent(0.5)
      bottomHeaderSeperator.backgroundColor = LIGHT_GRAY_TEXT_COLOR.withAlphaComponent(0.5)
      
      IBimgViewRightSide.image = UIImage(named: "arrowGray")
      IBimgViewRightSide.contentMode = .center
      selectionStyle = .none
      removeMargines()
      
      FilterHeaderTitle.text = ""
      FilterHeaderTitle.font = UIFont.systemFont(ofSize: 16)
      FilterHeaderTitle.textColor = MEDIUM_GRAY_TEXT_COLOR
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
   @IBAction func IBbtnHeaderClicked(_ sender: AnyObject) {
      delegate?.headerCellClicked()
   }
   
}
