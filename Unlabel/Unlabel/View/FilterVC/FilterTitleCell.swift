//
//  FilterTitleCell.swift
//  Unlabel
//
//  Created by Zaid Pathan on 09/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol FilterTitleCellDelegate {
    func didChangeTab(index:Int)
}
class FilterTitleCell: UITableViewCell {

    @IBOutlet weak var IBlblTitle: UILabel!
    @IBOutlet weak var IBbtnUSA: UIButton!
    @IBOutlet weak var IBBtnInternational: UIButton!
    var delegate:FilterTitleCellDelegate?
    var selectedTab = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func IBActionTabClicked(sender: UIButton) {
        selectedTab = sender.tag
        delegate?.didChangeTab(sender.tag)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
