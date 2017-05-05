//
//  LocationFilterVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 30/03/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

@objc protocol LocationFilterDelegate {
  func locationFiltersSelected(_ selectedRadius: String)
}

class LocationFilterVC: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var IBViewGPS: UIView!
  @IBOutlet weak var IBButtonGPS: UIButton!
  @IBOutlet weak var IBImageViewGPS: UIImageView!
  @IBOutlet weak var IBViewLoc: UIView!
  @IBOutlet weak var IBButtonLoc: UIButton!
  @IBOutlet weak var IBButtonRadius: UIButton!
  @IBOutlet weak var IBImageViewLoc: UIImageView!
  var delegate:LocationFilterDelegate?
  let locationManager = CLLocationManager()
  var radius: String = "10"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonLoc.isSelected = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func isAuthorizedtoGetUserLocation() {
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Did location updates is called")
    let currentLoc: CLLocation = locations.first!
    UnlabelHelper.setDefaultValue("\(currentLoc.coordinate.latitude)", key: "latitude")
    UnlabelHelper.setDefaultValue("\(currentLoc.coordinate.longitude)", key: "longitude")
    UnlabelLoadingView.sharedInstance.stop(self.view)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    UnlabelLoadingView.sharedInstance.stop(self.view)
    print("Did location updates is called but failed getting location \(error)")
  }
  
  func getInfluencerLocation() {
    UnlabelAPIHelper.sharedInstance.getInfluencerLocation( success:{ (
      meta: JSON) in
      print(meta)
      print(meta["id"].stringValue)
      UnlabelHelper.setDefaultValue(meta["latitude"].stringValue, key: "latitude")
      UnlabelHelper.setDefaultValue(meta["longitude"].stringValue, key: "longitude")
    }, failed: { (error) in
    })
  }
  
  func getGPSLocation() {
    isAuthorizedtoGetUserLocation()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.requestLocation()
    } else {
    }
  }
  
  func getCurrentLocation() {
    getInfluencerLocation()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "InfluencerPickRadius"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController {
        if let pickLocationVC:PickLocationVC = navViewController.viewControllers[0] as? PickLocationVC {
          pickLocationVC.categoryStyleType = CategoryStyleEnum.radius
          pickLocationVC.delegate = self
        }
      }
    }
  }
  
  @IBAction func IBActionApply(_ sender: Any) {
    delegate?.locationFiltersSelected(radius)
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func IBActionDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func IBActionLocationToggle(_ sender: UIButton) {
    if !sender.isSelected {
    if sender.tag == 0 {
      sender.isSelected = !sender.isSelected
      IBButtonLoc.isSelected = false
      if !sender.isSelected {
        sender.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        IBImageViewGPS.isHidden = true
      } else {
        UnlabelLoadingView.sharedInstance.start(self.view)
        getGPSLocation()
        sender.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        IBImageViewGPS.isHidden = false
        IBImageViewLoc.isHidden = true
      }
      IBButtonLoc.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
    } else {
      IBButtonGPS.isSelected = false
      sender.isSelected = !sender.isSelected
      if !sender.isSelected {
        IBImageViewLoc.isHidden = true
        sender.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
      } else {
        getCurrentLocation()
        IBImageViewLoc.isHidden = false
        IBImageViewGPS.isHidden = true
        sender.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
      }
      IBButtonGPS.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
    }
  }
  }
}

extension LocationFilterVC: PickLocationDelegate {
  func locationDidSelected(_ selectedItem: FilterModel) {
    print(selectedItem)
    radius = selectedItem.typeId
    IBButtonRadius.setTitle(selectedItem.typeName, for: UIControlState())
  }
}
