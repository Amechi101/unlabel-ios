//
//  AboutLabelVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 03/05/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SafariServices

class AboutLabelVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBlblDescription: UILabel!
    @IBOutlet weak var IBlblLocation: UILabel!
    @IBOutlet weak var IBbtnViewLabelName: UIButton!
    
    var selectedBrand:Brand?
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = selectedBrand{
            if let description = selectedBrand?.Description{
                IBlblDescription.text = description
            }
            
            if let city = selectedBrand?.city{
                if let location = selectedBrand?.location{
                    IBlblLocation.text = "\(city), \(location)"
                }
            }
            
            if let brandName = selectedBrand?.Name{
                IBbtnViewLabelName.setTitle("VIEW \(brandName.uppercased())", for: UIControlState())
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension AboutLabelVC:SFSafariViewControllerDelegate{
    func openSafariForURL(_ urlString:String){
        if let productURL:URL = URL(string: urlString){
            APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
            let safariVC = UnlabelSafariVC(url: productURL)
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


//
//MARK:- IBAction Methods
//
extension AboutLabelVC{
    @IBAction func IBActionClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func IBActionViewLabel(_ sender: UIButton) {
        if let labelURL = selectedBrand?.BrandWebsiteURL{
            openSafariForURL(labelURL)
        }
    }
}


//
//MARK:- Custom Methods
//
extension AboutLabelVC{
    
}
