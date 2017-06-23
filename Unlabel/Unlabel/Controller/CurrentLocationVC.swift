//
//  CurrentLocationVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces

class CurrentLocationVC: UIViewController {
  
  @IBOutlet weak var IBButtonSelectLocation: UIButton!
  @IBOutlet weak var IBButtonSelectCity: UIButton!
  @IBOutlet weak var IBButtonSelectState: UIButton!
  @IBOutlet weak var IBViewStateContainer: UIView!
  @IBOutlet weak var IBButtonSelectCountry: UIButton!
  var sortMode: String = "NEW"
  var sortModeValue: String = "Newest to Oldest"
  var slideUpMenu: SlideUpView = .country
  var stateID: String = "1"
  var countryID: String = "US"
  var placeName: String = ""
  var lat: String = ""
  var lon: String = ""
  var location_id: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getInfluencerLocation()
    UINavigationBar.appearance().tintColor = MEDIUM_GRAY_TEXT_COLOR
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func saveInfluencerLocation() {
    let params: [String: String] = ["location_name":placeName,"id":location_id]
    print(params)
    UnlabelAPIHelper.sharedInstance.saveInfluencerLocation(params ,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      self.IBButtonSelectLocation.setTitle(self.placeName, for: .normal)
      UnlabelHelper.setDefaultValue(self.lat, key: "latitude")
      UnlabelHelper.setDefaultValue(self.lon, key: "longitude")
      }, failed: { (error) in
    })
  }
  
  func getInfluencerLocation() {
    UnlabelAPIHelper.sharedInstance.getInfluencerLocation( success:{ (
      meta: JSON) in
      print(meta)
      DispatchQueue.main.async(execute: { () -> Void in
        self.IBButtonSelectLocation.setTitle(meta["display_string"].stringValue, for: .normal)
        self.location_id = meta["id"].stringValue
        UnlabelHelper.setDefaultValue(meta["latitude"].stringValue, key: "latitude")
        UnlabelHelper.setDefaultValue(meta["longitude"].stringValue, key: "longitude")
      })
     
    }, failed: { (error) in
    })
  }
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    print(self.countryID)
    if self.countryID != "US" {
      if !(self.IBButtonSelectCity.titleLabel?.text?.isEmpty)! || self.countryID != "" {
        saveInfluencerLocation()
      }
    } else {
      if !(self.IBButtonSelectCity.titleLabel?.text?.isEmpty)! || self.stateID != "" || self.countryID != "" {
        saveInfluencerLocation()
      }
    }
  }
  
  @IBAction func IBActionSelectCurrentLocation(_ sender: Any) {
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    filter.country = "US"
    filter.type = GMSPlacesAutocompleteTypeFilter.city
    let autocompleteController = GMSAutocompleteViewController()
    autocompleteController.autocompleteFilter = filter
    autocompleteController.delegate = self
    present(autocompleteController, animated: true, completion: nil)
  }
  
  @IBAction func IBActionSelectCountry(_ sender: Any) {
    slideUpMenu = SlideUpView.country
    self.addSortPopupView(SlideUpView.country,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  
  @IBAction func IBActionSelectState(_ sender: Any) {
    slideUpMenu = SlideUpView.state
    self.addSortPopupView(SlideUpView.state,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }

  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "InfluencerCurrentLocation" {
      if let navViewController:UINavigationController = segue.destination as? UINavigationController {
        if let pickLocationVC:PickLocationVC = navViewController.viewControllers[0] as? PickLocationVC {
          pickLocationVC.categoryStyleType = CategoryStyleEnum.location
          pickLocationVC.delegate = self
        }
      }
    }
  }
}

extension CurrentLocationVC: PickLocationDelegate {
  func locationDidSelected(_ selectedItem: FilterModel) {
    print(selectedItem)
   // self.IBButtonSelectLocation.setTitle(selectedItem.typeName, for: .normal)
    getInfluencerLocation()
  }
}

extension CurrentLocationVC: EnterCityVCDelegate {
  func popupDidClickUpdate(_ selectedCity: String) {
    print(selectedCity)
    self.IBButtonSelectCity.setTitle(selectedCity, for: .normal)
  }
}

extension CurrentLocationVC: GMSAutocompleteViewControllerDelegate {
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place formattedAddress: \(place.formattedAddress!)")
    print("Place addressComponents: \(place.addressComponents!)")
    print("Place lat: \(place.coordinate.latitude)")
    print("Place long: \(place.coordinate.longitude)")
    placeName = place.formattedAddress!
    lat = "\(place.coordinate.latitude)"
    lon = "\(place.coordinate.longitude)"
    print("Place formattedAddress: \(placeName)")
    dismiss(animated: true, completion: nil)
    saveInfluencerLocation()
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
}

//MARK: Sort Popup methods

extension CurrentLocationVC: SortModePopupViewDelegate {
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect) {
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView {
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      
      if slideUpMenu == SlideUpView.country {
        viewSortPopup.popupTitle = "SELECT YOUR COUNTRY"
      } else if slideUpMenu == SlideUpView.state {
        viewSortPopup.popupTitle = "SELECT YOUR STATE"
      }
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
  
    func popupDidClickDone(_ selectedItem: UnlabelStaticList, countryCode: Bool) {
    print(self.countryID)
    //  print(sortMode)
    sortModeValue = selectedItem.uName
    if slideUpMenu == SlideUpView.country {
      countryID = selectedItem.uId
      if self.countryID != "US" {
        stateID = ""
        self.IBButtonSelectState.isEnabled = false
        self.IBButtonSelectState.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBViewStateContainer.backgroundColor = EXTRA_LIGHT_GRAY_TEXT_COLOR
      } else {
        self.IBButtonSelectState.isEnabled = true
        self.IBViewStateContainer.backgroundColor = LIGHT_GRAY_BORDER_COLOR
        self.IBButtonSelectState.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
      }
      IBButtonSelectCountry.setTitle(sortModeValue, for: .normal)
    } else if slideUpMenu == SlideUpView.state {
      print(self.countryID)
      if self.countryID == "US" {
        stateID = selectedItem.uId
      } else {
        stateID = ""
      }
      IBButtonSelectState.setTitle(sortModeValue, for: .normal)
    }
  }
}
