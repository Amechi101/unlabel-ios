//
//  UnlabelLegalVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class UnlabelLegalVC: UIViewController,UIWebViewDelegate {
  
  @IBOutlet weak var IBWebviewStaticURL: UIWebView!
  var urlString: String = String()
  override func viewDidLoad() {
    super.viewDidLoad()
    
   // let url: URL = URL (string: urlString)!
    let url: URL = URL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AB3gizjA9Uhs9g2AsaOWzBiII3LxRLl6&scope=read_write&state="+UnlabelHelper.getDefaultValue("influencer_auto_id")!)!
    let request: URLRequest = URLRequest(url: url as URL)
    IBWebviewStaticURL.loadRequest(request as URLRequest)
    
    UnlabelAPIHelper.sharedInstance.loginToStripe(self, success:{ (
      meta: JSON) in
      print(meta)
      
    }, failed: { (error) in
    })
    
       // Do any additional setup after loading the view.
  }
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
    
    print(request.description)
    let us = request.description
    let scanner = Scanner(string:us)
    var scanned: NSString?
    var result: String = String()
    
    if scanner.scanUpTo("&code=", into:nil) {
      scanner.scanString("&code=", into:nil)
      
      if scanner.scanUpTo("", into:&scanned) {
        result = scanned as! String
        print(result)
      }
    }
    if !(result.isEmpty){
    let param:[String: String] = ["client_secret":"sk_test_STJxYzsopQx9fd4xIcE4EzT9","grant_type":"authorization_code","code":result,"state":UnlabelHelper.getDefaultValue("influencer_auto_id")!]
    UnlabelAPIHelper.sharedInstance.connectToStripe(param, onVC:self, success:{ (
      meta: JSON) in
      print(meta)
      
    }, failed: { (error) in
    })
    }
    return true
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  

}


extension UnlabelLegalVC: SFSafariViewControllerDelegate{
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
