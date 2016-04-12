//
//  ProductCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 03/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var IBimgProductImage: UIImageView!
    @IBOutlet weak var IBlblProductName: UILabel!
    @IBOutlet weak var IBlblProductPrice: UILabel!
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
