//
//  BankInfoVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 20/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SafariServices


class BankInfoVC: UIViewController,UIWebViewDelegate {

  @IBOutlet weak var IBWebviewStripeConnect: UIWebView!
  @IBOutlet weak var IBActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

      let url: URL = URL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AB3gizjA9Uhs9g2AsaOWzBiII3LxRLl6&scope=read_write&state="+UnlabelHelper.getDefaultValue("influencer_auto_id")!)!
      let request: URLRequest = URLRequest(url: url as URL)
      IBWebviewStripeConnect.loadRequest(request as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  func webViewDidStartLoad(_ webView: UIWebView){
    IBActivityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView){
    IBActivityIndicator.stopAnimating()
  }
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
    
    print(request.description)
    let us = request.description
    let scanner = Scanner(string:us)
    var scanned: NSString?
    var result: String = request.description
    
    if scanner.scanUpTo("&code=", into:nil) {
      scanner.scanString("&code=", into:nil)
      
      if scanner.scanUpTo("", into:&scanned) {
        result = scanned as! String
        print(result)
      }
    }
    if result == "http://35.166.138.246/dashboard/"{
      self.dismiss(animated: true, completion: nil)
    }
    return true
  }

  
  @IBAction func IBActionDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}


extension BankInfoVC: SFSafariViewControllerDelegate{
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
