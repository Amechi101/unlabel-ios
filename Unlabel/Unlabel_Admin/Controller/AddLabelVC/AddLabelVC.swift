//
//  AddLabelVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 10/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class AddLabelVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBtxtFieldLabelName: UITextField!
    @IBOutlet weak var IBtxtFieldLabelPrice: UITextField!
    @IBOutlet weak var IBtxtFieldLabelURL: UITextField!
    @IBOutlet weak var IBtxtViewLabelInfo: UITextView!
    @IBOutlet weak var IBswitchIsActive: UISwitch!
    
    var selectedBrand = Brand()
    var activityIndicator = UIActivityIndicatorView()
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Label to \(selectedBrand.dynamoDB_Brand.BrandName)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    //MARK:- Custom Methods
    //
    func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator.frame = self.view.frame
            self.activityIndicator.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            self.activityIndicator.startAnimating()
            self.view.addSubview(self.activityIndicator)
        }
    }
    
    func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    
    //
    //MARK:- IBAction Methods
    //
    @IBAction func IBActionSave(sender: AnyObject) {
        awsCallAddLabel()
    }
    
    @IBAction func IBActionIsActive(sender: UISwitch) {
        
    }
    
    //
    //MARK:- AWS Call Methods
    //
    func awsCallAddLabel(){
    
    }

}
