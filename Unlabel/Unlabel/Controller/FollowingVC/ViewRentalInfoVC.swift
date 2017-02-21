//
//  ViewRentalInfoVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 07/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ViewRentalInfoVC: UIViewController {
  @IBOutlet weak var IBLabelContactNumber: UILabel!
  @IBOutlet weak var IBLabelAddress: UILabel!

  @IBOutlet weak var IBLabelPickUpTimes: UILabel!
  @IBOutlet weak var IBLabelZip: UILabel!
  @IBOutlet weak var IBLabelState: UILabel!
  @IBOutlet weak var IBLabelCountry: UILabel!
  @IBOutlet weak var IBLabelCity: UILabel!
  @IBOutlet weak var IBLabelApt: UILabel!
  
  var rentalInfo: RentalInfo = RentalInfo()
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  @IBAction func IBActionBack(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
