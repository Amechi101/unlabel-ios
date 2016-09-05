//
//  GlossaryCell.swift
//  Unlabel
//
//  Created by jasmin on 03/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

class GlossaryCell: UITableViewCell {

   @IBOutlet weak var IBlblGlossaryTitle: UILabel!
   @IBOutlet weak var IBlblGlossaryDesc: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.selectionStyle = .None
      self.removeMargines()

      
      IBlblGlossaryTitle.font = UIFont.systemFontOfSize(14)
      IBlblGlossaryDesc.font = UIFont(name: "Neutraface2Text-Book", size: 14)
      IBlblGlossaryDesc.textColor = UIColor(red: 69/255.0, green: 73/255.0, blue: 78/255.0, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   func configureCell(dict:JSON) {
      IBlblGlossaryTitle.text = dict["name"].string?.capitalizedString
      IBlblGlossaryDesc.text = dict["description"].string
    }

}