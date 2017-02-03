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
  case location
  case quantity
  case unknown
}

class SortModePopupView: UIView, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var IBPopupTitle: UILabel!
  @IBOutlet weak var IBTableList: UITableView!
  var delegate:SortModePopupViewDelegate?
  var arrSortOption:[String] = []
  var slideUpViewMode: SlideUpView = SlideUpView.sortMode
  var selectedItem: String = ""
  var popupTitle: String = ""
  override func awakeFromNib() {
    updateView()
  }
  
  
  func updateView(){
    if slideUpViewMode == SlideUpView.sortMode{
      IBTableList.register(UINib(nibName: "SortModeCell", bundle: nil), forCellReuseIdentifier: "SortModeCell")
      IBTableList.tableFooterView = UIView()
      arrSortOption = ["Price: High to Low","Price: Low to High","Date: Oldest to Newest","Date: Newest to Oldest"]
    }
    else if slideUpViewMode == SlideUpView.brandSortMode{
      IBTableList.register(UINib(nibName: "SortModeCell", bundle: nil), forCellReuseIdentifier: "SortModeCell")
      IBTableList.tableFooterView = UIView()
      arrSortOption = ["Name: A to Z","Name: Z to A","Date: Oldest to Newest","Date: Newest to Oldest"]
    }
    else if slideUpViewMode == SlideUpView.sizeSelection{
      IBTableList.register(UINib(nibName: "SortModeCell", bundle: nil), forCellReuseIdentifier: "SortModeCell")
      IBTableList.tableFooterView = UIView()
      arrSortOption = ["Small","Medium","Large","X-Large"]
    }
    IBPopupTitle.text = popupTitle
    selectedItem = arrSortOption.first!
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if slideUpViewMode == SlideUpView.sortMode || slideUpViewMode == SlideUpView.brandSortMode || slideUpViewMode == SlideUpView.sizeSelection{
      return arrSortOption.count
    }
    else{
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if slideUpViewMode == SlideUpView.sortMode || slideUpViewMode == SlideUpView.brandSortMode{
      let sortModeCell:SortModeCell = tableView.dequeueReusableCell(withIdentifier: "SortModeCell")! as! SortModeCell
      sortModeCell.cellLabel?.text = arrSortOption[indexPath.row]
      
      return sortModeCell

    }
    else if slideUpViewMode == SlideUpView.sizeSelection{
      let sortModeCell:SortModeCell = tableView.dequeueReusableCell(withIdentifier: "SortModeCell")! as! SortModeCell
      sortModeCell.cellLabel?.text = arrSortOption[indexPath.row]
      sortModeCell.cellLabel.textAlignment = .center
      return sortModeCell
    }
    else{
      return UITableViewCell()
    }
}
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if slideUpViewMode == SlideUpView.sortMode || slideUpViewMode == SlideUpView.brandSortMode || slideUpViewMode == SlideUpView.sizeSelection{
      let selectedCell:SortModeCell = tableView.cellForRow(at: indexPath as IndexPath)! as! SortModeCell
      selectedCell.contentView.backgroundColor = UIColor.white
      selectedCell.cellLabel.textColor = MEDIUM_GRAY_TEXT_COLOR
      selectedItem = arrSortOption[indexPath.row]
    }
  }
  
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if slideUpViewMode == SlideUpView.sortMode || slideUpViewMode == SlideUpView.brandSortMode || slideUpViewMode == SlideUpView.sizeSelection{
      let unSelectedCell:SortModeCell = tableView.cellForRow(at: indexPath as IndexPath)! as! SortModeCell
      unSelectedCell.contentView.backgroundColor = UIColor.white
      unSelectedCell.cellLabel.textColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
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
