//
//  ProductDetailsWebViewVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/08/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class ProductDetailsWebViewVC: UIViewController {

    @IBOutlet weak var IBbtnStar: UIButton!
    @IBOutlet weak var IBlblBrandName: UILabel!
    var selectedBrand:Brand?
    
    @IBOutlet weak var IBwebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
//MARK:- IBActions Methods
//
extension ProductDetailsWebViewVC{
    @IBAction func IBActionFollow(sender: AnyObject) {
    }
    
    @IBAction func IBActionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


//
//MARK:- Custom Methods
//
extension ProductDetailsWebViewVC{
    private func setupOnLoad(){
        loadbrandWebsite()
    }
    
    private func loadbrandWebsite(){
        IBlblBrandName.text = selectedBrand?.Name.uppercaseString
        if let urlString = selectedBrand?.BrandWebsiteURL{
            if let url = NSURL(string: urlString){
                IBwebView.loadRequest(NSURLRequest(URL: url))
            }else{
                showErrorAlert()
            }
        }else{
            showErrorAlert()
        }
    }
    
    private func showErrorAlert(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}