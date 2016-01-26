//
//  ViewController.swift
//  Unlabel_Admin
//
//  Created by ZAID PATHAN on 25/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

class AdminVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var IBtblBrand: UITableView!
    
    var arrBrands = [Brand]()
    var shouldReloadData = false
    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        authenticateUser()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldReloadData{
            self.parseCallFetchBrands()
        }else{
            shouldReloadData = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//MARK:- UITableViewDataSource,UITableViewDelegate Methods
//
extension AdminVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBrands.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brandsCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        brandsCell.textLabel?.text = arrBrands[indexPath.row].sBrandName
        brandsCell.imageView?.image = arrBrands[indexPath.row].imgBrandImage
        brandsCell.imageView?.contentMode = UIViewContentMode.ScaleToFill
        return brandsCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.deleteBrandAtIndexPath(indexPath)
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func deleteBrandAtIndexPath(indexPath:NSIndexPath){
        parseCallDeleteBrand(indexPath)
    }
}


//
//MARK:- IBAction Methods
//
extension AdminVC{
    @IBAction func IBActionAddBrand(sender: AnyObject) {
        
    }
}


//
//MARK:- UIAlertViewDelegate Methods
//
extension AdminVC:UIAlertViewDelegate{
    
}


//
//MARK:- Custom Methods
//
extension AdminVC{
    
    func setupUIOnLoad(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Brands"
        showLoading()
    }
    
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to access Unlabel admin."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    self.parseCallFetchBrands()
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    self.showPasswordAlert()
                    print(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter custom password")
                        
                    default:
                        print("Authentication failed")
                    }
                }
                
            })]
        }
        else{
            showPasswordAlert()
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                print("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
        }
    }
    
    func showPasswordAlert(){
        let passwordPrompt = UIAlertController(title: "Enter Password", message: "Admin password required.", preferredStyle: UIAlertControllerStyle.Alert)
        
        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.showPasswordAlert()
        }))
        
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if passwordPrompt.textFields?.first?.text == "qwerty"{
                self.parseCallFetchBrands()
            }else{
                self.showPasswordAlert()
            }
        }))
        
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })

        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(passwordPrompt, animated: true, completion: nil)
        })
    }
    
    func showLoading(){
        self.IBactivityIndicator.hidden = false
        self.IBactivityIndicator.startAnimating()
    }
    
    func hideLoading(){
        self.IBactivityIndicator.hidden = true
        self.IBactivityIndicator.stopAnimating()
    }
    
    
    func reloadTable(){
        self.IBtblBrand.reloadData()
        self.hideLoading()
    }
}


//
//MARK:- Parse Call Methods
//
extension AdminVC{
    
    func parseCallFetchBrands(){
        showLoading()
                
        let query = PFQuery(className:PARSE_BRAND)
        query.findObjectsInBackgroundWithBlock {
                (brandObjects: [PFObject]?, error: NSError?) -> Void in
                if let error = error {
                    UnlabelHelper.showAlert(onVC: self, title: error.debugDescription, message: "Please try again", onOk: { () -> () in
                        self.hideLoading()
                    })
                } else {
                    print(brandObjects)
                    if let brandData = brandObjects?.count where brandData > 0{
                        self.handleBrandObjs(brandObjects!)
                    }else{
                        self.hideLoading()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.arrBrands = [Brand]()
                            self.reloadTable()
                        })
                        UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                        })
                        print("no data found")
                    }
                }
        }
    }
    
    func handleBrandObjs(brandObjects:[PFObject]){
        arrBrands = [Brand]()
        for brandObj in brandObjects{
            let currentBrand = Brand()
            currentBrand.sObjectID      = brandObj.objectId!
            currentBrand.sBrandName     = brandObj[PRM_BRAND_NAME] as! String
            currentBrand.sDescription   = brandObj[PRM_DESCRIPTION] as! String
            currentBrand.sLocation      = brandObj[PRM_LOCATION] as! String

            let imageFile:PFFile = brandObj[PRM_MAIN_IMAGE] as! PFFile
            imageFile.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                if let error = error{
                    print("Try again")
                }else{
                    let image = UIImage(data: imageData!)
                    currentBrand.imgBrandImage = image!
                    self.reloadTable()
                }
            })
            
            arrBrands.append(currentBrand)
        }
        
        defer{
            self.reloadTable()
        }
    }
    
    func parseCallDeleteBrand(indexPath:NSIndexPath){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let object:PFObject = PFObject(withoutDataWithClassName: PARSE_BRAND, objectId: self.arrBrands[indexPath.row].sObjectID)
            object.deleteInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            self.parseCallFetchBrands()
            }
        }
    }
}