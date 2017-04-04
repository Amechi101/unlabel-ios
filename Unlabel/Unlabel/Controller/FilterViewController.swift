//
//  FilterViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON


enum CategoryStyleEnum: CustomStringConvertible {
  case category , style, location, radius
  
  var glossaryTitle:String {
    switch self {
    case .category:
      return "View Category glossary"
    case .style:
      return "View Style glossary"
    case .location: return ""
    case .radius:
      let location_name: String = UnlabelHelper.getDefaultValue("location_name")!
      return location_name
    }
  }
  var defaultTitle:String {
    switch self {
    case .category:
      return "Select Category"
    case .style:
      return "Select Style"
    case .location: return "Select Location"
    case .radius: return ""
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
    case .radius:
      return ""
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
    case .radius:
      return ""
    }
  }
}
protocol FilterViewDelegate{
  func didClickShowLabels(_ category: String?, style: String?, store_type: String?, param: String?, count: String?,genderType: String)
  
}

class FilterViewController: UIViewController,UISearchBarDelegate {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBButtonMenswear: UIButton!
  @IBOutlet weak var IBButtonWomenswear: UIButton!
  @IBOutlet weak var IBButtonBrandCategory: UIButton!
  @IBOutlet weak var IBButtonStyle: UIButton!
  @IBOutlet weak var IBButtonLocation: UIButton!
  @IBOutlet weak var IBSearchBar: UISearchBar!
  var delegate:FilterViewDelegate?
  var selectedFilterType:FilterType = .unknown
  fileprivate var arSelectedCategory:[String] = []
  fileprivate var arSelectedStyle:[String] = []
  fileprivate var arSelectedLocation:[String] = []
  fileprivate var selectedLocation:String?
  fileprivate let arrFilterTitles:[String] = ["LABEL CATEGORY", "STYLE", "LOCATION"]
  var shouldClearCategories = false
  fileprivate var selectedCategory:String?
  fileprivate var selectedStyle:String?
  var sortParam: String = "AZ"
  var store_type: String?
  var genderType: String = "M"
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UnlabelAPIHelper.sharedInstance.getBrandStoreType({ (arrCountry:[FilterModel], meta: JSON) in
    }, failed: { (error) in
    })
    selectedLocation = ""
    selectedCategory = ""
    selectedStyle = ""
    IBSearchBar.text = ""
    genderType = UnlabelHelper.getDefaultValue("gender")!
    
    IBButtonMenswear.isSelected = true
    IBButtonMenswear.setBorderColor(LIGHT_GRAY_BORDER_COLOR,textColor: MEDIUM_GRAY_TEXT_COLOR)
    
     if genderType == "M"{
      IBButtonMenswear.setTitle("Men's Apparel", for: .normal)
    }
     else{
      IBButtonMenswear.setTitle("Women's Apparel", for: .normal)
    }
    IBButtonWomenswear.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func IBActionStoreType(_ sender: UIButton) {
    if sender.tag == 0{
      sender.isSelected = !sender.isSelected
      IBButtonWomenswear.isSelected = false
      if !sender.isSelected{
        sender.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
      }
      else{
        sender.setBorderColor(LIGHT_GRAY_BORDER_COLOR,textColor: MEDIUM_GRAY_TEXT_COLOR)
      }
      IBButtonWomenswear.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
    }
    else{
      IBButtonMenswear.isSelected = false
      sender.isSelected = !sender.isSelected
      if !sender.isSelected{
        sender.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
      }
      else{
        sender.setBorderColor(LIGHT_GRAY_BORDER_COLOR,textColor: MEDIUM_GRAY_TEXT_COLOR)
      }
      IBButtonMenswear.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
    }
  }
  @IBAction func IBActionCategory(_ sender: Any) {
    self.arSelectedCategory.removeAll()
    let _presentController = self.storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .category
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    self.present(_navFilterList, animated: true, completion: nil)
  }
  @IBAction func IBActionStyle(_ sender: Any) {
    self.arSelectedStyle.removeAll()
    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .style
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    self.present(_navFilterList, animated: true, completion: nil)
  }
  @IBAction func IBActionLocation(_ sender: Any) {
    //    self.arSelectedLocation.removeAll()
    //    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    //    _presentController.categoryStyleType = .location
    //    _presentController.arSelectedValues = []
    //    let _navFilterList = UINavigationController(rootViewController: _presentController)
    //    _navFilterList.isNavigationBarHidden = true
    //
    //    self.present(_navFilterList, animated: true, completion: nil)
    
    self.addSortPopupView(SlideUpView.brandSortMode,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionShowFilteredResults(_ sender: Any) {
    if IBButtonMenswear.isSelected && IBButtonWomenswear.isSelected{
      store_type = "1,2"
      genderType = "U"
    }
    else if IBButtonWomenswear.isSelected{
      store_type = "2"
      genderType = "F"
    }
    else if IBButtonMenswear.isSelected{
      store_type = "1"
      genderType = "M"
    }
    else{
      store_type = "1"
      genderType = "M"
    }
    var countStr: String = "0"
    let numString: String = selectedStyle! + "," + selectedCategory!
    print(numString)
    if numString == "" {
      countStr = "0"
    }
    else{
      let numArray : [String] = numString.components(separatedBy: ",")
      countStr = "\(numArray.count)"
    }
    print(countStr)
    delegate?.didClickShowLabels(self.selectedCategory, style: self.selectedStyle, store_type: store_type, param: sortParam,count: countStr,genderType: genderType)
    
    
  }
  @IBAction func unwindBackToFilterViewController(_ segue: UIStoryboardSegue) {
    if segue.identifier == "backToFilterController" {
      let filterListController = segue.source as! FilterListController
      if filterListController.arSelectedValues.count > 0 {
        let filteredValues = filterListController.arSelectedValues
        for filteredObject in filteredValues{
          if filterListController.categoryStyleType == CategoryStyleEnum.category {
            self.arSelectedCategory.append(filteredObject.typeId)
            let paramsJSON = JSON(self.arSelectedCategory)
            self.selectedCategory = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions(rawValue: 0))
            print(arSelectedCategory)
            self.selectedCategory = arSelectedCategory.flatMap({$0}).joined(separator: ",")
            print(selectedCategory!)
            self.IBButtonBrandCategory.setTitle("\(self.arSelectedCategory.count)" + " Categorie(s)", for: .normal)
          }
          else if filterListController.categoryStyleType == CategoryStyleEnum.style {
            self.arSelectedStyle.append(filteredObject.typeId)
            print(arSelectedStyle)
            self.selectedStyle = arSelectedStyle.flatMap({$0}).joined(separator: ",")
            self.IBButtonStyle.setTitle("\(self.arSelectedStyle.count)" + " Style(s)", for: .normal)
          }
          else if filterListController.categoryStyleType == CategoryStyleEnum.location {
            self.arSelectedLocation.append(filteredObject.typeId)
            self.selectedLocation = self.arSelectedLocation.joined(separator: ",")
            self.IBButtonLocation.setTitle("\(self.arSelectedLocation.count)" + " Location(s)", for: .normal)
          }
        }
        if  filterListController.arSelectedValues.count ==  filterListController.arFilterMenu.count - 1 {
          if filterListController.categoryStyleType == CategoryStyleEnum.category {
            self.selectedCategory = ""
            self.IBButtonBrandCategory.setTitle("All Categories", for: .normal)
          } else if filterListController.categoryStyleType == CategoryStyleEnum.style {
            self.selectedStyle = ""
            self.IBButtonStyle.setTitle("All Styles", for: .normal)
            
          }
          else if filterListController.categoryStyleType == CategoryStyleEnum.location{
            self.selectedLocation = ""
            self.IBButtonLocation.setTitle("All Locations", for: .normal)
          }
        }
      } else {
        if filterListController.categoryStyleType == CategoryStyleEnum.category {
          self.arSelectedCategory.removeAll()
          selectedCategory = ""
          self.IBButtonBrandCategory.setTitle("All Categories", for: .normal)
        } else if filterListController.categoryStyleType == CategoryStyleEnum.style  {
          self.arSelectedStyle.removeAll()
          selectedStyle = ""
          self.IBButtonStyle.setTitle("All Styles", for: .normal)
        } else if filterListController.categoryStyleType == CategoryStyleEnum.location  {
          self.arSelectedLocation.removeAll()
          selectedLocation = ""
          self.IBButtonLocation.setTitle("All Locations", for: .normal)
        }
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
  {
    self.IBSearchBar.endEditing(true)
  }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
    self.IBSearchBar.setShowsCancelButton(true, animated: true)
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
    self.IBSearchBar.setShowsCancelButton(false, animated: true)
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
    self.IBSearchBar.endEditing(true)
  }
}

extension FilterViewController: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SORT BY"
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
      })
      viewSortPopup.updateView()
    }
  }
  func popupDidClickCloseButton(){
  }
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
    IBButtonLocation.setTitle("Sort by: " + selectedItem.uName, for: .normal)
    sortParam = selectedItem.uId
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "LocationFilterSegue"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController{
        if let locationFilterVC:LocationFilterVC = navViewController.viewControllers[0] as? LocationFilterVC{
          //  pickLocationVC.categoryStyleType = CategoryStyleEnum.radius
          locationFilterVC.delegate = self
        }
      }
    }
  }
}
  extension FilterViewController: LocationFilterDelegate{
    func locationFiltersSelected(_ selectedRadius: String) {
      print(selectedRadius)
      IBButtonLocation.setTitle("Your current Location, Radius " + selectedRadius + " miles", for: .normal)
    }
  }


//MARK: -  UIButton extension

extension UIButton{
  func setBorderColor(_ color: UIColor, textColor: UIColor){
    self.layer.borderWidth = 1.0
    self.layer.borderColor = color.cgColor
    self.setTitleColor(textColor, for: .normal)
  }
}
