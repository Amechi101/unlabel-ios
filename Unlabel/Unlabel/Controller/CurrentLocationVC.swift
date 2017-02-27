//
//  CurrentLocationVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

class CurrentLocationVC: UIViewController {
  
  @IBOutlet weak var IBButtonSelectCity: UIButton!
  @IBOutlet weak var IBButtonSelectState: UIButton!
  @IBOutlet weak var IBViewStateContainer: UIView!
  @IBOutlet weak var IBButtonSelectCountry: UIButton!
  var sortMode: String = "NEW"
  var sortModeValue: String = "Newest to Oldest"
  var slideUpMenu: SlideUpView = .country
  var stateID: String = "1"
  var countryID: String = "US"
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getInfluencerLocation()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func saveInfluencerLocation() {
    let params: [String: String] = ["city":(self.IBButtonSelectCity.titleLabel?.text)!,"state":stateID,"country":countryID]
    UnlabelAPIHelper.sharedInstance.saveInfluencerLocation(params ,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      }, failed: { (error) in
    })
  }
  
  
  func getInfluencerLocation() {
    UnlabelAPIHelper.sharedInstance.getInfluencerLocation( self, success:{ (
      meta: JSON) in
      print(meta)
      let stateDict = meta["state"].dictionaryObject
      let state: String = stateDict?["name"] as! String
      self.stateID = "\(stateDict?["pk"] as! NSNumber)"
      let countryDict = meta["country"].dictionaryObject
      let country: String = countryDict?["printable_name"] as! String
      self.countryID = countryDict?["pk"] as! String
      
      if self.countryID != "US"{
        self.IBButtonSelectState.isEnabled = false
        self.IBButtonSelectState.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBViewStateContainer.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      }
      
      self.IBButtonSelectCity.setTitle(meta["city"].stringValue, for: .normal)
      self.IBButtonSelectCountry.setTitle(country, for: .normal)
      self.IBButtonSelectState.setTitle(state, for: .normal)
    }, failed: { (error) in
    })
  }
  @IBAction func IBActionUpdate(_ sender: Any) {
    saveInfluencerLocation()
  }
  @IBAction func IBActionSelectCountry(_ sender: Any) {
    slideUpMenu = SlideUpView.country
    self.addSortPopupView(SlideUpView.country,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionSelectState(_ sender: Any) {
    slideUpMenu = SlideUpView.state
    self.addSortPopupView(SlideUpView.state,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EnterCurrentCity"{
      if let enterCityVC:EnterCityVC = segue.destination as? EnterCityVC{
        enterCityVC.delegate = self
        enterCityVC.currentCity = (self.IBButtonSelectCity.titleLabel?.text)!
      }
    }
  }
}
extension CurrentLocationVC: EnterCityVCDelegate{
  func popupDidClickUpdate(_ selectedCity: String){
    print(selectedCity)
    self.IBButtonSelectCity.setTitle(selectedCity, for: .normal)
  }
}

//MARK: Sort Popup methods

extension CurrentLocationVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      
      if slideUpMenu == SlideUpView.country{
        viewSortPopup.popupTitle = "SELECT YOUR COUNTRY"
      }
      else if slideUpMenu == SlideUpView.state{
        viewSortPopup.popupTitle = "SELECT YOUR STATE"
      }
      viewSortPopup.alpha = 0
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
    }
  }
  func popupDidClickCloseButton(){
    
  }
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
    //  print(sortMode)
    sortModeValue = selectedItem.uName
    if slideUpMenu == SlideUpView.country{
      countryID = selectedItem.uId
      if self.countryID != "US"{
        self.IBButtonSelectState.isEnabled = false
        self.IBButtonSelectState.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBViewStateContainer.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      }
      else{
        self.IBButtonSelectState.isEnabled = true
        self.IBViewStateContainer.backgroundColor = LIGHT_GRAY_BORDER_COLOR
        self.IBButtonSelectState.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
      }
      IBButtonSelectCountry.setTitle(sortModeValue, for: .normal)
    }
    else if slideUpMenu == SlideUpView.state{
      
      if self.countryID != "US"{
        stateID = selectedItem.uId
      }
      else{
        stateID = ""
      }
      IBButtonSelectState.setTitle(sortModeValue, for: .normal)
    }
  }
}
