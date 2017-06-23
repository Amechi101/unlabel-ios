//
//  ProductContentHeader.swift
//  Unlabel
//
//  Created by SayOne Technologies on 07/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ProductContentHeader: UICollectionReusableView {

  @IBOutlet weak var IBBrandBottomContraint: NSLayoutConstraint!
  @IBOutlet weak var IBViewRentalInfo: UIButton!
  @IBOutlet weak var IBBrandNameLabel: UILabel!
  @IBOutlet weak var IBBrandDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
