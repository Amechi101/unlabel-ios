//
//  ViewController.swift
//  Unlabel_Admin
//
//  Created by ZAID PATHAN on 25/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Parse
import AWSS3
import AWSCore
import AWSDynamoDB
import LocalAuthentication

class AdminVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var IBtblBrand: UITableView!
    
    var arrBrandList = [Brand]()
    var arrDynamoDBBrand = [DynamoDB_Brand]()
    var shouldReloadData = false
    
    var didSelectIndexPath = NSIndexPath()
    
    
//
//MARK:- VC Lifecycle
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
//        authenticateUser()
        awsCallFetchBrands()
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldReloadData{
            self.awsCallFetchBrands()
        }else{
            shouldReloadData = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//
//MARK:- UITableViewDataSource,UITableViewDelegate Methods
//

extension AdminVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBrandList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var brandsCell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if brandsCell == nil{
            brandsCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        brandsCell!.textLabel?.text = arrBrandList[indexPath.row].dynamoDB_Brand.BrandName
        brandsCell!.imageView?.contentMode = UIViewContentMode.ScaleToFill
        if let brandImage:UIImage = arrBrandList[indexPath.row].imgBrandImage{
            brandsCell?.imageView?.image = brandImage
        }
    
        return brandsCell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        didSelectIndexPath = indexPath
        self.navigationController!.performSegueWithIdentifier(S_ID_LABEL_LIST_VC, sender: self)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.deleteBrandAtIndexPath(indexPath)
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func deleteBrandAtIndexPath(indexPath:NSIndexPath){
        awsCallDeleteBrand(atIndexPath: indexPath)
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

        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to access Unlabel admin."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    self.awsCallFetchBrands()
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
                self.awsCallFetchBrands()
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
        dispatch_async(dispatch_get_main_queue(), {
            self.IBactivityIndicator.hidden = false
            self.IBactivityIndicator.startAnimating()
        })
    }
    
    func hideLoading(){
        dispatch_async(dispatch_get_main_queue(), {
            self.IBactivityIndicator.hidden = true
            self.IBactivityIndicator.stopAnimating()
        })
    }
    
    func reloadTable(){
        self.IBtblBrand.reloadData()
        self.hideLoading()
    }
    
}


//
//MARK:- AWS Call Methods
//
extension AdminVC{
    
    func awsCallFetchBrands(){
        showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.scan(DynamoDB_Brand.self, expression: nil).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in

            //If error
            if let error = task.error{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.localizedDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If exception
            if let exception = task.exception{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.debugDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If got result
            if let result = task.result{
                //If result items count > 0
                if let arrItems:[DynamoDB_Brand] = result.items as? [DynamoDB_Brand] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrBrandList = [Brand]()
                        for brand in arrItems{
                            let brandObj = Brand()
                            brandObj.dynamoDB_Brand = brand

                            
                            AWSHelper.downloadImageWithCompletion(forImageName: brand.ImageName, uploadPathKey: pathKeyBrands, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let image = UIImage(data: downloadedData){
                                            brandObj.imgBrandImage = image
                                            self.IBtblBrand.reloadData()
                                        }
                                    })
                                }
                            })
                            
                            self.arrBrandList.append(brandObj)
                        }
                        defer{
                            self.hideLoading()
                            self.IBtblBrand.reloadData()
                        }
                    })
                }else{
                    self.hideLoading()
                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                    })
                }
            }else{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                })
            }
    
            
            return nil
        }
    }
    
    func awsCallDeleteBrand(atIndexPath indexPath:NSIndexPath){
        self.showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        dynamoDBObjectMapper.remove(arrBrandList[indexPath.row].dynamoDB_Brand).continueWithBlock { (task:AWSTask) -> AnyObject? in
            self.hideLoading()
            if (task.error != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.error.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.exception != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.exception.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.result != nil) {
                self.awsCallDeleteBrandImage(atIndexPath: indexPath)
                self.arrBrandList.removeAtIndex(indexPath.row)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.IBtblBrand.reloadData()
                })
            }
            return nil
        }
    }
    
    func awsCallDeleteBrandImage(atIndexPath indexPath:NSIndexPath){
        
        //defining bucket and upload file name
        let S3DeleteKeyName: String = "public/\(arrBrandList[indexPath.row].dynamoDB_Brand.ImageName)"
        
        let awsDeleteRequest = AWSS3DeleteObjectRequest()
        awsDeleteRequest.bucket = S3_BUCKET_NAME
        awsDeleteRequest.key = S3DeleteKeyName
        
        let s3 = AWSS3.defaultS3()
        s3.deleteObject(awsDeleteRequest).continueWithBlock { (task:AWSTask) -> AnyObject? in
            
            if (task.error != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.error.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.exception != nil) {
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: task.exception.debugDescription, onOk: { () -> () in
                    
                })
            }
            if (task.result != nil) {
                UnlabelHelper.showAlert(onVC: self, title: "Success", message: "Brand Deleted Successfully", onOk: { () -> () in
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }

            return nil
        }
    }

}