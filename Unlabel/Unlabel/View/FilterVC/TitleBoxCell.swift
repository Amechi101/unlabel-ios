//
//  TitleBoxCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 09/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class TitleBoxCell: UICollectionViewCell {

    @IBOutlet weak var IBlblBoxTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      IBlblBoxTitle.textColor = LIGHT_GRAY_TEXT_COLOR
      layer.borderColor = LIGHT_GRAY_BORDER_COLOR.withAlphaComponent(0.5).cgColor
    }

}
