//
//  PickUpAndReturnViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 15/05/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

enum RentalTimings {
  
  case pickupDate
  case returnDate
  case pickupTime
  case returnTime
  case unknown
}
class PickUpAndReturnViewController: UIViewController {
  
  @IBOutlet weak var IBLabelTodaysDate: UILabel!
  var rentalTiming: RentalTimings = .returnDate
  var attributeList: [UnlabelStaticList] = [UnlabelStaticList]()
  var attributeTitle: String = ""
  var times : [UnlabelStaticList] = [UnlabelStaticList]()
  let dFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

      dFormatter.timeZone = TimeZone.current
      dFormatter.dateFormat = "yyyy-MM-dd"
      let starTimeString = dFormatter.string(from: Date()) + " 12:00 AM"
      dFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
      let startDate: Date = dFormatter.date(from: starTimeString)!
      dFormatter.dateFormat = "hh:mm a"
      let pTime = UnlabelStaticList(uId: "", uName: "",isSelected:false)
      pTime.uId = dFormatter.string(from: startDate)
      pTime.uName = dFormatter.string(from: startDate)
      times.append(pTime)
      
      IBLabelTodaysDate.text = "Today's Date: " + UnlabelHelper.getFormattedTodaysDate()
      findTimes(startTime: "12:00 AM", endTime: "05:00 PM")
      
      self.addSortPopupView(SlideUpView.unknown,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func getTimingMode() {
    if rentalTiming == RentalTimings.pickupDate {
      attributeList = UnlabelHelper.getPickUpDays(indices: [1,2,4])
    } else if rentalTiming == RentalTimings.returnDate {
      attributeList = UnlabelHelper.getReturnDays(indices: [1,2,4])
    } else if rentalTiming == RentalTimings.pickupTime {
      attributeList = times
    }else if rentalTiming == RentalTimings.returnTime {
      attributeList = times
    }else {
      
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
    let pTime = UnlabelStaticList(uId: "", uName: "",isSelected:false)
    pTime.uId = dFormatter.string(from: date!)
    pTime.uName = dFormatter.string(from: date!)
    times.append(pTime)
    print(dFormatter.string(from: date!))
    let dateComparisionResult: ComparisonResult = date!.compare(endDate)
    if dateComparisionResult == ComparisonResult.orderedAscending {
      findTimes(startTime: dFormatter.string(from: date!), endTime: dFormatter.string(from: endDate))
    } else {
      return
    }
  }
  

}
//MARK: -  Size selection popup delegate methods

extension PickUpAndReturnViewController: SortModePopupViewDelegate {
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect) {
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView {
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.popupTitle = attributeTitle
      viewSortPopup.popupTitle = "PICK-UP DATE"
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
    //delegate method to be implemented after API integration
  }
  
  func popupDidClickDone(_ selectedItem: UnlabelStaticList) {
  }
}
