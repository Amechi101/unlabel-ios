//
//  CategoryStyleCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 28/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryStyleCellDelegate {
    func didClickStyleCell(forTag:Int)
}
class CategoryStyleCell: UITableViewCell {

    @IBOutlet weak var IBbtnCategoryStyle: UIButton!
    var delegate: CategoryStyleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func IBActionClick(sender: AnyObject) {
        delegate?.didClickStyleCell(sender.tag)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}