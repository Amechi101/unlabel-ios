//
//  LocationCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var IBtblLocation: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomWhiteGradient = CAGradientLayer()
        bottomWhiteGradient.colors = [UIColor.clearColor().CGColor,UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor]
        bottomWhiteGradient.zPosition = -1
        self.layer.addSublayer(bottomWhiteGradient)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

    //
    //MARK:- UITableViewDelegate Methods
    //
    extension LocationCell:UITableViewDelegate{
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

        }
    }
    
    //
    //MARK:- UITableViewDataSource Methods
    //
    extension LocationCell:UITableViewDataSource{
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 10
            //        return arrTitles.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let locationNameCell:LocationNameCell = LocationNameCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
                    locationNameCell.textLabel?.text = "Atlanta"//arrTitles[indexPath.row]
            locationNameCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            locationNameCell.textLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 16)
            
            if indexPath.row % 2 == 0{
                locationNameCell.textLabel?.textColor = UnlabelHelper.getMediumGrayTextColor()
                locationNameCell.imageView?.image = UIImage(named: "locationTicked")
            }else{
                locationNameCell.textLabel?.textColor = UnlabelHelper.getLightGrayTextColor()
                locationNameCell.imageView?.image = UIImage(named: "locationUnticked")
            }
            
            return locationNameCell
        }
    }
