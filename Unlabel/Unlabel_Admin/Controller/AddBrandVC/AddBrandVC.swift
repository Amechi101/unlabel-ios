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
    
    @IBAction func IBActionSave(sender: AnyObject) {
        if let brandName = IBtxtFieldBrandName.text where IBtxtFieldBrandName.text?.characters.count>0{
            if let brandDescription = IBtxtViewDescription.text where IBtxtViewDescription.text.characters.count>0{
                if let brandLocation = IBtxtFieldLocation.text where IBtxtFieldLocation.text?.characters.count>0{
                    if let _ = IBbtnChooseImage.backgroundImageForState(UIControlState.Normal){
                                showLoading()
                            let imageName = "\(NSUUID().UUIDString).jpg"
                        
                        AWSHelper.uploadImageWithCompletion(imageName: imageName,imageURL:self.imageURL,uploadPathKey:pathKeyBrands, completionHandler: { (task, error) -> () in
                            if ((error) != nil){
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
                                dynamoDB_Brand.isActive = true
                                
                                let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
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
    
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
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
//MARK:- AWS Call Methods
//
extension AddBrandVC{
    
    
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
    
    func showSomethingWentWrong(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: "Please try again") { () -> () in
            
        }
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

}

