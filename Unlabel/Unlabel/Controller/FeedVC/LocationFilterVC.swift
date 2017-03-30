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

class LocationFilterVC: UIViewController, CLLocationManagerDelegate {
  
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getInfluencerLocation()
    
    isAuthorizedtoGetUserLocation()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestLocation()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func isAuthorizedtoGetUserLocation() {
    
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Did location updates is called")
    print(locations.first!)
    let currentLoc: CLLocation = locations.first!
    print(currentLoc.coordinate.latitude)
    print(currentLoc.coordinate.longitude)
    UnlabelHelper.setDefaultValue("\(currentLoc.coordinate.latitude)", key: "latitude")
    UnlabelHelper.setDefaultValue("\(currentLoc.coordinate.longitude)", key: "longitude")
    //store the user location here to firebase or somewhere
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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
  @IBAction func IBActionDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
