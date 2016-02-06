//
//  AddBrandVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Parse
import AWSS3
import AWSDynamoDB

class AddBrandVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBtxtFieldBrandName: UITextField!
    @IBOutlet weak var IBtxtViewDescription: UITextView!
    @IBOutlet weak var IBtxtFieldLocation: UITextField!
    @IBOutlet weak var IBbtnChooseImage: UIButton!
    @IBOutlet weak var IBactivityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    var imageURL = NSURL()
    var selectedImage = UIImage()
    var uploadCompletionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    
    var uploadFileURL: NSURL?
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLoading()
        imagePicker.delegate = self
        self.IBtxtFieldBrandName.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//
//MARK:- IBAction Methods
//
extension AddBrandVC{
    @IBAction func IBActionChooseImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func testDynamoDBAddRow(imageName imageName:String){
        
    }

    
    @IBAction func IBActionSave(sender: AnyObject) {
        if let brandName = IBtxtFieldBrandName.text where IBtxtFieldBrandName.text?.characters.count>0{
            if let brandDescription = IBtxtViewDescription.text where IBtxtViewDescription.text.characters.count>0{
                if let brandLocation = IBtxtFieldLocation.text where IBtxtFieldLocation.text?.characters.count>0{
                    if let brandMainImage = IBbtnChooseImage.backgroundImageForState(UIControlState.Normal){
                        if let imageData = UIImagePNGRepresentation(brandMainImage) where imageData.length <= 10485760{
                                showLoading()
                            let imageName = "\(NSUUID().UUIDString).jpg"
                            
                            uploadImageWithCompletion(imageName: imageName, completionHandler: { (task, error) -> () in                                if ((error) != nil){
                                    self.hideLoading()
                                    UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.debugDescription, onOk: { () -> () in
                                        
                                    })
                                }
                                else{
                                
                                let dynamoDB_Brand = DynamoDB_Brand()
                                dynamoDB_Brand.BrandName = brandName
                                dynamoDB_Brand.Description = brandDescription
                                dynamoDB_Brand.Location = brandLocation
                                dynamoDB_Brand.ImageName = imageName
                                
                                
                                let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//                                dynamoDBObjectMapper.save(dynamoDB_Brand)
                                
                                dynamoDBObjectMapper.save(dynamoDB_Brand).continueWithBlock({(task: AWSTask) -> AnyObject? in
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
                                        UnlabelHelper.showAlert(onVC: self, title: "Success", message: "Brand Added Successfully", onOk: { () -> () in
                                            self.navigationController?.popViewControllerAnimated(true)
                                        })
                                    }
                                        return nil
                                    })
                                }

                            })
//                                let brandObj = PFObject(className: PARSE_BRAND)
//                                brandObj[PRM_BRAND_NAME] = brandName
//                                brandObj[PRM_DESCRIPTION] = brandDescription
//                                brandObj[PRM_LOCATION] = brandLocation
//                        
//                                let imageFile = PFFile(name: "\(NSUUID().UUIDString).png", data: imageData)
//                                brandObj[PRM_MAIN_IMAGE] = imageFile
//                                brandObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//                                    self.hideLoading()
//                                    if let _ = error{
//                                        self.showSomethingWentWrong()
//                                    }else{
//                                        UnlabelHelper.showAlert(onVC: self, title: "Brand added", message: "Success!", onOk: { () -> () in
//                                            self.navigationController?.popViewControllerAnimated(true)
//                                        })
//                                    }
//                                    print("Object has been saved.")
//                                }
                        }else{
                            UnlabelHelper.showAlert(onVC: self, title: "File Size too Large", message: "Use <10 MB file", onOk: { () -> () in
                                
                            })
                        }
                    }else{
                        showSomethingWentWrong()
                    }
                }else{
                    showSomethingWentWrong()
                }
            }else{
                showSomethingWentWrong()
            }
        }else{
            showSomethingWentWrong()
        }
    }
    
    func showSomethingWentWrong(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: "Please try again") { () -> () in
            
        }
    }
}


//
//MARK:- UIImagePickerControllerDelegate Methods
//
extension AddBrandVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//    imagePickerController(_:didFinishPickingMediaWithInfo:){
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.IBbtnChooseImage.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        self.IBbtnChooseImage.setTitle("", forState: UIControlState.Normal)
        
        
            //getting details of image
            let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            let imageName = uploadFileURL.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
            
            // getting local path
            let localPath = (documentDirectory as NSString).stringByAppendingPathComponent(imageName!)
            
            
            //getting actual image
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)
            data!.writeToFile(localPath, atomically: true)
            
            let imageData = NSData(contentsOfFile: localPath)!
            imageURL = NSURL(fileURLWithPath: localPath)
        
        
        selectedImage = chosenImage
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveImage(image: UIImage, withName name: String) {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let data: NSData = UIImageJPEGRepresentation(image, 1.0)!
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        let fullPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(name)
        fileManager.createFileAtPath(fullPath.absoluteString, contents: data, attributes: nil)
        imageURL = NSURL(fileURLWithPath: fullPath.absoluteString)
    }
    
    func loadImage(name: String) -> String {
        let fullPath: String = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(name).absoluteString
        return fullPath
    }
    
    
    func uploadImageWithCompletion(imageName imageName:String,completionHandler: (task:AWSS3TransferUtilityUploadTask, error:NSError?)->()){
        
        //defining bucket and upload file name
        let S3BucketName: String = "unlabel-userfiles-mobilehub-626392447"
        let S3UploadKeyName: String = "public/\(imageName)"
        
    
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.uploadProgress = {(task: AWSS3TransferUtilityTask, bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) in
            dispatch_async(dispatch_get_main_queue(), {
                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                NSLog("Progress is: %f",progress)
            })
        }
        
        self.uploadCompletionHandler = { (task, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(task: task,error:error)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        
        transferUtility.uploadFile(imageURL, bucket: S3BucketName, key: S3UploadKeyName, contentType: "image/jpeg", expression: expression, completionHander: uploadCompletionHandler).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                NSLog("Error: %@",error.localizedDescription);
            }
            if let exception = task.exception {
                NSLog("Exception: %@",exception.description);
            }
            if let _ = task.result {
                NSLog("Upload Starting!")
            }
            
            return nil;
        }
    }

}

//
//MARK:- UITextFieldDelegate,UITextViewDelegate Methods
//
extension AddBrandVC:UITextFieldDelegate,UITextViewDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField.tag == 0{
            self.IBtxtViewDescription.becomeFirstResponder()
        }else if textField.tag == 2{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.IBtxtFieldLocation.becomeFirstResponder()
            return false
        }
        return true
    }
}


//
//MARK:- Custom Methods
//
extension AddBrandVC{
    func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.IBactivityIndicator.hidden = false
            self.IBactivityIndicator.startAnimating()
        }
    }

    func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.IBactivityIndicator.hidden = true
            self.IBactivityIndicator.stopAnimating()
        }
    }
}

