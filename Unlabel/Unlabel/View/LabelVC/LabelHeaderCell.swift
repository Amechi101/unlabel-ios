//
//  LabelHeaderCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class LabelHeaderCell: UICollectionViewCell {

    @IBOutlet weak var IBimgHeaderImage: UIImageView!
    @IBOutlet weak var IBbtnFollow: UIButton!
    @IBOutlet weak var IBlblLabelDescription: UILabel!
    @IBOutlet weak var IBlblLabelLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        IBbtnFollow.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
        IBlblLabelLocation.textColor = MEDIUM_GRAY_TEXT_COLOR
    }

}
