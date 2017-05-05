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
  @IBOutlet weak var IBButtonHipsView: UIView!
  @IBOutlet weak var IBButtonWaist: UIButton!
  var attributeType: PhysicalAttributes = .height
  var attributeList: [UnlabelStaticList] = [UnlabelStaticList]()
  var attributeTitle: String = ""
  var sexID: String = ""
  var waistID: String = ""
  var hipID: String = ""
  var heightID: String = ""
  var chestBustID: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getInfluencerPhysicalAttributes()
  }
  
  func saveInfluencerPhysicalAttributes() {
    let params: [String: String] = ["sex":sexID,"height":heightID,"chest_or_bust":chestBustID,"hips":hipID,"waist":waistID]
    UnlabelAPIHelper.sharedInstance.savePhysicalAttributes(params ,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      _ = self.navigationController?.popViewController(animated: true)
    }, failed: { (error) in
    })
  }
  
  func getInfluencerPhysicalAttributes() {
    UnlabelAPIHelper.sharedInstance.getPhysicalAttributes( self, success:{ (
      meta: JSON) in
      print(meta)
      let gender: String = meta["sex"].stringValue
      if gender == "M" {
        self.sexID = "M"
        self.IBButtonHipsView.isHidden = false
        self.IBButtonSex.setTitle("Male", for: .normal)
      } else {
        self.sexID = "F"
        self.IBButtonHipsView.isHidden = true
        self.IBButtonSex.setTitle("Female", for: .normal)
      }
      self.waistID = meta["waist"].stringValue
      self.heightID = meta["height"].stringValue
      self.hipID = meta["hips"].stringValue
      self.chestBustID = meta["chest_or_bust"].stringValue
      self.IBButtonHeight.setTitle(self.heightIntoFts(heightStr: meta["height"].stringValue), for: .normal)
      self.IBButtonChestBust.setTitle(self.stringToInch(inchStr: meta["chest_or_bust"].stringValue), for: .normal)
      self.IBButtonHips.setTitle(self.stringToInch(inchStr: meta["hips"].stringValue), for: .normal)
      self.IBButtonWaist.setTitle(self.stringToInch(inchStr: meta["waist"].stringValue), for: .normal)
    }, failed: { (error) in
    })
  }
  
  @IBAction func IBActionSelectOption(_ sender: UIButton) {
    if sender.tag == 1 {
      attributeType = PhysicalAttributes.sex
      attributeTitle = "GENDER"
    } else if sender.tag == 2 {
      attributeType = PhysicalAttributes.height
      attributeTitle = "HEIGHT"
    } else if sender.tag == 3 {
      attributeType = PhysicalAttributes.chestOrBust
      attributeTitle = "CHEST"
    } else if sender.tag == 4 {
      attributeType = PhysicalAttributes.hip
      attributeTitle = "HIP"
    } else if sender.tag == 5 {
      attributeTitle = "WAIST"
      attributeType = PhysicalAttributes.waist
    }
    self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  
  func heightIntoFts(heightStr: String) -> String {
    var height: String = ""
    if let fHt: Float = Float(heightStr) {
      let iHt: Int = Int(fHt)
      let ft: Int = iHt / 12
      let inch: Int = iHt % 12
      print("\(ft) ft \(inch) inches")
      height = "\(ft) ft \(inch) inches"
    }
    
    return height
  }
  func stringToInch(inchStr: String) -> String {
    var inches: String = ""
    if let fIn: Float = Float(inchStr) {
      let iIn: Int = Int(fIn)
      inches = "\(iIn) inches"
      print("\(iIn) inches")
    }
    
    return inches
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    if sexID.isEmpty || waistID.isEmpty || hipID.isEmpty || heightID.isEmpty || chestBustID.isEmpty {
      UnlabelHelper.showAlert(onVC: self, title: "Missing Value", message: "Please provide value for all fields", onOk: {})
    } else {
      saveInfluencerPhysicalAttributes()
    }
  }
  
  func getPhysicalAttributesList() {
    if attributeType == PhysicalAttributes.sex {
      attributeList = UnlabelHelper.getGenderType()
    } else if attributeType == PhysicalAttributes.height {
      attributeList = UnlabelHelper.getHeightList()
    } else {
      attributeList = UnlabelHelper.getOtherPhysicalAttributes()
    }
  }
}


//MARK: Sort Popup methods

extension PhysicalAttributesVC: SortModePopupViewDelegate {
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect) {
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView {
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = attributeTitle
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
  
  func popupDidClickCloseButton() {
  }
  
  func popupDidClickDone(_ selectedItem: UnlabelStaticList) {
    if attributeType == PhysicalAttributes.sex {
      IBButtonSex.setTitle(selectedItem.uName, for: .normal)
      sexID = selectedItem.uId
      if selectedItem.uId == "M" {
        chestBustID = ""
        IBLabelChestBust.text = "CHEST"
        IBButtonChestBust.setTitle("Select your chest measurement", for: .normal)
        IBButtonHipsView.isHidden = false
      } else {
        chestBustID = ""
        IBLabelChestBust.text = "BUST"
        IBButtonHipsView.isHidden = true
        IBButtonChestBust.setTitle("Select your bust measurement", for: .normal)
      }
    } else if attributeType == PhysicalAttributes.height {
      heightID = selectedItem.uId
      IBButtonHeight.setTitle(selectedItem.uName, for: .normal)
    } else if attributeType == PhysicalAttributes.waist {
      waistID = selectedItem.uId
      IBButtonWaist.setTitle(selectedItem.uName, for: .normal)
    } else if attributeType == PhysicalAttributes.chestOrBust {
      chestBustID = selectedItem.uId
      IBButtonChestBust.setTitle(selectedItem.uName, for: .normal)
    } else if attributeType == PhysicalAttributes.hip {
      hipID = selectedItem.uId
      IBButtonHips.setTitle(selectedItem.uName, for: .normal)
    }
  }
}
