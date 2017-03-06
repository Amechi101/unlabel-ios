//
//  UnlabelLegalVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 17/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class UnlabelLegalVC: UIViewController,UIWebViewDelegate {
  
  @IBOutlet weak var IBWebviewStaticURL: UIWebView!
  var urlString: String = String()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let url: URL = URL (string: urlString)!
    let request: URLRequest = URLRequest(url: url as URL)
    IBWebviewStaticURL.loadRequest(request as URLRequest)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  

}
