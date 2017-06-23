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
  
  //MARK:- IBOutlets, constants, vars
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
  
  //MARK: -  View lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    if UnlabelHelper.getDefaultValue("useGPSLocation") != nil {
        if UnlabelHelper.getDefaultValue("useGPSLocation")! == "true" {
            IBButtonLoc.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
            IBButtonGPS.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
            IBImageViewGPS.isHidden = false
            IBImageViewLoc.isHidden = true
            IBButtonGPS.isSelected = true
        }
    }
    else {
        IBButtonGPS.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        IBButtonLoc.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        IBImageViewLoc.isHidden = false
        IBImageViewGPS.isHidden = true
        IBButtonLoc.isSelected = true
    }
    IBButtonRadius.setTitle(UnlabelSingleton.sharedInstance.radiusFilter! + " miles", for: UIControlState())
    if UnlabelHelper.getDefaultValue("appliedRadius") != nil {
        IBButtonRadius.setTitle(UnlabelHelper.getDefaultValue("appliedRadius")! + " miles", for: UIControlState())
        UnlabelSingleton.sharedInstance.radiusFilter = UnlabelHelper.getDefaultValue("appliedRadius")!
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: - CLLocation methods
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
    UnlabelHelper.setDefaultValue("true", key: "useGPSLocation")
    UnlabelLoadingView.sharedInstance.stop(self.view)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    UnlabelLoadingView.sharedInstance.stop(self.view)
    print("Did location updates is called but failed getting location \(error)")
  }
  
  //MARK: -  Custom methods
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
  
  //MARK: -  IBAction methods
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
      UnlabelHelper.setDefaultValue("true", key: "useGPSLocation")
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
      UnlabelHelper.setDefaultValue("false", key: "useGPSLocation")
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

//MARK: -  Pick Location delegate methods
extension LocationFilterVC: PickLocationDelegate {
  func locationDidSelected(_ selectedItem: FilterModel) {
    print(selectedItem)
    radius = selectedItem.typeId
    IBButtonRadius.setTitle(selectedItem.typeName, for: UIControlState())
  }
}
