//
//  PhysicalAttributesVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 20/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PhysicalAttributes{
  case sex
  case height
  case waist
  case chestOrBust
  case hip
}

class PhysicalAttributesVC: UIViewController {
  @IBOutlet weak var IBButtonSex: UIButton!
  @IBOutlet weak var IBButtonHeight: UIButton!
  @IBOutlet weak var IBLabelChestBust: UILabel!
  @IBOutlet weak var IBButtonChestBust: UIButton!
  @IBOutlet weak var IBButtonHips: UIButton!
  @IBOutlet weak var IBButtonWaist: UIButton!
  
  var attributeType: PhysicalAttributes = .height
  var attributeList: [UnlabelStaticList] = [UnlabelStaticList]()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getInfluencerPhysicalAttributes()
    
  //  self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    // Do any additional setup after loading the view.
  }
  
  func getInfluencerPhysicalAttributes() {
    UnlabelAPIHelper.sharedInstance.getPhysicalAttributes( self, success:{ (
      meta: JSON) in
      print(meta)
    }, failed: { (error) in
    })
    
  }
  
  @IBAction func IBActionSelectOption(_ sender: Any) {
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func getPhysicalAttributesList(){
    if attributeType == PhysicalAttributes.sex{
      attributeList = UnlabelHelper.getGenderType()
    }
    else if attributeType == PhysicalAttributes.height{
      attributeList = UnlabelHelper.getHeightList()
    }
    else{
      attributeList = UnlabelHelper.getOtherPhysicalAttributes()
    }
  }
  
}


//MARK: Sort Popup methods

extension PhysicalAttributesVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "STATE"
      getPhysicalAttributesList()
      viewSortPopup.arrDatasource = attributeList
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
  }
}
