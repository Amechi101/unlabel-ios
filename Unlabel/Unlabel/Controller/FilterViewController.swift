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

class FilterViewController: UIViewController {
  
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
  
  //    private var selectedCategoryIndexRow:Int = 0
  fileprivate var selectedLocation:String?
  
  fileprivate let arrFilterTitles:[String] = ["LABEL CATEGORY", "STYLE", "LOCATION"]
  var shouldClearCategories = false

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

  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    //    UnlabelAPIHelper.sharedInstance.getBrandStoreType({ (arrCountry:[FilterModel], meta: JSON) in
    //      print(meta)
    //    }, failed: { (error) in
    //    })
    //
    print(sender.tag)
    sender.isSelected = !sender.isSelected
    print(sender.isSelected)
    if !sender.isSelected{
      sender.setBorderColor(EXTRA_LIGHT_GRAY_TEXT_COLOR,textColor: EXTRA_LIGHT_GRAY_TEXT_COLOR)
    }
    else{
      sender.setBorderColor(LIGHT_GRAY_BORDER_COLOR,textColor: MEDIUM_GRAY_TEXT_COLOR)
    }
  }
  @IBAction func IBActionCategory(_ sender: Any) {
    let _presentController = self.storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .category
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)
    
    
  }
  
  @IBAction func IBActionStyle(_ sender: Any) {
    
    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .style
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)
    
  }
  @IBAction func IBActionLocation(_ sender: Any) {
    UnlabelAPIHelper.sharedInstance.getBrandLocation({ (arrCountry:[UnlabelStaticList], meta: JSON) in
      print(meta)
    }, failed: { (error) in
    })
    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .style
    _presentController.arSelectedValues = []
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)
  }
  @IBAction func IBActionShowFilteredResults(_ sender: Any) {
    let feedVC = storyboard?.instantiateViewController(withIdentifier: S_ID_FEED_VC) as? FeedVC
    feedVC?.hidesBottomBarWhenPushed = true
    feedVC?.mainVCType = .filter
    feedVC?.filteredNavTitle = "Menswear"
    feedVC?.searchText = "a cheng"
    navigationController?.pushViewController(feedVC!, animated: true)
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
    }
    
    print(arSelectedCategory)
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
