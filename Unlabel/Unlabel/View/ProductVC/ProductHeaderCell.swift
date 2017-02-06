//
//  ProductHeaderCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class ProductHeaderCell: UICollectionViewCell {
  
  @IBOutlet weak var IBimgHeaderImage: UIImageView!
  @IBOutlet weak var IBbtnFollow: UIButton!
  @IBOutlet weak var IBbtnShare: UIButton!
  @IBOutlet weak var IBBrandDescription: UILabel!
  @IBOutlet weak var IBBrandLocation: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    IBbtnFollow.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.cgColor
  }
}
