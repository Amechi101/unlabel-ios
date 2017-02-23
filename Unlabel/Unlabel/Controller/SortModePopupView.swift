//
//  SortModePopupView.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

@objc protocol SortModePopupViewDelegate {
  func popupDidClickCloseButton()
  func popupDidClickDone(_ sortMode: String)
}

enum SlideUpView{
  case sortMode
  case brandSortMode
  case sizeSelection
  case country
  case state
  case quantity
  case statSort
  case unknown
}

class SortModePopupView: UIView, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var IBPopupTitle: UILabel!
  @IBOutlet weak var IBTableList: UITableView!
  var delegate:SortModePopupViewDelegate?
  var arrSortOption:[String] = []
  var arrDatasource:[UnlabelStaticList] = []
  var slideUpViewMode: SlideUpView = SlideUpView.sortMode
  var selectedItem: String = ""
  var popupTitle: String = ""
  
  
  override func awakeFromNib() {
    updateView()
  }
  
  
  func updateView(){
    
    IBTableList.tableFooterView = UIView()
    
    IBTableList.register(UINib(nibName: "SortModeCell", bundle: nil), forCellReuseIdentifier: "SortModeCell")
    if slideUpViewMode == SlideUpView.sortMode{
      arrSortOption = ["High to Low","Low to High","Oldest to Newest","Newest to Oldest"]
    }
    else if slideUpViewMode == SlideUpView.brandSortMode{
      arrSortOption = ["A to Z","Z to A","Oldest to Newest","Newest to Oldest"]
    }
    else if slideUpViewMode == SlideUpView.sizeSelection{
      arrSortOption = ["Small","Medium","Large","X-Large"]
    }
    else if slideUpViewMode == SlideUpView.statSort{
      arrSortOption = ["Today","Last 7 days","Last 30 days","Last 90 days"]
    }
    else if slideUpViewMode == SlideUpView.state{
      arrDatasource = getStateList()
      
      //["Alaska","Alabama","Arkansas","American Samoa","Arizona","California","Colorado","Connecticut","District of Columbia","Delaware","Florida","Georgia","Guam","Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky","Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota","Missouri","Northern Mariana Islands","Mississippi","Montana","National","North Carolina","North Dakota","Nebraska","New Hampshire","New Jersey","New Mexico","Nevada","New York","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Virginia","Virgin Islands","Vermont","Washington","Wisconsin","West Virginia","Wyoming"]
    }
    else if slideUpViewMode == SlideUpView.country{
      arrSortOption = ["USA","International"]
    }
    else{
      // arrSortOption = []
    }
    IBPopupTitle.text = popupTitle
    selectedItem = arrSortOption.first!
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrDatasource.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sortModeCell:SortModeCell = (tableView.dequeueReusableCell(withIdentifier: "SortModeCell")! as? SortModeCell)!
    let listObect : UnlabelStaticList = arrDatasource[indexPath.row]
    sortModeCell.cellLabel?.text = listObect.uName
    if listObect.isSelected{
      sortModeCell.cellLabel.textColor = MEDIUM_GRAY_TEXT_COLOR
    }else{
      sortModeCell.cellLabel.textColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
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
        selectedItem = listObect.uId
        listObect.isSelected = true
      }
     
    }
  }
  
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    print(indexPath)
    if let unSelectedCell:SortModeCell = tableView.cellForRow(at: indexPath as IndexPath)! as? SortModeCell{
      let listObect : UnlabelStaticList = arrDatasource[indexPath.row]
      if listObect.isSelected{
        unSelectedCell.contentView.backgroundColor = UIColor.white
        unSelectedCell.cellLabel.textColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
        listObect.isSelected = false
      }else{
      }
      
      
    }
  }
  
  fileprivate func close(){
    UIView.animate(withDuration: 0.2, animations: {
      self.frame.origin.y = SCREEN_HEIGHT
    }, completion: { (value:Bool) in
      self.removeFromSuperview()
    })
  }
  
  @IBAction func IBActionClickOutside(_ sender: Any) {
    close()
    delegate?.popupDidClickCloseButton()
  }
  @IBAction func IBActionDone(_ sender: Any) {
    close()
    delegate?.popupDidClickDone(selectedItem)
  }
  @IBAction func IBActionClose(_ sender: Any) {
    close()
    delegate?.popupDidClickCloseButton()
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
}
