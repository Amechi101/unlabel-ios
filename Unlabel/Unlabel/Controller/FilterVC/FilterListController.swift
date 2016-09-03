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
    var arFilterMenu:[String] = ["", "All"]
    var arOriginalJSON:[JSON]!
    var arSelectedValues:[String] = []
   
    var selectedAll:Bool = false
   
//   MARK:- Life Cycle methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        WSGetAllFilterList(ByCategoryType: categoryStyleType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
//      self.IBtableFilterList.reloadData()
   }
   
   private func updateTableForSelectedValues() {
      if arSelectedValues.count > 0 {
         for (_index, menu) in arFilterMenu.enumerate() where arFilterMenu.count > 0 {
            for (_, selectedValue) in arSelectedValues.enumerate() where selectedValue == menu {
               let _indexPath = NSIndexPath(forRow: _index, inSection: 0)
               let cell = IBtableFilterList.cellForRowAtIndexPath(_indexPath)
               cell?.accessoryView = UIImageView(image: UIImage(named: "category_checkmark"))
            }
         }
         
         self.IBtableFilterList.reloadData()
      }
   }
   
   private func setUp() {
      self.IBtableFilterList.removeMargines()
      self.IBtableFilterList.separatorColor =  UIColor(red: 69/255, green: 73/255, blue: 78/255, alpha: 0.6)
      // MEDIUM_GRAY_TEXT_COLOR
      IBlblTitleBar.text = categoryStyleType.description
      IBtableFilterList.dataSource = self
      IBtableFilterList.delegate = self
      
      IBbtnApply.hidden = true
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
   
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       if indexPath.row == 0 {
          return 55
       }
      
     return 45
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
      cell.selectionStyle = .None
      cell.textLabel?.font = UIFont.systemFontOfSize(16)
      cell.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
      cell.removeMargines()
      
      if indexPath.row == 0 {
         cell.accessoryType = .DisclosureIndicator
         cell.textLabel?.text = categoryStyleType.glossaryTitle
      } else if indexPath.row == 1 {
         cell.textLabel?.text = "All"
      } else {
         cell.accessoryView = nil
         //TODO:update cell for those 
         
         if arSelectedValues.count > 0 {
            let _orVal = arFilterMenu[indexPath.row]
            for val in arSelectedValues where val ==  _orVal{
               cell.accessoryView = UIImageView(image: UIImage(named: "category_checkmark"))
            }
         }
         
         cell.textLabel?.text = self.arFilterMenu[indexPath.row]
      }
      
       return cell
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return arFilterMenu.count
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      let cell = tableView.cellForRowAtIndexPath(indexPath)
     
      
      if indexPath.row == 0 {      
         let glosryCntrl = storyboard?.instantiateViewControllerWithIdentifier("GlossaryController") as! GlossaryController
         glosryCntrl.arGlossaryValues = arOriginalJSON ?? []
         glosryCntrl.categoryStyleType = self.categoryStyleType
         self.navigationController?.pushViewController(glosryCntrl, animated: true)
         selectedAll = false
         
      } else if indexPath.row == 1 { // All
         arSelectedValues.removeAll()
         cell?.textLabel?.textColor = UIColor.lightGrayColor()
         arFilterMenu = arFilterMenu.filter { return $0 != "" }
         if arFilterMenu.first == "All" {
            arFilterMenu.removeFirst()
         }
         arSelectedValues = arFilterMenu
         
         selectedAll = true
      } else {
         if selectedAll == false {
            if  cell?.accessoryView == nil {
               arSelectedValues.append( self.arFilterMenu[indexPath.row] )
               cell?.accessoryView = UIImageView(image: UIImage(named: "category_checkmark"))
            } else {
               cell?.accessoryView = nil
               arSelectedValues.removeLast()
            }
         }
      }
   }
   
}
