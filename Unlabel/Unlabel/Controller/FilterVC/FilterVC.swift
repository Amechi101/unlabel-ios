//
//  FilterVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



enum CategoryStyleEnum: CustomStringConvertible {
   case category , style, location
   
   var glossaryTitle:String {
      switch self {
      case .category:
         return "View Category glossary"
      case .style:
         return "View Style glossary"
         case .location: return ""
      }
   }
   
   var defaultTitle:String {
      switch self {
      case .category:
         return "Select Category"
      case .style:
         return "Select Style"
      case .location: return ""
      }
   }
   
   
   var title:String {
      switch self {
      case .category:
         return "Category".uppercased()
      case .style:
         return "Style".uppercased()
      case .location:
         return "Location".uppercased()
      }
   }
   
   var description: String {
      switch self {
      case .category:
         return "Category".uppercased()
      case .style:
         return "Style".uppercased()
      case .location:
         return "Location".uppercased()
      }
   }
}



//
//MARK:- FilterVC Protocols
//
protocol FilterVCDelegate{
    func willCloseChildVC(_ childVCName:String)
//    func didClickShowLabels(category:String?,location:String?)
    func didClickShowLabels(_ category:String?,location:String?, style:String?)

}


//
//MARK:- FilterVC Enums
//

class FilterVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    
    
    @IBOutlet weak var IBbtnShowLabels: UIButton!
    @IBOutlet weak var IBlblFilterFor: UILabel!
    @IBOutlet weak var IBtblFilter: UITableView!
    @IBOutlet weak var IBbtnClear: UIButton!
   
//    @IBOutlet weak var IBpickerView: UIPickerView!
   
//    @IBOutlet weak var IBconstraintPickerHeight: NSLayoutConstraint!
//    @IBOutlet weak var IBconstraintPickerMainBottom: NSLayoutConstraint!
   
//    private let arrCategories:[String] = ["Choose Category", "Select Style",  "All","Clothing","Accessories","Jewelry","Shoes","Bags"]
    fileprivate var arrLocationsUSA:[Location] = []
    fileprivate var arrLocationsInternational:[Location] = []
   
   fileprivate var selectedCategory:String = CategoryStyleEnum.category.defaultTitle {
      didSet {
         if selectedCategory == "" {
             selectedCategory = CategoryStyleEnum.category.defaultTitle
         }
      }
   }
   fileprivate var selectedStyle:String = CategoryStyleEnum.style.defaultTitle {
      didSet {
         if selectedStyle == "" {
            selectedStyle = CategoryStyleEnum.style.defaultTitle
         }
      }
   }
   
   fileprivate var arSelectedCategory:[String] = []
   fileprivate var arSelectedStyle:[String] = []

//    private var selectedCategoryIndexRow:Int = 0
    fileprivate var selectedLocation:String?
    
    fileprivate let arrFilterTitles:[String] = ["LABEL CATEGORY", "STYLE", "LOCATION"]
   var shouldClearCategories = false
    
    var delegate:FilterVCDelegate?
    var selectedFilterType:FilterType = .unknown
    
    var locationChoices:LocationChoices = LocationChoices.International
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        setupDataLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   
   @IBAction func unwindBackToFilterViewController(_ segue: UIStoryboardSegue) {
      if segue.identifier == "backToFilterController" {
          let filterListController = segue.source as! FilterListController
         
         if filterListController.arSelectedValues.count > 0 {
            let filteredValues = filterListController.arSelectedValues.filter { return $0 != "" }
            
            if filterListController.categoryStyleType == CategoryStyleEnum.category {
               self.arSelectedCategory = filteredValues
               if self.arSelectedCategory.count > 3 {
                  self.selectedCategory = Array(filteredValues[0..<3]).joined(separator: ",") + "..."
               } else {
                  self.selectedCategory = filteredValues.joined(separator: ",")
               }
            } else {
               self.arSelectedStyle = filteredValues
               if self.arSelectedStyle.count > 3 {
                  self.selectedStyle = Array(filteredValues[0..<3]).joined(separator: ",") + "..."
               } else {
                  self.selectedStyle = filteredValues.joined(separator: ",")
               }
            }
            
            if  filterListController.arSelectedValues.count ==  filterListController.arFilterMenu.count - 1 {
               if filterListController.categoryStyleType == CategoryStyleEnum.category {
                   self.selectedCategory = "All"
               } else {
                   self.selectedStyle = "All"
               }
            }
            
            
            
            
         } else {
             if filterListController.categoryStyleType == CategoryStyleEnum.category {
               self.arSelectedCategory.removeAll()
               selectedCategory = CategoryStyleEnum.category.defaultTitle
             } else {
               self.arSelectedStyle.removeAll()
               selectedStyle = CategoryStyleEnum.style.defaultTitle
             }
         }
         
         IBtblFilter.reloadData()
         
      }
   }
}


//
//MARK:- UITableViewDelegate Methods
//
extension FilterVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


//
//MARK:- FilterTitleCellDelegate Methods
//
extension FilterVC:FilterTitleCellDelegate{
    func didChangeTab(_ index: Int) {
        selectedLocation = nil
        reloadData()
    }
}


//
//MARK:- UITableViewDataSource Methods
//
extension FilterVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 50
        } else if indexPath.row == 5 {
            return 160+45+12 //Total cell heigh + cell spaces height + collecitonview to top height
        }else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
         if indexPath.row == 0 {
            return cellWithTitle(CategoryStyleEnum.category)
         } else if indexPath.row == 1 {
            return categoryStyleCell(indexPath, type: .category)
         } else if indexPath.row == 2 {
            return cellWithTitle(CategoryStyleEnum.style)
         } else if indexPath.row == 3 {
            return categoryStyleCell(indexPath, type: .style)
         } else if indexPath.row == 4 {
            return filterTitleCell(indexPath)
         }else if indexPath.row == 5 {
            return categoryLocationCell(indexPath)
         }else{
            return UITableViewCell()
         }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func cellWithTitle(_ type:CategoryStyleEnum)->UITableViewCell{
        let cellWithTitle = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cellWithTitle.textLabel?.text = type.title
        cellWithTitle.layoutMargins = UIEdgeInsets.zero
        cellWithTitle.separatorInset = UIEdgeInsetsMake(0, 30, 0, 28)
        cellWithTitle.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
        cellWithTitle.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_DEMI, size: 16)
        
        return cellWithTitle
    }
    
    func filterTitleCell(_ indexPath:IndexPath)->FilterTitleCell{
        let filterTitleCell = IBtblFilter.dequeueReusableCell(withIdentifier: REUSABLE_ID_FilterTitleCell) as? FilterTitleCell
        filterTitleCell?.delegate = self
        
        var USATextColor:UIColor?
        var InternationalTextColor:UIColor?
        
        if filterTitleCell?.selectedTab == 0{
            locationChoices = .USA
            USATextColor = MEDIUM_GRAY_TEXT_COLOR
            InternationalTextColor = LIGHT_GRAY_TEXT_COLOR
        }else{
            locationChoices = .International
            USATextColor = LIGHT_GRAY_TEXT_COLOR
            InternationalTextColor = MEDIUM_GRAY_TEXT_COLOR
        }
        
        filterTitleCell?.IBbtnUSA.setTitleColor(USATextColor, for: UIControlState())
        filterTitleCell?.IBBtnInternational.setTitleColor(InternationalTextColor, for: UIControlState())
        
        return filterTitleCell!
    }
    
   func categoryStyleCell(_ indexPath:IndexPath, type:CategoryStyleEnum)->CategoryStyleCell{
      
      let categoryStyleCell = IBtblFilter.dequeueReusableCell(withIdentifier: REUSABLE_ID_CategoryStyleCell) as? CategoryStyleCell
      categoryStyleCell?.delegate = self
      if type == .category {
         categoryStyleCell?.configureCell(cellTitle: self.selectedCategory, type: type)
      } else {
         categoryStyleCell?.configureCell(cellTitle: self.selectedStyle, type: type)
      }
      
      //elected row should be display
//      categoryStyleCell?.IBbtnCategoryStyle.setTitle("    \(type.defaultTitle)", forState: .Normal)
//      categoryStyleCell?.IBbtnCategoryStyle.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.colorWithAlphaComponent(0.5).CGColor
//      categoryStyleCell?.IBbtnCategoryStyle.setTitleColor(LIGHT_GRAY_TEXT_COLOR, forState: .Normal)
      
      //      if IBconstraintPickerMainBottom.constant != 0 {
      //      } else {
      //         categoryStyleCell?.IBbtnCategoryStyle.layer.borderColor = DARK_GRAY_COLOR.colorWithAlphaComponent(0.8).CGColor
      //         categoryStyleCell?.IBbtnCategoryStyle.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
      //      }
      
      return categoryStyleCell!
   }
   
   
    //Location boxes
    func categoryLocationCell(_ indexPath:IndexPath)->CategoryLocationCell{
        let categoryLocationCell = IBtblFilter.dequeueReusableCell(withIdentifier: REUSABLE_ID_CategoryLocationCell) as! CategoryLocationCell
        categoryLocationCell.delegate = self
        
        if categoryLocationCell.locationChoices != locationChoices {
            categoryLocationCell.selectedLocationIndex = nil
        }
        
        categoryLocationCell.locationChoices = locationChoices
        
        if locationChoices == .USA{
            categoryLocationCell.arrLocations = arrLocationsUSA
        }else if locationChoices == .International{
            categoryLocationCell.arrLocations = arrLocationsInternational
        }
        categoryLocationCell.IBcollectionView.reloadData()
        
        return categoryLocationCell
    }
    
}


//
//MARK:- CategoryStyleCellDelegate
//
extension FilterVC: CategoryStyleCellDelegate{
   func didClickStyleCell(_ forTag: Int) {
   }
   
    func didClickStyleCell(_ type:CategoryStyleEnum) {
      let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
      
      if type == .category {
         _presentController.categoryStyleType = .category
         _presentController.arSelectedValues = arSelectedCategory
      } else if type == .style {
         _presentController.categoryStyleType = .style
         _presentController.arSelectedValues = arSelectedStyle
      }
      
      
      let _navFilterList = UINavigationController(rootViewController: _presentController)
      _navFilterList.isNavigationBarHidden = true
      
      self.present(_navFilterList, animated: true, completion: nil)
    }
}


//
//MARK:- CategoryDelegate
//
extension FilterVC:CategoryDelegate{
    func didSelectLocation(_ location: String?) {
        selectedLocation = location
        reloadData()
    }
}

//
//MARK:- UIPickerViewDelegate,UIPickerViewDataSource
//
//extension FilterVC:UIPickerViewDelegate,UIPickerViewDataSource{
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return arrCategories.count
//    }
//    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return arrCategories[row]
//    }
//}


//
//MARK:- FilterVC IBAction Methods
//
extension FilterVC{
    
    @IBAction func IBActionClose(_ sender: AnyObject) {
        close()
    }
    
//    @IBAction func IBActionPickerCancel(sender: UIButton) {
//        hidePicker()
//    }
   
//    @IBAction func IBActionPickerSelect(sender: UIButton) {
//        selectedCategoryIndexRow = IBpickerView.selectedRowInComponent(0)
//        reloadData()
//        hidePicker()
//    }
//    
//    @IBAction func IBActionSwipeClosePicker(sender: UISwipeGestureRecognizer) {
//        hidePicker()
//    }
   
    @IBAction func IBActionShowLabels(_ sender: UIButton) {
        var selectedCategory:String?
        var selectedStyles:String?
 
      
         if CategoryStyleEnum.style.defaultTitle != self.selectedStyle { // Not default
            selectedStyles = self.selectedStyle
            if self.selectedStyle == "All" {
               selectedStyles = self.arSelectedStyle.joined(separator: ",")
            }
         }
      
         if CategoryStyleEnum.category.defaultTitle != self.selectedCategory {
            selectedCategory = self.selectedCategory
            if self.selectedCategory == "All" {
               selectedCategory = self.arSelectedCategory.joined(separator: ",")
            }
         }
      
        delegate?.didClickShowLabels(selectedCategory, location: selectedLocation, style:selectedStyles)
        close()
    }
    
    
    //
    //MARK:- CategoryStyleCell IBAction Methods
    //
    @IBAction func IBActionCategoryStyleClicked(_ sender: UIButton) {
        openPickerForTag(sender.tag)
    }
    
    func openPickerForTag(_ tag:Int){
        //        //All categories clicked
        //        if tag == PickerType.Categories.rawValue{
        //            selectedPickerType = .Categories
        //            arrPickerTitle = arrCategories
        //        //All styles clicked
        //        }else if tag == PickerType.Styles.rawValue{
        //            selectedPickerType = .Styles
        //            arrPickerTitle = arrStyle
        //        }
//        showPicker()
    }
}


//
//MARK:- Custom Methods
//
extension FilterVC{
    /**
     Setup UI on VC Load.
     */
    fileprivate func setupUIOnLoad(){
//        hidePicker()
      IBbtnClear.addTarget(self, action: #selector(FilterVC.btnClearPressed(_:)), for: .touchUpInside)
        registerCell(withID: REUSABLE_ID_GenderCell)
        registerCell(withID: REUSABLE_ID_FilterTitleCell)
        registerCell(withID: REUSABLE_ID_CategoryStyleCell)
        registerCell(withID: REUSABLE_ID_CategoryLocationCell)
    }
    
    fileprivate func setupDataLoad(){
        UnlabelLoadingView.sharedInstance.start(view)
        UnlabelAPIHelper.sharedInstance.getLocations { (arrAllLocations) in
            UnlabelLoadingView.sharedInstance.stop(self.view)
            
            if var allLocations = arrAllLocations, allLocations.count > 0{
                allLocations = allLocations.sorted{$0.stateOrCountry < $1.stateOrCountry}
                for location in allLocations{
                    if location.locationChoices == APIParams.locationChoicesCountry{
                        self.IBbtnShowLabels.isHidden = false
                        self.arrLocationsInternational.append(location)
                    }else if location.locationChoices == APIParams.locationChoicesState{
                        self.IBbtnShowLabels.isHidden = false
                        self.arrLocationsUSA.append(location)
                    }else{
                        
                    }
                }
                self.reloadData()
            }else{
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: { 
                  self.close()
                })
            }
        }
    }
    
    /**
     Setup UI on before appear.
     */
    func setupBeforeAppear(){
        if selectedFilterType == .men{
            IBlblFilterFor.text = "SEARCH MEN"
        }else{
            IBlblFilterFor.text = "SEARCH WOMEN"
        }
    }
    
    /**
     Register nib for given ID.
     */
    fileprivate func registerCell(withID reusableID:String){
        IBtblFilter.register(UINib(nibName: reusableID, bundle: nil), forCellReuseIdentifier: reusableID)
    }
    
    /**
     Remove self from parentViewController
     */
    fileprivate func close(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.alpha = 0
            self.view.frame.origin.x = SCREEN_WIDTH
        }, completion: { (value:Bool) -> Void in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.delegate?.willCloseChildVC(S_ID_FILTER_VC)
        }) 
    }
    
 
   
    fileprivate func reloadData(){
        UIView.transition(with: IBtblFilter, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.IBtblFilter.reloadData()
        }, completion: nil)
    }
   
   func btnClearPressed(_ sender:AnyObject) {
      selectedStyle = ""
      selectedCategory = ""
      arSelectedStyle.removeAll()
      arSelectedCategory.removeAll()
      arrLocationsUSA.removeAll()
      arrLocationsInternational.removeAll()
      IBbtnShowLabels.isHidden = false
      locationChoices = LocationChoices.International
      setupDataLoad()
      IBtblFilter.reloadData()
      
      
      let locationCell = categoryLocationCell(IndexPath(row: 5, section: 0))
      locationCell.selectedLocationIndex = nil
      locationCell.delegate?.didSelectLocation(nil)
   }
}
