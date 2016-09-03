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
//      IBlblGlossaryTitle.font = UIFont(name: "Neutraface2Text-Demi", size: 15)
//      IBlblGlossaryDesc.font = UIFont(name: "Neutraface2Text-Demi", size: 14)
      
      IBlblGlossaryTitle.font = UIFont.systemFontOfSize(16)
      IBlblGlossaryDesc.font = UIFont.systemFontOfSize(16)
      IBlblGlossaryDesc.textColor = UIColor(red: 153/255, green: 156/255, blue: 165/255, alpha: 0.3)
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
