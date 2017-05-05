//
//  FilterListController.swift
//  Unlabel
//
//  Created by jasmin on 03/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire

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

class FilterListController: UIViewController {
  
  @IBOutlet weak var IBlblTitleBar: UIButton!
  @IBOutlet weak var IBtableFilterList: UITableView!
  @IBOutlet weak var IBbtnApply: UIButton!
  
  
  var categoryStyleType:CategoryStyleEnum!
  var arFilterMenu:[FilterModel] = []
  var arOriginalJSON:[JSON]!
  var arSelectedValues:[FilterModel] = []
  var arSelectedID:[String] = []
  var dictSelection:[Int: Bool] = [0:false]
  
  //   MARK:- Life Cycle methods
  
  override func viewDidLoad() {
    self.navigationItem.hidesBackButton = true
    let filterAll = FilterModel()
    filterAll.typeDescription = ""
    filterAll.typeId = ""
    filterAll.typeName = "All"
    arFilterMenu.append(filterAll)
    super.viewDidLoad()
    setUp()
    WSGetAllFilterList(ByCategoryType: categoryStyleType)
    self.automaticallyAdjustsScrollViewInsets = false
    self.IBtableFilterList.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  fileprivate func setUp() {
    self.IBtableFilterList.removeMargines()
    self.IBtableFilterList.separatorColor =  LIGHT_GRAY_TEXT_COLOR.withAlphaComponent(0.5)
    print(categoryStyleType.description)
    IBlblTitleBar.setTitle(categoryStyleType.description, for: .normal)
    IBtableFilterList.dataSource = self
    IBtableFilterList.delegate = self
    IBbtnApply.isHidden = true
    IBtableFilterList.allowsMultipleSelection = true
    IBtableFilterList.register(UINib(nibName: "FilterListCell", bundle: nil), forCellReuseIdentifier: "FilterListCell")
    IBtableFilterList.register(UINib(nibName: "FilterHeaderCell", bundle: nil), forCellReuseIdentifier: "FilterHeaderCell")
  }
  
  fileprivate func registerCell(withID reusableID:String) {
    IBtableFilterList.register(UINib(nibName: reusableID, bundle: nil), forCellReuseIdentifier: reusableID)
  }
  
  fileprivate func WSGetAllFilterList(ByCategoryType type:CategoryStyleEnum) {
    UnlabelLoadingView.sharedInstance.start(self.view)
    UnlabelAPIHelper.sharedInstance.getBrandCategory(categoryStyle: categoryStyleType,{ (arrCountry:[FilterModel], meta: JSON,arrSpecial) in
      self.arFilterMenu += arrCountry
      self.arOriginalJSON = arrSpecial
      for (index, _) in self.arFilterMenu.enumerated() {
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
          for (index, menu) in  self.arFilterMenu.enumerated()  {
            for  value in self.arSelectedValues {
              if value == menu {
                self.dictSelection[index] = true
              }
            }
          }
        }
      }
      DispatchQueue.main.async {
        UnlabelLoadingView.sharedInstance.stop(self.view)
        self.IBbtnApply.isHidden = false
        self.IBtableFilterList.reloadData()
      }
      
    }, failed: { (error) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      debugPrint(error)
      UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
    })
  }
  
  //   MARK:- Action methods
  @IBAction func IBActionBack(_ sender: AnyObject) {
   // self.dismiss(animated: true, completion: nil)
   _ =  self.navigationController?.popViewController(animated: true)
  }
  @IBAction func IBActionUpdate(_ sender: AnyObject) {
    self.addLikeFollowPopupView(FollowType.profileUpdate, initialFrame:  CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
}

// MARK:- TableView Delegates and Datasource

extension FilterListController: UITableViewDelegate , UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arFilterMenu.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterListCell") as! FilterListCell
    let _selection = self.dictSelection[indexPath.row]!
    cell.configureCell(indexPath, selection: _selection)
    cell.IBlblFilterListName?.text = self.arFilterMenu[indexPath.row].typeName
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.row == 0 { // All
      self.dictSelection[0] = !self.dictSelection[0]!
      if self.dictSelection[0]! {
        arSelectedValues.removeAll()
        arSelectedID.removeAll()
        arSelectedValues = Array(arFilterMenu[1..<arFilterMenu.count])
      } else {
        arSelectedValues.removeAll()
      }
      let totalRows = IBtableFilterList.numberOfRows(inSection: 0)
      for row in 1..<totalRows {
        self.dictSelection[row] = self.dictSelection[0]!
      }
      IBlblTitleBar.setTitle(categoryStyleType.description, for: .normal)
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
      IBlblTitleBar.setTitle(categoryStyleType.description + " (\(arSelectedValues.count))", for: .normal)
   }
    IBtableFilterList.reloadData()
    
  }
  
  
  // View section header
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if categoryStyleType == CategoryStyleEnum.location {
      
        return 0
    } else {
      
        return 55
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let _headerView = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCell") as! FilterHeaderCell
    _headerView.delegate = self
    _headerView.FilterHeaderTitle.text = categoryStyleType.glossaryTitle
    
    return _headerView
  }
  
}


extension FilterListController: FilterListDelegates {
  
  func headerCellClicked() {
    let glosryCntrl = storyboard?.instantiateViewController(withIdentifier: "GlossaryController") as! GlossaryController
    glosryCntrl.arGlossaryValues = arOriginalJSON.sorted { $0["name"].stringValue < $1["name"].stringValue }
    glosryCntrl.categoryStyleType = self.categoryStyleType
    self.navigationController?.pushViewController(glosryCntrl, animated: true)
  }
}
//MARK: -  Like/Follow popup delegate methods

extension FilterListController: LikeFollowPopupviewDelegate {
  
  func addLikeFollowPopupView(_ followType:FollowType,initialFrame:CGRect) {
    if let likeFollowPopup:LikeFollowPopup = Bundle.main.loadNibNamed(LIKE_FOLLOW_POPUP, owner: self, options: nil)? [0] as? LikeFollowPopup {
      likeFollowPopup.delegate = self
      likeFollowPopup.followType = followType
      likeFollowPopup.frame = initialFrame
      likeFollowPopup.productStatusMessage = "You have successfully updated your Styles."
      likeFollowPopup.alpha = 0
      APP_DELEGATE.window?.addSubview(likeFollowPopup)
      UIView.animate(withDuration: 0.2, animations: {
        likeFollowPopup.frame = self.view.frame
        likeFollowPopup.frame.origin = CGPoint(x: 0, y: 0)
        likeFollowPopup.alpha = 1
      })
      likeFollowPopup.updateView()
    }
  }
  
  func popupDidClickClosePopup() {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
