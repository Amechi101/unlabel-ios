//
//  InfluencerStatsVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 14/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class InfluencerStatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var IBTableViewStats: UITableView!
  @IBOutlet weak var IBButtonSortMode: UIButton!
  var sortMode: String = "NEW"
  var sortModeValue: String = "Newest to Oldest"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBTableViewStats.tableFooterView = UIView()
    IBTableViewStats.register(UINib(nibName: "ViewStatsCell", bundle: nil), forCellReuseIdentifier: "ViewStatsCell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func IBActionSortSelection(_ sender: Any) {
    self.addSortPopupView(SlideUpView.statSort,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let statCell: ViewStatsCell = tableView.dequeueReusableCell(withIdentifier: "ViewStatsCell")! as! ViewStatsCell
    if indexPath.row == 0 {
      statCell.IBLabelStats?.text = "TOTAL PRODUCT COMMISSIONS: $900"
    }
    else if indexPath.row == 1 {
      statCell.IBLabelStats?.text = "TOTAL PRODUCT LIKES: 200"
    }
    else if indexPath.row == 2 {
      statCell.IBLabelStats?.text = "TOTAL PRODUCT PURCHASES: 200"
    }
    
    return statCell
  }

}

//MARK: Sort Popup methods

extension InfluencerStatsVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SORT BY"
      viewSortPopup.alpha = 0
      APP_DELEGATE.window?.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
      self.tabBarController?.tabBar.isUserInteractionEnabled = false
      self.tabBarController?.tabBar.isHidden = true
      
    }
  }
  func popupDidClickCloseButton(){
    self.tabBarController?.tabBar.isUserInteractionEnabled = true
    self.tabBarController?.tabBar.isHidden = false
  }
  func popupDidClickDone(_ sortMode: String){
    self.tabBarController?.tabBar.isUserInteractionEnabled = true
    self.tabBarController?.tabBar.isHidden = false
    print(sortMode)
    sortModeValue = sortMode
    IBButtonSortMode.setTitle("Sort By: "+sortModeValue, for: .normal)
    switch sortMode {
    case "Today":
      self.sortMode = "Today"
      break
    case "Last 7 days":
      self.sortMode = "L7"
      break
    case "Last 30 days":
      self.sortMode = "L30"
      break
    case "Last 90 days":
      self.sortMode = "L90"
      break
    default:
      self.sortMode = ""
      break
    }
  }
}

