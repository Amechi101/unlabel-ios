//
//  BannerViewController.swift
//  Unlabel
//
//  Created by SayOne on 21/12/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices
class BannerViewController: UIViewController {
  
  //MARK:-   IBOutlets,variable,constant declarations
  @IBOutlet weak var bannerDescription: UILabel!
  
  //MARK:-   View Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    UnlabelAPIHelper.sharedInstance.getAllStates({ (arrStates:[UnlabelStaticList], meta: JSON) in
      let data = NSKeyedArchiver.archivedData(withRootObject: arrStates)
      UserDefaults.standard.set(data, forKey: "stateList")
    }, failed: { (error) in
    })
    UnlabelAPIHelper.sharedInstance.getAllCountry({ (arrCountry:[UnlabelStaticList], meta: JSON) in
      let data = NSKeyedArchiver.archivedData(withRootObject: arrCountry)
      UserDefaults.standard.set(data, forKey: "countryList")
    }, failed: { (error) in
    })
    bannerDescription.setTextWithLineSpacing(text: "Rent and tryout products from the best independent brands, create content and earn commission from your created content. ", lineSpace: 6.0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//MARK:-   IBAction methods
extension BannerViewController{
  @IBAction func IBActionGotoUnlabel(_ sender: Any) {
    openSafariForURL(URL_UNLABEL)
  }
}

//MARK: - Safari ViewController Delegate Methods
extension BannerViewController: SFSafariViewControllerDelegate{
  func openSafariForURL(_ urlString:String){
    if let productURL:URL = URL(string: urlString){
      APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
      let safariVC = SFSafariViewController(url: productURL)
      safariVC.delegate = self
      self.present(safariVC, animated: true) { () -> Void in
      }
    }else{ showAlertWebPageNotAvailable() }
  }
  
  func showAlertWebPageNotAvailable(){
    UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
    }
  }
  
  func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity]{
    
    return []
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController){
    APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
  }
  
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
  }
}
