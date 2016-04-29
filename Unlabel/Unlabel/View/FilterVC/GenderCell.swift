//
//  GenderCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 28/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {

    @IBOutlet weak var IBbtnMale: UIButton!
    @IBOutlet weak var IBbtnFemale: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}