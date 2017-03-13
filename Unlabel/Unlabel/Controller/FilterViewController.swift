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
    case .location: return "Select Location"
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

protocol FilterViewDelegate{
  func willCloseChildVC(_ childVCName:String)
  func didClickShowLabels(_ category:String?,location:String?, style:String?)
  
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
  
  //    private var selectedCategoryIndexRow:Int = 0
  fileprivate var selectedLocation:String?
  
  fileprivate let arrFilterTitles:[String] = ["LABEL CATEGORY", "STYLE", "LOCATION"]
  var shouldClearCategories = false

  fileprivate var selectedCategory:String?
  fileprivate var selectedStyle:String?

  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UnlabelAPIHelper.sharedInstance.getBrandStoreType({ (arrCountry:[FilterModel], meta: JSON) in
      //print(meta)
    }, failed: { (error) in
    })
    
    selectedLocation = ""
    selectedCategory = ""
    selectedStyle = ""
    IBButtonMenswear.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
    IBButtonWomenswear.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }
  
  
  //MARK: -  IBAction methods
  
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
    self.arSelectedLocation.removeAll()
    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .location
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)
  }
  @IBAction func IBActionShowFilteredResults(_ sender: Any) {
    let feedVC = storyboard?.instantiateViewController(withIdentifier: S_ID_FEED_VC) as? FeedVC
    feedVC?.hidesBottomBarWhenPushed = true
    feedVC?.mainVCType = .filter
   // feedVC?.filteredNavTitle = "Menswear"
    feedVC?.searchText = self.IBSearchBar.text
    feedVC?.sFilterStyle = self.selectedStyle
    feedVC?.sFilterCategory = self.selectedCategory
    feedVC?.sFilterLocation = self.selectedLocation
    
    if IBButtonMenswear.isSelected && IBButtonWomenswear.isSelected{
        feedVC?.sFilterStoreType = "1,2"
      feedVC?.filteredNavTitle = "UNISEX"
    }
    else if IBButtonWomenswear.isSelected{
        feedVC?.sFilterStoreType = "2"
      feedVC?.filteredNavTitle = "WOMENSWEAR"
    }
    else if IBButtonMenswear.isSelected{
        feedVC?.sFilterStoreType = "1"
      feedVC?.filteredNavTitle = "MENSWEAR"
    }
    else{
        feedVC?.sFilterStoreType = ""
    }
    navigationController?.pushViewController(feedVC!, animated: true)
  }
  
  
  @IBAction func unwindBackToFilterViewController(_ segue: UIStoryboardSegue) {
    if segue.identifier == "backToFilterController" {
      let filterListController = segue.source as! FilterListController
      
      if filterListController.arSelectedValues.count > 0 {
        let filteredValues = filterListController.arSelectedValues
        for filteredObject in filteredValues{
            print(filteredObject.typeId)
            if filterListController.categoryStyleType == CategoryStyleEnum.category {
                self.arSelectedCategory.append(filteredObject.typeId)
              let paramsJSON = JSON(self.arSelectedCategory)
              self.selectedCategory = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions(rawValue: 0))
           //   let paramsString = paramsJSON.rawString(encoding: NSUTF8StringEncoding, options: nil)
            //    self.selectedCategory = self.arSelectedCategory.joined(separator: ",")
                self.IBButtonBrandCategory.setTitle("\(self.arSelectedCategory.count)" + " Categorie(s)", for: .normal)
            }
            else if filterListController.categoryStyleType == CategoryStyleEnum.style {
                self.arSelectedStyle.append(filteredObject.typeId)
                self.selectedStyle = self.arSelectedStyle.joined(separator: ",")
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
        //    print(filterListController.arSelectedValues)
    }
//    

  }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //searchActive = false;
        self.IBSearchBar.endEditing(true)
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
