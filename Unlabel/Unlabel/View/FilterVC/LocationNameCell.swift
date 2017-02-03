//
//  LocationNameCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 29/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class LocationNameCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame.size = CGSize(width: 12, height: 12)
        self.imageView?.frame.origin.x = 30
        self.imageView?.center.y = self.frame.size.height/2
        self.textLabel?.frame.origin.x = 57
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
