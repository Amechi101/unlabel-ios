//
//  EditProfileVC.swift
//  Unlabel
//
//  Created by Ravisankar V on 19/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SwiftyJSON

class EditProfileVC: UIViewController {
  @IBOutlet weak var IBTextfieldFullname: UITextField!
  @IBOutlet weak var IBLabelFullname: UILabel!
  @IBOutlet weak var IBViewfullname: UIView!
  
  @IBOutlet weak var IBLabelLastname: UILabel!
  @IBOutlet weak var IBtextfieldLastname: UITextField!
  @IBOutlet weak var IBViewLastname: UIView!
  
  @IBOutlet weak var IBLabelEmail: UILabel!
  @IBOutlet weak var IBtextfieldEmail: UITextField!
  @IBOutlet weak var IBViewEmail: UIView!
  
  @IBOutlet weak var IBTextfieldContactNumber: UITextField!
  @IBOutlet weak var IBTextfieldUsername: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getInfluencerProfileInfo()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    saveInfluencerProfileInfo()
  //  _ = self.navigationController?.popViewController(animated: true)
  }
  
  func getInfluencerProfileInfo() {
    UnlabelAPIHelper.sharedInstance.getProfileInfo( self, success:{ (
      meta: JSON) in
      print(meta)
    }, failed: { (error) in
    })
    
  }
  func saveInfluencerProfileInfo() {
    let userParam = User()
    userParam.firstname = IBTextfieldFullname.text!
    userParam.lastname = IBtextfieldLastname.text!
    userParam.email = IBtextfieldEmail.text!
    userParam.contactNumber = IBTextfieldContactNumber.text!
    UnlabelAPIHelper.sharedInstance.saveProfileInfo( userParam,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      _ = self.navigationController?.popViewController(animated: true)
    }, failed: { (error) in
    })
    
  }
}
