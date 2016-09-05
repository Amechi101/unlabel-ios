//
//  FilterListController.swift
//  Unlabel
//
//  Created by jasmin on 03/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import SwiftyJSON
import Alamofire

class FilterListController: UIViewController {

   @IBOutlet weak var IBlblTitleBar: UILabel!
   @IBOutlet weak var IBtableFilterList: UITableView!
   @IBOutlet weak var IBbtnApply: UIButton!
   
   
    var categoryStyleType:CategoryStyleEnum!
    var arFilterMenu:[String] = ["All"]
    var arOriginalJSON:[JSON]!
    var arSelectedValues:[String] = []
   
   
   var dictSelection:[Int: Bool] = [0:false]
   
   
//   MARK:- Life Cycle methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        WSGetAllFilterList(ByCategoryType: categoryStyleType)
      
      self.automaticallyAdjustsScrollViewInsets = false 
      self.IBtableFilterList.tableFooterView = UIView()
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
    
   }
   
  
   private func setUp() {
      self.IBtableFilterList.removeMargines()
      self.IBtableFilterList.separatorColor =  LIGHT_GRAY_TEXT_COLOR.colorWithAlphaComponent(0.5)
      IBlblTitleBar.text = categoryStyleType.description
      IBtableFilterList.dataSource = self
      IBtableFilterList.delegate = self
      
      IBbtnApply.hidden = true
      
      IBtableFilterList.allowsMultipleSelection = true
      IBtableFilterList.registerNib(UINib(nibName: "FilterListCell", bundle: nil), forCellReuseIdentifier: "FilterListCell")
      IBtableFilterList.registerNib(UINib(nibName: "FilterHeaderCell", bundle: nil), forCellReuseIdentifier: "FilterHeaderCell")

   }
   
   private func registerCell(withID reusableID:String){
      IBtableFilterList.registerNib(UINib(nibName: reusableID, bundle: nil), forCellReuseIdentifier: reusableID)
   }
   
   private func WSGetAllFilterList(ByCategoryType type:CategoryStyleEnum) {
      UnlabelLoadingView.sharedInstance.start(self.view)
      UnlabelAPIHelper.sharedInstance.getFilterCategories(type, success: { (filters, meta) in
         let categories:[String] = filters.map { return $0["name"].stringValue }
         self.arFilterMenu += categories
         self.arOriginalJSON = filters
         
         for (index, _) in self.arFilterMenu.enumerate() {
            self.dictSelection[index] = false
         }
         
         if self.arSelectedValues.count > 0  {
            
            if self.arSelectedValues.count == self.arFilterMenu.count - 1 {
               self.dictSelection[0] = true
                for row in 1..<self.arFilterMenu.count {
                  self.dictSelection[row] = self.dictSelection[0]!
               }
            } else {
                self.IBtableFilterList.reloadData()
               for (index, menu) in  self.arFilterMenu.enumerate()  {
                  for  value in self.arSelectedValues {
                     if value == menu {
                       self.dictSelection[index] = true
                     }
                  }
               }
            }
         }
     
         dispatch_async(dispatch_get_main_queue()) {
            UnlabelLoadingView.sharedInstance.stop(self.view)
            self.IBbtnApply.hidden = false
            
             self.IBtableFilterList.reloadData()
            
         }
         
         }, failed: { (error) in
            UnlabelLoadingView.sharedInstance.stop(self.view)
            debugPrint(error)
            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
      })
   }
   
//   MARK:- Action methods 
   @IBAction func IBActionClose(sender: AnyObject) {
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   
   

}

// MARK:- TableView Delegates and Datasource

extension FilterListController: UITableViewDelegate , UITableViewDataSource {
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return arFilterMenu.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
     let cell = tableView.dequeueReusableCellWithIdentifier("FilterListCell") as! FilterListCell
        let _selection = self.dictSelection[indexPath.row]!.boolValue
      
       cell.configureCell(indexPath, selection: _selection)
       cell.IBlblFilterListName?.text = self.arFilterMenu[indexPath.row]
      
      return cell
   }
  
 
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
      if indexPath.row == 0 { // All
         self.dictSelection[0] = !self.dictSelection[0]!
         if self.dictSelection[0]!.boolValue {
            arSelectedValues.removeAll()
            arSelectedValues = Array(arFilterMenu[1..<arFilterMenu.count])
         } else {
            arSelectedValues.removeAll()
         }
         
         let totalRows = IBtableFilterList.numberOfRowsInSection(0)
         for row in 1..<totalRows {
            self.dictSelection[row] = self.dictSelection[0]!
         }
      } else {
         arSelectedValues.removeAll()
         
         self.dictSelection[indexPath.row] = !self.dictSelection[indexPath.row]!
         let indexes = self.dictSelection.filter { $0.0 > 0 && $0.1 == true }.map { return $0.0 }
         for index in indexes {
            arSelectedValues.append(arFilterMenu[index])
         }
         if arSelectedValues.count == arFilterMenu.count - 1 {
            self.dictSelection[0] = true
            arSelectedValues = Array(arFilterMenu[1..<arFilterMenu.count])
         } else {
            if self.dictSelection[0] == true {
               self.dictSelection[0] = false
            }
         }
      }
      
       IBtableFilterList.reloadData()
      
   }
   
  
   // View section header
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 55
   }
   
   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let _headerView = tableView.dequeueReusableCellWithIdentifier("FilterHeaderCell") as! FilterHeaderCell
      _headerView.delegate = self
      _headerView.FilterHeaderTitle.text = categoryStyleType.glossaryTitle
      
      return _headerView
   }
   
}


extension FilterListController: FilterListDelegates {
   func headerCellClicked() {
      let glosryCntrl = storyboard?.instantiateViewControllerWithIdentifier("GlossaryController") as! GlossaryController
      glosryCntrl.arGlossaryValues = arOriginalJSON ?? []
      glosryCntrl.categoryStyleType = self.categoryStyleType
      self.navigationController?.pushViewController(glosryCntrl, animated: true)
   }
}

