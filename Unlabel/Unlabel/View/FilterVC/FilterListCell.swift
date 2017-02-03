//
//  FilterListCell.swift
//  Unlabel
//
//  Created by jasmin on 04/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol FilterListDelegates : class {
   //func markCellsSelected()
   func headerCellClicked()
}


class FilterListCell: UITableViewCell {
   
   @IBOutlet weak var IBlblFilterListName: UILabel!
   @IBOutlet weak var IBimgViewCheckMark: UIImageView!
   
   weak var delegate:FilterListDelegates?
   
   

    override func awakeFromNib() {
        super.awakeFromNib()
      IBlblFilterListName.text = ""
      selectionStyle = .none
      removeMargines()
      IBlblFilterListName.font = UIFont.systemFont(ofSize: 16)
      IBlblFilterListName.textColor = MEDIUM_GRAY_TEXT_COLOR
      
      IBimgViewCheckMark.image = UIImage(named: "category_checkmark")
      IBimgViewCheckMark.contentMode = .center
      IBimgViewCheckMark.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     }
   
   func configureCell(_ index:IndexPath, selection:Bool) {
      
     
         IBimgViewCheckMark.isHidden = !selection
      
      
      if index.row == 0 {
            IBlblFilterListName.textColor = selection ? MEDIUM_GRAY_TEXT_COLOR.withAlphaComponent(0.3) : MEDIUM_GRAY_TEXT_COLOR
      } else {
          IBlblFilterListName.textColor = MEDIUM_GRAY_TEXT_COLOR
      }
   }
    
}
