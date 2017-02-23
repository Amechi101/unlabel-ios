//
//  CommonTableVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 18/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum CommonVCType{
    case unknown
    case filterLabels
    case filterByCategory
    case filterByLocationThenCategory
}

enum LabelListCategory:Int{
    case all = 0
    case multi = 1
    case clothing = 2
    case accessory = 3
    case jewelry = 4
    case shoe = 5
    case bag = 6
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
    
    var commonVCType:CommonVCType = .unknown
    
    var arrTitles:[String] = [ ]
    var arrFilteredBrandList:[Brand] = [ ]
    var filterType:FilterType = .unknown
    var isFollowdByLocation:(value:Bool,location:String?)?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_FILTER_LABELS{
            if let commonTableVC:CommonTableVC = segue.destination as? CommonTableVC{
                commonTableVC.commonVCType = .filterLabels
            }
        }
    }
}


//
//MARK:- Table view data source Methods
//
extension CommonTableVC{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commonTableVCCell:CommonTableVCCell = (tableView.dequeueReusableCell(withIdentifier: REUSABLE_ID_CommonTableVCCell, for: indexPath) as? CommonTableVCCell)!
        
        commonTableVCCell.IBlblTitle?.text = "test"
        
        return commonTableVCCell
    }
}


//
//MARK:- Table view data source Methods
//
extension CommonTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleCellClick(forIndexPath: indexPath)
    }
    
    func handleCellClick(forIndexPath indexPath:IndexPath){
        if commonVCType == .filterLabels{
            let commonTableVC = storyboard?.instantiateViewController(withIdentifier: S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.arrFilteredBrandList = self.arrFilteredBrandList
            commonTableVC?.isFollowdByLocation = self.isFollowdByLocation
            commonTableVC?.filterType = self.filterType
            
            if indexPath.row == 0{
                commonTableVC?.commonVCType = .filterByLocationThenCategory
            }else if indexPath.row == 1{
                commonTableVC?.commonVCType = .filterByCategory
            }else{
                debugPrint("handleCellClick Unknown")
            }
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
        }else if commonVCType == . filterByLocationThenCategory{
        
            let commonTableVC = storyboard?.instantiateViewController(withIdentifier: S_ID_COMMON_TABLE_VC) as? CommonTableVC
            commonTableVC?.commonVCType = .filterByCategory
            commonTableVC?.isFollowdByLocation = (true,arrTitles[indexPath.row])
            
            for brand in arrFilteredBrandList{
                if arrTitles[indexPath.row] == brand.StateOrCountry{
                    commonTableVC?.arrFilteredBrandList.append(brand)
                }
            }

            commonTableVC?.filterType = self.filterType
            
            navigationController?.pushViewController(commonTableVC!, animated: true)
            
        }else if commonVCType == . filterByCategory{
            
            let feedVC = storyboard?.instantiateViewController(withIdentifier: S_ID_FEED_VC) as? FeedVC
            
            var sCategoryTitle = String()
            if ( indexPath.row == 0 ) {
                sCategoryTitle = "All Categories"
            } else if ( indexPath.row == 1 ){
                sCategoryTitle = "Mixed Labels"
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
            
            feedVC?.mainVCType = .filter

            if indexPath.row == 0{  //All categories
                feedVC?.arrFilteredBrandList = self.arrFilteredBrandList
            }else{
                for brand in arrFilteredBrandList{
                    if ((brand.BrandCategory == Labels.Multi.rawValue) && (arrTitles[indexPath.row] == "Mixed Labels") ||
                    (brand.BrandCategory == Labels.Clothing.rawValue) && (arrTitles[indexPath.row] == "Clothing Labels")) ||
                    ((brand.BrandCategory == Labels.Accessories.rawValue) && (arrTitles[indexPath.row] == "Accessory Labels")) ||
                    ((brand.BrandCategory == Labels.Jewelry.rawValue) && (arrTitles[indexPath.row] == "Jewelry Labels") ) ||
                    ((brand.BrandCategory == Labels.Shoes.rawValue) && (arrTitles[indexPath.row] == "Shoe Labels")) ||
                    ((brand.BrandCategory == Labels.Bags.rawValue) && (arrTitles[indexPath.row] == "Bag Labels")){
                        feedVC?.arrFilteredBrandList.append(brand)
                    }
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
    @IBAction func IBActionBack(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
}


//
//MARK:- Custom Methods
//
extension CommonTableVC{
    func setupOnLoad(){
      self.tableView.register(CommonTableVCCell.self, forCellReuseIdentifier: REUSABLE_ID_CommonTableVCCell)
        func getTitles(_ commonVCType:CommonVCType)->[String]{
            if commonVCType == .filterLabels{
                let filterTitle = "FILTER \(filterType)"
                IBbtnTitle.setTitle(filterTitle.uppercased(), for: UIControlState())
                return ["By Location","By Label Category"]
                
            }else if commonVCType == .filterByCategory{
                
                var headerTitle = "LABEL CATEGORY"
                if let isFollowdByLocationObj = isFollowdByLocation{
                    if isFollowdByLocationObj.value{
                        headerTitle = (isFollowdByLocationObj.location?.uppercased())!
                    }
                }
                IBbtnTitle.setTitle(headerTitle, for: UIControlState())
                return ["All Categories", "Mixed Labels","Clothing Labels","Accessory Labels","Jewelry Labels","Shoe Labels","Bag Labels"]
                
            }else if commonVCType == .filterByLocationThenCategory {
                
                IBbtnTitle.setTitle("LOCATION", for: UIControlState())
                var arrTitles:[String] = []
                
                for brand in arrFilteredBrandList{
                    arrTitles.append(brand.StateOrCountry)
                    arrTitles = Array(Set(arrTitles))
                    arrTitles = arrTitles.sorted{$0 < $1}
                }
                
                return arrTitles
                
            }else{

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
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
