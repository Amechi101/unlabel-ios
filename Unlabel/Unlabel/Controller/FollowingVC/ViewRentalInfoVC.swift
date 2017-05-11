//
//  ViewRentalInfoVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 07/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ViewRentalInfoVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBLabelContactNumber: UILabel!
  @IBOutlet weak var IBLabelAddress: UILabel!
  @IBOutlet weak var IBLabelPickUpTimes: UILabel!
  @IBOutlet weak var IBLabelZip: UILabel!
  @IBOutlet weak var IBLabelState: UILabel!
  @IBOutlet weak var IBLabelCountry: UILabel!
  @IBOutlet weak var IBLabelCity: UILabel!
  @IBOutlet weak var IBLabelApt: UILabel!
  var rentalInfo: RentalInfo = RentalInfo()
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBLabelContactNumber.text = rentalInfo.ContactNumber
    IBLabelAddress.text = rentalInfo.Address
    IBLabelZip.text = rentalInfo.ZipCode
    IBLabelState.text = rentalInfo.State
    IBLabelCountry.text = rentalInfo.Country
    IBLabelCity.text = rentalInfo.City
    IBLabelApt.text = rentalInfo.AptUnit
    IBLabelPickUpTimes.text = rentalInfo.PickUpTime.joined(separator: "\n")
    
    let days = findDays(indices: rentalInfo.weekIndices)
    print(days)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func findDays(indices: [Int]) -> [String]{
    var finalDays : [String] = [String]()
    var dates : [Date] = []
    var matchingComponents = DateComponents()
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE,MMM dd, yyyy"
    let nextDayToFind: Date = Date()
    for index in indices{
      matchingComponents.weekday = index
      let nextDay = calendar.nextDate(after: nextDayToFind, matching: matchingComponents, matchingPolicy:.nextTime)!
      dates.append(nextDay)
      dates.append(Calendar.current.date(byAdding: .day, value: 7, to: nextDay)!)
      dates.sort(by: {$0.compare($1) == .orderedAscending})
    }
    for date in dates {
      let dateString = formatter.string(from: date)
      finalDays.append(dateString)
    }
    
    return finalDays
  }

  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionBack(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
