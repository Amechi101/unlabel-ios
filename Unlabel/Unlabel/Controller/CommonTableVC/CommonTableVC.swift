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

enum ProductCategory:Int{
    case All = 0
    case Clothing = 1
    case Accessories = 2
    case Jewelry = 3
    case Shoes = 4
    case Bags = 5
}

class CommonTableVC: UITableViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBbtnTitle: UIButton!
    
    var commonVCType:CommonVCType = .Unknown
    
    var arrTitles:[String] = [ ]
    var arrBrandList:[Brand] = [ ]
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
        if commonVCType == . FilterLabels{
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.arrBrandList = self.arrBrandList
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
        }else if commonVCType == . FilterByCategory{
            
            let feedVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_FEED_VC) as? FeedVC
            feedVC?.arrFilteredBrandList = arrBrandList
            
            var sCategoryTitle = String()
            if indexPath.row == 0{
                sCategoryTitle = "All categories"
            }else{
                sCategoryTitle = String(ProductCategory.init(rawValue: indexPath.row)!)
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
            navigationController?.pushViewController(feedVC!, animated: true)
            
        }else if commonVCType == . FilterByLocationThenCategory{
        
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.commonVCType = .FilterByCategory
            commonTableVC?.isFollowdByLocation = (true,arrTitles[indexPath.row])
            commonTableVC?.arrBrandList = self.arrBrandList
            commonTableVC?.filterType = self.filterType
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
            
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
            if commonVCType == . FilterLabels{
                let filterTitle = "FILTER \(filterType)"
                IBbtnTitle.setTitle(filterTitle.uppercaseString, forState: .Normal)
                return ["By Location","By Category"]
                
            }else if commonVCType == . FilterByCategory{
                
                var headerTitle = "CATEGORY"
                if let isFollowdByLocationObj = isFollowdByLocation{
                    if isFollowdByLocationObj.value{
                        headerTitle = (isFollowdByLocationObj.location?.uppercaseString)!
                    }
                }
                IBbtnTitle.setTitle(headerTitle, forState: .Normal)
                return ["All categories","Clothing","Accessories","Jewelry","Shoes","Bags"]
                
            }else if commonVCType == .FilterByLocationThenCategory {
                
                IBbtnTitle.setTitle("LOCATION", forState: .Normal)
                var arrTitles:[String] = []
                
                for brand in arrBrandList{
                    arrTitles.append(brand.OriginCity)
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