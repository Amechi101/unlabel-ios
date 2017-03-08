//
//  UnlabelLegalVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON


class UnlabelLegalVC: UIViewController,UIWebViewDelegate {
  
  @IBOutlet weak var IBWebviewStaticURL: UIWebView!
  @IBOutlet weak var IBActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var IBButtonNavTitle: UIButton!
  var urlString: String = String()
  var navTitle: String = String()
  override func viewDidLoad() {
    super.viewDidLoad()
    IBButtonNavTitle.setTitle(navTitle.uppercased(), for: UIControlState())
    let url: URL = URL (string: "https://" + urlString)!
    let request: URLRequest = URLRequest(url: url as URL)
    IBWebviewStaticURL.loadRequest(request as URLRequest)
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
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
