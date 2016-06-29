//
//  CategoryLocationCell.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func didSelectRow(withSelectedCategories dictCategories:[Int:Bool]) //arrCategories is key index
}

enum CategoryLocationCellType{
    case Unknown
    case Category
    case Location
}

enum TableViewType:Int{
    case Unknown = 0
    case Category = 1
    case Location = 2
}

class CategoryLocationCell: UITableViewCell {
    
    @IBOutlet weak var IBconstraintCategoryTableHeight: NSLayoutConstraint!
    @IBOutlet weak var IBtblLocation: UITableView!
    var cellType = CategoryLocationCellType.Unknown
    var shouldClearCategories = false

    private let arrCategories:[String] = ["All categories","Clothing","Accessories","Jewelry","Shoes","Bags"]
    private let arrLocations:[String] = ["Manhattan, NY","Los Angeles, CA","Brooklyn, NY","Madrid, Spain","Novi Sad, Serbia","San Deigo, CA","Minneapolis, Minnesota","New York, NY","Lower East Side, NY","Australia","London","Paris, France","Denver, Colorado","Boston, MA","Dallas, Texas","Chicago","Netherlands","Nashville, TN","San Francisco, CA","Rotterdam, The Netherlands","Canada"]
    var dictSelectedCategories = [Int:Bool]()
    private var dictSelectedLocations = [Int:Bool]()
    var delegate:CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        IBtblLocation.tableFooterView = UIView()
        
        let bottomWhiteGradient = CAGradientLayer()
        bottomWhiteGradient.colors = [UIColor.clearColor().CGColor,UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor]
        bottomWhiteGradient.zPosition = -1
        self.layer.addSublayer(bottomWhiteGradient)
    
        for (index,_) in arrCategories.enumerate(){
            dictSelectedCategories[index] = false
        }
        
        for (index,_) in arrLocations.enumerate(){
            dictSelectedLocations[index] = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

    //
    //MARK:- UITableViewDelegate Methods
    //
    extension CategoryLocationCell:UITableViewDelegate{
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
                handleSelection(forIndexPath: indexPath)
        }
        
        func handleSelection(forIndexPath indexPath:NSIndexPath){
            if indexPath.row == 0 {
                //If every cell selected then deselect all cells
                if dictSelectedCategories[indexPath.row] == true{
                    dictSelectedCategories[0] = false
                    for (index,_) in arrCategories.enumerate(){
                        dictSelectedCategories[index] = false
                    }
                    
                //If not every cell selected then select all cells
                }else{
                    dictSelectedCategories[0] = true
                    for (index,_) in arrCategories.enumerate(){
                        dictSelectedCategories[index] = true
                    }
                }
            }else{
                dictSelectedCategories[indexPath.row] = !dictSelectedCategories[indexPath.row]! //If ticked then do untick and vise-versa
                if isAllCellsSelected(){
                    dictSelectedCategories[0] = true
                }else{
                    dictSelectedCategories[0] = false
                }
            }
            IBtblLocation.reloadData()
            delegate?.didSelectRow(withSelectedCategories: dictSelectedCategories)
        }
        
        func isAllCellsSelected()->Bool{
            var isAllCellsSelected = true
            for (index,_) in arrCategories.enumerate(){
                if index > 0 {                                  //Ignoring "All categories" Cell
                    if dictSelectedCategories[index] == false{
                        isAllCellsSelected = false              //If any of cell is deselected
                    }
                }
            }
            return isAllCellsSelected
        }
    }
    
    //
    //MARK:- UITableViewDataSource Methods
    //
    extension CategoryLocationCell:UITableViewDataSource{
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            if cellType == .Category{
                return arrCategories.count
            }else if cellType == .Location{
                return arrLocations.count
            }else{
                return 0
            }
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let locationNameCell:LocationNameCell = LocationNameCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")

            locationNameCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            locationNameCell.textLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 16)
            
            if cellType == .Category{
                getCategoryCell(locationNameCell, indexPath: indexPath)
            }else if cellType == .Location{
                getLocationCell(locationNameCell, indexPath: indexPath)
            }else{
                locationNameCell.textLabel?.text = ""
            }
            
            return locationNameCell
        }
        
        func getCategoryCell(locationNameCell:LocationNameCell,indexPath:NSIndexPath)->LocationNameCell{
            locationNameCell.textLabel?.text = arrCategories[indexPath.row]
            if let isSelected:Bool = dictSelectedCategories[indexPath.row]{
                if isSelected{
                    locationNameCell.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
                    locationNameCell.imageView?.image = UIImage(named: "locationTicked")
                }else{
                    locationNameCell.textLabel?.textColor = LIGHT_GRAY_TEXT_COLOR
                    locationNameCell.imageView?.image = UIImage(named: "locationUnticked")
                }
            }
        
            return locationNameCell
        }
        
        func getLocationCell(locationNameCell:LocationNameCell,indexPath:NSIndexPath)->LocationNameCell{
            locationNameCell.textLabel?.text = arrLocations[indexPath.row]
            if let isSelected:Bool = dictSelectedLocations[indexPath.row]{
                if isSelected{
                    locationNameCell.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
                    locationNameCell.imageView?.image = UIImage(named: "locationTicked")
                }else{
                    locationNameCell.textLabel?.textColor = LIGHT_GRAY_TEXT_COLOR
                    locationNameCell.imageView?.image = UIImage(named: "locationUnticked")
                }
            }
            return locationNameCell
        }
    }
