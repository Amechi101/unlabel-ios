//
//  SortModePopupView.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

@objc protocol SortModePopupViewDelegate {
  @objc optional func popupDidClickCloseButton()
    @objc optional func popupDidClickDone(_ selectedItem: UnlabelStaticList,  countryCode: Bool)
}

enum SlideUpView{
  case sortMode
  case brandSortMode
  case sizeSelection
  case country
  case state
  case quantity
  case statSort
  case influencerKind
  case countryCode
  case unknown
}

class SortModePopupView: UIView, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var IBPopupTitle: UILabel!
  @IBOutlet weak var IBTableList: UITableView!
  var delegate:SortModePopupViewDelegate?
  var arrSortOption:[String] = []
  var arrSortOptionKey:[String] = []
  var arrDatasource:[UnlabelStaticList] = []
  var arrTeleCodes:[CountryCodes] = []
    
  var slideUpViewMode: SlideUpView = SlideUpView.sortMode
    var selectedItem = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
  var popupTitle: String = ""
  var arrSortOptionDict: [[String:Any]] = [[:]]
  
  override func awakeFromNib() {
    updateView()
    
  }
  
  func updateView(){
    IBTableList.tableFooterView = UIView()
    IBTableList.register(UINib(nibName: "SortModeCell", bundle: nil), forCellReuseIdentifier: "SortModeCell")
    if slideUpViewMode == SlideUpView.sortMode{
      arrSortOptionDict = [["name":"Price: High to Low","key":"HL"],["name":"Price: Low to High","key":"LH"],["name":"Date: Oldest to Newest","key":"OLD"],["name":"Date: Newest to Oldest","key":"NEW"]]
      arrDatasource = getModelList(arrSortOptionDict)
    }
    else if slideUpViewMode == SlideUpView.brandSortMode{
      arrSortOptionDict = [["name":"A to Z","key":"AZ"],["name":"Z to A","key":"ZA"],["name":"Oldest to Newest","key":"OLD"],["name":"Newest to Oldest","key":"NEW"]]
      arrDatasource = getModelList(arrSortOptionDict)
    }
    else if slideUpViewMode == SlideUpView.sizeSelection{
      arrSortOption = ["Small","Medium","Large","X-Large"]
    }
    else if slideUpViewMode == SlideUpView.statSort{
      arrSortOptionDict = [["name":"Today","key":"Today"],["name":"Last 7 days","key":"L7"],["name":"Last 30 days","key":"L30"],["name":"Last 90 days","key":"L90"]]
      arrDatasource = getModelList(arrSortOptionDict)
    }
    else if slideUpViewMode == SlideUpView.state{
      arrDatasource = getStateList()
    }
    else if slideUpViewMode == SlideUpView.country{
      //arrSortOption = ["USA","International"]
      arrDatasource = getCountryList()
    }
    else if slideUpViewMode == SlideUpView.influencerKind{
      arrSortOptionDict = [["name":"Fashion","key":"fashion"],["name":"Photography","key":"photography"],["name":"Business","key":"business"],["name":"Technology","key":"technology"]]
      arrDatasource = getModelList(arrSortOptionDict)
    }
    else if slideUpViewMode == SlideUpView.state{
      arrDatasource = getStateList()
    }
    else if slideUpViewMode == SlideUpView.countryCode {
        
        arrDatasource = getModelListOfCountryCode()
    }
    else{
      // arrSortOption = []
    }
    IBPopupTitle.text = popupTitle
    if arrDatasource.count>0{
      selectedItem = arrDatasource.first!
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrDatasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sortModeCell:SortModeCell = (tableView.dequeueReusableCell(withIdentifier: "SortModeCell")! as? SortModeCell)!
    let listObect : UnlabelStaticList = arrDatasource[indexPath.row]
    print(listObect.uName)
    print(listObect.uId)
    sortModeCell.cellLabel?.text = listObect.uName
    if popupTitle == "SELECT COUNTRY CODE" {
        sortModeCell.cellLabel?.text = listObect.uCode + "   \(listObect.uName)"
    }
    
    if listObect.isSelected{
      sortModeCell.cellLabel.textColor = MEDIUM_GRAY_TEXT_COLOR
    }else{
      sortModeCell.cellLabel.textColor = MEDIUM_GRAY_TEXT_COLOR
    }
    
    return sortModeCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let selectedCell:SortModeCell = tableView.cellForRow(at: indexPath as IndexPath)! as? SortModeCell{
      let listObect : UnlabelStaticList = arrDatasource[indexPath.row]
        
      if listObect.isSelected{
        
      }else{
        selectedCell.contentView.backgroundColor = UIColor.white
        selectedCell.cellLabel.textColor = MEDIUM_GRAY_TEXT_COLOR
        selectedItem = listObect
        // listObect.isSelected = true
      }
        if popupTitle == "SELECT COUNTRY CODE" {
            close()
            delegate?.popupDidClickDone!(selectedItem, countryCode: true)
        } else {
            close()
            delegate?.popupDidClickDone!(selectedItem, countryCode: false)

        }
      
    }
      }
  
  
  //  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
  //    print(indexPath)
  //    if let unSelectedCell:SortModeCell = tableView.cellForRow(at: indexPath as IndexPath)! as? SortModeCell{
  //      let listObect : UnlabelStaticList = arrDatasource[indexPath.row]
  //      if listObect.isSelected{
  //        unSelectedCell.contentView.backgroundColor = UIColor.white
  //        unSelectedCell.cellLabel.textColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
  //        listObect.isSelected = false
  //      }else{
  //      }
  //
  //
  //    }
  //  }
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
      
  @IBAction func IBActionClickOutside(_ sender: Any) {
    close()
    delegate?.popupDidClickCloseButton!()
  }
  @IBAction func IBActionDone(_ sender: Any) {
    close()
 //   delegate?.popupDidClickDone!(selectedItem)
  }
  @IBAction func IBActionClose(_ sender: Any) {
    close()
    delegate?.popupDidClickCloseButton!()
  }
  
}

extension SortModePopupView{
    func getStateList() -> [UnlabelStaticList]{
        if let data = UserDefaults.standard.object(forKey: "stateList") as? NSData {
            let state: [UnlabelStaticList] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [UnlabelStaticList]
            print(state[0].uId)
            return state
        }
        return []
    }
    func getCountryList()-> [UnlabelStaticList]{
        if let data = UserDefaults.standard.object(forKey: "countryList") as? NSData {
            let country: [UnlabelStaticList] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [UnlabelStaticList]
            print(country[0].uId)
            return country
        }
        return []
    }
    
    func getModelList(_ valueList: [[String:Any]]) -> [UnlabelStaticList]{
        var arrSize = [UnlabelStaticList]()
        
        for thisItem in valueList{
            let pSize = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
            pSize.uId = thisItem["key"] as! String
            pSize.uName = thisItem["name"] as! String
            arrSize.append(pSize)
        }
        return arrSize
    }
    func getModelListOfCountryCode() -> [UnlabelStaticList] {
        // let sortedDict = valueList.sorted{ $0.key < $1.key }
        if let codes =  UnlabelSingleton.sharedInstance.telePhoneCodes {
            print("state\(codes[0].uCode)")
            return codes
        }
        return []
    }
}
