//
//  PickLocationVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/03/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol PickLocationDelegate {
  func locationDidSelected(_ selectedItem: FilterModel)
}

class PickLocationVC: UIViewController {
  
  @IBOutlet weak var IBTableViewLocation: UITableView!
  @IBOutlet weak var IBButtonApply: UIButton!
  @IBOutlet weak var IBButtonTitle: UIButton!
  var arFilterMenu:[FilterModel] = []
  var arOriginalJSON:[JSON]!
  var arSelectedValues:[FilterModel] = []
  var arSelectedID:[String] = []
  var delegate:PickLocationDelegate?
  var selectedItem = FilterModel()
  var dictSelection:[Int: Bool] = [0:false]
  var categoryStyleType:CategoryStyleEnum!
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonApply.isHidden = true
    IBTableViewLocation.tableFooterView = UIView()
    setUp()
    if categoryStyleType == CategoryStyleEnum.location{
      IBButtonTitle.setTitle("CURRENT LOCATION", for: UIControlState())
      WSGetAllFilterList(ByCategoryType: CategoryStyleEnum.location)
    }
    else if categoryStyleType == CategoryStyleEnum.radius{
      IBButtonTitle.setTitle("LOCATION RADIUS", for: UIControlState())
      getRadiusValues()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func IBActionDismissView(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func IBActionApply(_ sender: Any) {
    saveInfluencerLocation()
  }
  
  func getRadiusValues(){
    arFilterMenu = UnlabelHelper.getRadius()
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
        self.IBTableViewLocation.reloadData()
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
      self.IBTableViewLocation.reloadData()
    }

  }
  
  func saveInfluencerLocation() {
    let params: [String: String] = ["location_id":self.selectedItem.typeId]
    UnlabelAPIHelper.sharedInstance.saveInfluencerLocation(params ,onVC: self, success:{ (
      meta: JSON) in
      self.delegate?.locationDidSelected(self.selectedItem)
      self.dismiss(animated: true, completion: nil)
    }, failed: { (error) in
    })
  }
  fileprivate func setUp() {
    self.IBTableViewLocation.removeMargines()
    self.IBTableViewLocation.separatorColor =  LIGHT_GRAY_TEXT_COLOR.withAlphaComponent(0.5)
    IBTableViewLocation.dataSource = self
    IBTableViewLocation.delegate = self
    IBTableViewLocation.allowsMultipleSelection = false
    IBTableViewLocation.register(UINib(nibName: "FilterListCell", bundle: nil), forCellReuseIdentifier: "FilterListCell")
  }
  fileprivate func WSGetAllFilterList(ByCategoryType type:CategoryStyleEnum) {
    UnlabelLoadingView.sharedInstance.start(self.view)
    UnlabelAPIHelper.sharedInstance.getLocationList(categoryStyle: CategoryStyleEnum.location,{ (arrCountry:[FilterModel], meta: JSON,arrSpecial) in
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
          self.IBTableViewLocation.reloadData()
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
        self.IBTableViewLocation.reloadData()
      }
    }, failed: { (error) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      debugPrint(error)
      UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
    })
  }
}
extension PickLocationVC: UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return arFilterMenu.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterListCell") as! FilterListCell
    let _selection = self.dictSelection[indexPath.row]!
    cell.configureCell(indexPath, selection: _selection)
    cell.IBimgViewCheckMark.isHidden = !_selection
    cell.IBlblFilterListName.textColor = MEDIUM_GRAY_TEXT_COLOR
    cell.IBlblFilterListName?.text = self.arFilterMenu[indexPath.row].typeName
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    IBButtonApply.isHidden = false
      arSelectedValues.removeAll()
      self.dictSelection[indexPath.row] = !self.dictSelection[indexPath.row]!
    print(self.dictSelection[indexPath.row]!)
      let indexes = self.dictSelection.filter {$0.1 == true}.map { return $0.0 }
      print(indexes)
      for index in indexes {
        if index != indexPath.row{
          dictSelection[index] = false
        }
        else{
          self.selectedItem = arFilterMenu[index]
          arSelectedValues.append(arFilterMenu[index])
        }
      }
    if arSelectedValues.count > 0{
      IBButtonApply.isHidden = false
    }
    else{
      IBButtonApply.isHidden = true
    }
    IBTableViewLocation.reloadData()
  }


}
