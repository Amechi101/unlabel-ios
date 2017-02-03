//
//  CartFooterView.swift
//  Unlabel
//
//  Created by SayOne Technologies on 13/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class CartFooterView: UICollectionViewCell {

    //MARK: -  IBOutlets,vars,constants
    
    @IBOutlet weak var IBLabelSubtotalText: UILabel!
    @IBOutlet weak var IBLabelSubtotal: UILabel!
    @IBOutlet weak var IBLabelEstimatedTax: UILabel!
    @IBOutlet weak var IBLabelShippingReturns: UILabel!
    @IBOutlet weak var IBLabelDiscount: UILabel!
    @IBOutlet weak var IBLabelTotal: UILabel!
    
    //MARK: -  View lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
