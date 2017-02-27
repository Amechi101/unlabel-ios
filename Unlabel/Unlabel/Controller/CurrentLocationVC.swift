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
  @IBOutlet weak var IBButtonSelectCountry: UIButton!
  var sortMode: String = "NEW"
  var sortModeValue: String = "Newest to Oldest"
  var slideUpMenu: SlideUpView = .country
    override func viewDidLoad() {
        super.viewDidLoad()

        getInfluencerLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getInfluencerLocation() {
        UnlabelAPIHelper.sharedInstance.getInfluencerLocation( self, success:{ (
            meta: JSON) in
            print(meta)
            print(meta["city"].stringValue)
            let stateDict = meta["state"].dictionaryObject
            let state: String = stateDict?["name"] as! String
            self.IBButtonSelectCity.setTitle(meta["city"].stringValue, for: .normal)
            self.IBButtonSelectCountry.setTitle(meta["country"].stringValue, for: .normal)
            self.IBButtonSelectState.setTitle(state, for: .normal)
        }, failed: { (error) in
        })
        
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
      IBButtonSelectCountry.setTitle(sortModeValue, for: .normal)
    }
    else if slideUpMenu == SlideUpView.state{
      IBButtonSelectState.setTitle(sortModeValue, for: .normal)
    }
  }
}
