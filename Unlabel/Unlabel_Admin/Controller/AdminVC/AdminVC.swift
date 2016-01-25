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
    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        authenticateUser()
        // Do any additional setup after loading the view, typically from a nib.
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brandsCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        brandsCell.textLabel?.text = "Brand"//arrTitles[indexPath.row]
        return brandsCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}


//
//MARK:- IBAction Methods
//
extension AdminVC{

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
        self.title = "Brand"
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
        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.parseCallFetchBrands()
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })

        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(passwordPrompt, animated: true, completion: nil)
        })
    }
}


//
//MARK:- Parse Call Methods
//
extension AdminVC{
    
    func showLoading(){
        self.IBactivityIndicator.hidden = false
        self.IBactivityIndicator.startAnimating()
    }
    
    func hideLoading(){
        self.IBactivityIndicator.hidden = true
        self.IBactivityIndicator.stopAnimating()
    }
    
    func parseCallFetchBrands(){
        showLoading()
        
//        let testObject = PFObject(className: PARSE_BRAND)
//        testObject[PRM_BRAND_NAME] = "Brand"
//        testObject[PRM_DESCRIPTION] = "Desc"
//        testObject[PRM_LOCATION] = "Loc"
//        
//        let imageData = UIImagePNGRepresentation(UIImage(named: "test")!)
//        let imageFile = PFFile(name: "test.png", data: imageData!)
//        testObject[PRM_MAIN_IMAGE] = imageFile
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
//        }
        
        let query = PFQuery(className:PARSE_BRAND)
        query.findObjectsInBackgroundWithBlock {
                (brandObjects: [PFObject]?, error: NSError?) -> Void in
                if let error = error {
                    print(error)
                } else {
                    print(brandObjects)
                    if let brandData = brandObjects?.count where brandData > 0{
                        self.handleBrandObjs(brandObjects!)
                    }else{
                        print("no data found")
                    }
                }
        }
    }
    
    func handleBrandObjs(brandObjects:[PFObject]){
    
    }
}