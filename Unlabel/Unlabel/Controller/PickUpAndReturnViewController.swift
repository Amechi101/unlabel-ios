//
//  PickUpAndReturnViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 15/05/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

@objc protocol PickAndReturnViewDelegate {
  @objc optional func pickUpAndreturn(_ pickDate: String, _ returnDate: String,_ pickTime: String, _ returnTime: String)
}

enum RentalTimings {
  case pickupDate
  case returnDate
  case pickupTime
  case returnTime
  case unknown
}

class PickUpAndReturnViewController: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  @IBOutlet weak var IBLabelTodaysDate: UILabel!
  var rentalInfo: RentalInfo = RentalInfo()
  var rentalTime: RentTime = RentTime()
  var delegate:PickAndReturnViewDelegate?
  var rentalTiming: RentalTimings = .returnDate
  var attributeList: [UnlabelStaticList] = [UnlabelStaticList]()
  var attributeTitle: String = ""
  var pickUpTimes : [UnlabelStaticList] = [UnlabelStaticList]()
  var returnTimes : [UnlabelStaticList] = [UnlabelStaticList]()
  let dFormatter = DateFormatter()
  var isPickupSelected : Bool = false
  var isReurnSelected : Bool = false
  @IBOutlet weak var IBButtonPickUpDate: UIButton!
  @IBOutlet weak var IBButtonPickUpTime: UIButton!
  @IBOutlet weak var IBButtonReturnDate: UIButton!
  @IBOutlet weak var IBButtonReturnTime: UIButton!
  
  //MARK: -  View lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    print("info: \(rentalInfo.City)")
    IBLabelTodaysDate.text = "Today's Date: " + UnlabelHelper.getFormattedTodaysDate()
    // findTimes(startTime: "12:00 AM", endTime: "05:00 PM")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  Custom methods
  func getTimingMode() {
    if rentalTiming == RentalTimings.pickupDate {
      attributeList = UnlabelHelper.getPickUpDays(indices: rentalInfo.weekIndices)
    } else if rentalTiming == RentalTimings.returnDate {
      attributeList = UnlabelHelper.getReturnDays(indices: rentalInfo.weekIndices,starDate: (IBButtonPickUpDate.titleLabel?.text)!)
    } else if rentalTiming == RentalTimings.pickupTime {
      attributeList = pickUpTimes
    } else if rentalTiming == RentalTimings.returnTime {
      attributeList = returnTimes
    }
  }
  
  func findTimes(startTime:String,endTime:String){
    dFormatter.timeZone = TimeZone.current
    dFormatter.dateFormat = "yyyy-MM-dd"
    let starTimeString = dFormatter.string(from: Date()) + " " + startTime
    let endTimeString = dFormatter.string(from: Date()) + " " + endTime
    dFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
    let startDate: Date = dFormatter.date(from: starTimeString)!
    let endDate: Date = dFormatter.date(from: endTimeString)!
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .minute, value: 30, to: startDate)
    dFormatter.dateFormat = "hh:mm a"
    let pTime = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
    pTime.uId = dFormatter.string(from: date!)
    pTime.uName = dFormatter.string(from: date!)
    pickUpTimes.append(pTime)
    returnTimes.append(pTime)
    print(dFormatter.string(from: date!))
    let dateComparisionResult: ComparisonResult = date!.compare(endDate)
    if dateComparisionResult == ComparisonResult.orderedAscending {
      findTimes(startTime: dFormatter.string(from: date!), endTime: dFormatter.string(from: endDate))
    } else {
      return
    }
  }
  
  func selectPickUptime(_ selectedItem: UnlabelStaticList) -> RentTime {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE,MMM dd, yyyy"
    let date = dateFormatter.date(from: selectedItem.uName)
    dateFormatter.dateFormat = "EEEE"
    let dateString = dateFormatter.string(from: date!)
    
    for rentTime in rentalInfo.rentTime {

      if rentTime.day == dateString {
        return rentTime
      }
    }
    return RentTime()
  }
   func setStartDateTime(_ startDateString: String) {
    
    dFormatter.timeZone = TimeZone.current
    dFormatter.dateFormat = "yyyy-MM-dd"
    let starTimeString = dFormatter.string(from: Date()) + " " + startDateString
    dFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
    let startDate: Date = dFormatter.date(from: starTimeString)!
    dFormatter.dateFormat = "hh:mm a"
    let pTime = UnlabelStaticList(uId: "", uName: "",uCode:"",isSelected:false)
    pTime.uId = dFormatter.string(from: startDate)
    pTime.uName = dFormatter.string(from: startDate)
    pickUpTimes.append(pTime)
    returnTimes.append(pTime)

  }
  
  //MARK: -  IBAction methods
  @IBAction func IBActionDateTimeSelection(_ sender: UIButton) {
    if sender.tag == 1 {
      rentalTiming = RentalTimings.pickupDate
      attributeTitle = "PICK-UP DATE"
      self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    } else if sender.tag == 2 {
      if isPickupSelected {
      rentalTiming = RentalTimings.pickupTime
      attributeTitle = "PICK-UP TIME"
      self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
    } else if sender.tag == 3 {
      if isPickupSelected {
        rentalTiming = RentalTimings.returnDate
        attributeTitle = "RETURN DATE"
        self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
    } else if sender.tag == 4 {
      if isReurnSelected {
        rentalTiming = RentalTimings.returnTime
        attributeTitle = "RETURN TIME"
        self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
    }
  }
  
  @IBAction func IBActionApply(_ sender: Any) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE,MMM dd, yyyy"
    let pickUpDate = dateFormatter.date(from: (IBButtonPickUpDate.titleLabel?.text)!)
    let returnDate = dateFormatter.date(from: (IBButtonReturnDate.titleLabel?.text)!)
    dateFormatter.dateFormat = "MM/dd/yy"
    let pickUpString = dateFormatter.string(from: pickUpDate!)
    let returnString = dateFormatter.string(from: returnDate!)
    delegate?.pickUpAndreturn!(pickUpString, returnString,(IBButtonPickUpTime.titleLabel?.text)!,(IBButtonReturnTime.titleLabel?.text)!)
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionCancel(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}

//MARK: -  Size selection popup delegate methods
extension PickUpAndReturnViewController: SortModePopupViewDelegate {
  
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect) {
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView {
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.popupTitle = attributeTitle
      getTimingMode()
      viewSortPopup.arrDatasource = attributeList
      viewSortPopup.frame = initialFrame
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
    //API implementation here
  }
  
    func popupDidClickDone(_ selectedItem: UnlabelStaticList, countryCode: Bool) {
    if rentalTiming == RentalTimings.pickupDate {
      isPickupSelected = true
      IBButtonPickUpDate.setTitle(selectedItem.uName, for: .normal)
      rentalTime = selectPickUptime(selectedItem)
      setStartDateTime(rentalTime.startTime)
      findTimes(startTime: rentalTime.startTime, endTime: rentalTime.endTime)
    } else if rentalTiming == RentalTimings.returnDate {
      isReurnSelected = true
      IBButtonReturnDate.setTitle(selectedItem.uName, for: .normal)
      rentalTime = selectPickUptime(selectedItem)
      setStartDateTime(rentalTime.startTime)
      findTimes(startTime: rentalTime.startTime, endTime: rentalTime.endTime)
    } else if rentalTiming == RentalTimings.pickupTime {
      IBButtonPickUpTime.setTitle(selectedItem.uName, for: .normal)
    }else if rentalTiming == RentalTimings.returnTime {
      IBButtonReturnTime.setTitle(selectedItem.uName, for: .normal)
    }
  }
}


