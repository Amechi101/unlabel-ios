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
    case FilterCategory
    case FilterLocation
}

enum ProductCategory:Int{
    case Clothing = 0
    case Accessories = 1
    case Jewelry = 2
    case Shoes = 3
    case Bags = 4
}

class CommonTableVC: UITableViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    var commonVCType:CommonVCType = .Unknown
    
    var arrTitles:[String] = [ ]
    
    
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
            
            if indexPath.row == 0{
                commonTableVC?.commonVCType = .FilterLocation
            }else if indexPath.row == 1{
                commonTableVC?.commonVCType = .FilterCategory
            }else{
                debugPrint("handleCellClick Unknown")
            }
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
        }else if commonVCType == . FilterCategory{
            let feedVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_FEED_VC) as? FeedVC
            feedVC?.filteredProductCategory = ProductCategory.init(rawValue: indexPath.row)
            navigationController?.pushViewController(feedVC!, animated: true)
        }else if commonVCType == . FilterLocation{
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.commonVCType = .FilterCategory
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
                return ["By Location","By Category"]
            }else if commonVCType == . FilterCategory{
                return ["Clothing","Accessories","Jewelry","Shoes","Bags"]
            }else if commonVCType == . FilterLocation{
                return []
            }else{
                debugPrint("getTitles commonVCType Unknown")
                return []
            }
        }
        
        tableView.tableFooterView = UIView()
        arrTitles = getTitles(commonVCType)
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
