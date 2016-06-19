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
    case FilterByLocation
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
    
    @IBOutlet weak var IBbtnTitle: UIButton!
    
    var commonVCType:CommonVCType = .Unknown
    
    var arrTitles:[String] = [ ]
    var arrBrands:[Brand] = [ ]
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
            
            if indexPath.row == 0{
                commonTableVC?.commonVCType = .FilterByLocation
            }else if indexPath.row == 1{
                commonTableVC?.commonVCType = .FilterByCategory
            }else{
                debugPrint("handleCellClick Unknown")
            }
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
        }else if commonVCType == . FilterByCategory{
            
            let feedVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_FEED_VC) as? FeedVC
            feedVC?.filteredProductCategory = ProductCategory.init(rawValue: indexPath.row)
            feedVC?.mainVCType = .Filter
            navigationController?.pushViewController(feedVC!, animated: true)
            
        }else if commonVCType == . FilterByLocation{
        
            let commonTableVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.commonVCType = .FilterByCategory
            commonTableVC?.isFollowdByLocation = (true,arrTitles[indexPath.row])
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
                
                IBbtnTitle.setTitle("FILTER LABELS", forState: .Normal)
                return ["By Location","By Category"]
                
            }else if commonVCType == . FilterByCategory{
                
                var headerTitle = "CATEGORY"
                if let isFollowdByLocationObj = isFollowdByLocation{
                    if isFollowdByLocationObj.value{
                        headerTitle = (isFollowdByLocationObj.location?.uppercaseString)!
                    }
                }
                IBbtnTitle.setTitle(headerTitle, forState: .Normal)
                return ["Clothing","Accessories","Jewelry","Shoes","Bags"]
                
            }else{
                
                debugPrint("getTitles commonVCType Unknown")
                return []
                
            }
        }
        arrTitles = getTitles(commonVCType)
        
        if commonVCType == .FilterByLocation {
            IBbtnTitle.setTitle("LOCATION", forState: .Normal)
            wsCallGetLabels()
        }
        
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


//
//MARK:- wsCallGetLabels Methods
//
extension CommonTableVC{
    /**
     WS call get all brands
     */
    func wsCallGetLabels(){
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            UnlabelLoadingView.sharedInstance.start(view)
            UnlabelAPIHelper.sharedInstance.getBrands(nil, success: { (arrBrands:[Brand]) in
                UnlabelLoadingView.sharedInstance.stop(self.view)
                self.arrBrands = arrBrands
                for brand in arrBrands{
                    self.arrTitles.append(brand.OriginCity)
                    self.tableView.reloadData()
                }
            }, failed: { (error) in
                UnlabelLoadingView.sharedInstance.stop(self.view)
                debugPrint(error)
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
            })
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
        }
    }
}