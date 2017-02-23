//
//  SortModeCell.swift
//  Unlabel
//
//  Created by SayOne Technologies on 18/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class SortModeCell: UITableViewCell {

  @IBOutlet weak var cellLabel: UILabel!
  var isCellSelected: Bool = false
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
