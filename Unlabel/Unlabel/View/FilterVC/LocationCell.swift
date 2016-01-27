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
//        IBtblLocation.registerNib(UINib(nibName: REUSA, bundle: nil), forCellReuseIdentifier: REUSABLE_ID_LocationCell)
        // Initialization code
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
            let leftMenuCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
                    leftMenuCell.textLabel?.text = "ok"//arrTitles[indexPath.row]
            leftMenuCell.textLabel?.textColor = UIColor(red: 69/255, green: 73/255, blue: 78/255, alpha: 1)
            leftMenuCell.textLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 14)
            
            return leftMenuCell
        }
    }
