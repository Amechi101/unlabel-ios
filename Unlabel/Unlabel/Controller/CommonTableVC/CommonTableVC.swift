//
//  CommonTableVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 18/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum CommonVCType{
    case Unknown
    case FilterLabels
    case FilterByCategory
    case FilterByLocationThenCategory
}

enum LabelListCategory:Int{
    case Multi = 0
    case Clothing = 1
    case Accessory = 2
    case Jewelry = 3
    case Shoe = 4
    case Bag = 5
}

enum Labels:String{
    case Multi = "Multi"
    case Clothing = "Clothing"
    case Accessories = "Accessories"
    case Jewelry = "Jewelry"
    case Shoes = "Shoes"
    case Bags = "Bags"
}


class CommonTableVC: UITableViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBbtnTitle: UIButton!
    
    var commonVCType:CommonVCType = .Unknown
    
    var arrTitles:[String] = [ ]
    var arrFilteredBrandList:[Brand] = [ ]
    var filterType:FilterType = .Unknown
    var isFollowdByLocation:(value:Bool,location:String?)?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//MARK:- Navigation Methods
//
extension CommonTableVC{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_FILTER_LABELS{
            if let commonTableVC:CommonTableVC = segue.destinationViewController as? CommonTableVC{
                commonTableVC.commonVCType = .FilterLabels
            }
        }
    }
}


//
//MARK:- Table view data source Methods
//
extension CommonTableVC{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrTitles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let commonTableVCCell:CommonTableVCCell = (tableView.dequeueReusableCellWithIdentifier(REUSABLE_ID_CommonTableVCCell, forIndexPath: indexPath) as? CommonTableVCCell)!
        
        commonTableVCCell.IBlblTitle.text = arrTitles[indexPath.row]
        
        return commonTableVCCell
    }
}


//
//MARK:- Table view data source Methods
//
extension CommonTableVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        handleCellClick(forIndexPath: indexPath)
    }
    
    func handleCellClick(forIndexPath indexPath:NSIndexPath){
        if commonVCType == .FilterLabels{
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.arrFilteredBrandList = self.arrFilteredBrandList
            commonTableVC?.isFollowdByLocation = self.isFollowdByLocation
            commonTableVC?.filterType = self.filterType
            
            if indexPath.row == 0{
                commonTableVC?.commonVCType = .FilterByLocationThenCategory
            }else if indexPath.row == 1{
                commonTableVC?.commonVCType = .FilterByCategory
            }else{
                debugPrint("handleCellClick Unknown")
            }
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
        }else if commonVCType == . FilterByLocationThenCategory{
        
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.commonVCType = .FilterByCategory
            commonTableVC?.isFollowdByLocation = (true,arrTitles[indexPath.row])
            
            for brand in arrFilteredBrandList{
                if arrTitles[indexPath.row] == brand.StateOrCountry{
                    commonTableVC?.arrFilteredBrandList.append(brand)
                }
            }

            commonTableVC?.filterType = self.filterType
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
            
        }else if commonVCType == . FilterByCategory{
            
            let feedVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_FEED_VC) as? FeedVC
            
            var sCategoryTitle = String()
            if indexPath.row == 0{
                sCategoryTitle = "Multi Category Labels"
            }else{
                sCategoryTitle = "\(LabelListCategory.init(rawValue: indexPath.row)!) Labels"
            }
            
            feedVC?.filteredNavTitle = sCategoryTitle
            
            if let isFollowdByLocationObj = isFollowdByLocation{
                if isFollowdByLocationObj.value{
                    feedVC?.filteredString = "\(filterType) - \((isFollowdByLocation?.location)!) - \(sCategoryTitle)"
                }
            }else{
                feedVC?.filteredString = "\(filterType) - \(sCategoryTitle)"
            }
            
            feedVC?.mainVCType = .Filter
            

            for brand in arrFilteredBrandList{
                if ((brand.BrandCategory == Labels.Multi.rawValue) && (arrTitles[indexPath.row] == "Multi Category Labels") ||
                (brand.BrandCategory == Labels.Clothing.rawValue) && (arrTitles[indexPath.row] == "Clothing Labels")) ||
                ((brand.BrandCategory == Labels.Accessories.rawValue) && (arrTitles[indexPath.row] == "Accessory Labels")) ||
                ((brand.BrandCategory == Labels.Jewelry.rawValue) && (arrTitles[indexPath.row] == "Jewelry Labels") ) ||
                ((brand.BrandCategory == Labels.Shoes.rawValue) && (arrTitles[indexPath.row] == "Shoe Labels")) ||
                ((brand.BrandCategory == Labels.Bags.rawValue) && (arrTitles[indexPath.row] == "Bag Labels")){
                    feedVC?.arrFilteredBrandList.append(brand)
                }
            }
            
            
            navigationController?.pushViewController(feedVC!, animated: true)
            
        }else{
            debugPrint("getTitles commonVCType Unknown")
        }
    }
}


//
//MARK:- IBAction Methods
//
extension CommonTableVC{
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension CommonTableVC{
    func setupOnLoad(){
        func getTitles(commonVCType:CommonVCType)->[String]{
            if commonVCType == .FilterLabels{
                let filterTitle = "FILTER \(filterType)"
                IBbtnTitle.setTitle(filterTitle.uppercaseString, forState: .Normal)
                return ["By Location","By Label Category"]
                
            }else if commonVCType == .FilterByCategory{
                
                var headerTitle = "LABEL CATEGORY"
                if let isFollowdByLocationObj = isFollowdByLocation{
                    if isFollowdByLocationObj.value{
                        headerTitle = (isFollowdByLocationObj.location?.uppercaseString)!
                    }
                }
                IBbtnTitle.setTitle(headerTitle, forState: .Normal)
                return ["Multi Category Labels","Clothing Labels","Accessory Labels","Jewelry Labels","Shoe Labels","Bag Labels"]
                
            }else if commonVCType == .FilterByLocationThenCategory {
                
                IBbtnTitle.setTitle("LOCATION", forState: .Normal)
                var arrTitles:[String] = []
                
                for brand in arrFilteredBrandList{
                    arrTitles.append(brand.StateOrCountry)
                    arrTitles = Array(Set(arrTitles))
                    arrTitles = arrTitles.sort{$0 < $1}
                }
                
                return arrTitles
                
            }else{
                
                debugPrint("getTitles commonVCType Unknown")
                return []
                
            }
        }
        arrTitles = getTitles(commonVCType)
        tableView.tableFooterView = UIView()
    }
}


//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension CommonTableVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navVC = navigationController{
            if navVC.viewControllers.count > 1{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}