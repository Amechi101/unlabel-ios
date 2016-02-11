//
//  AddLabelVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 10/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSDynamoDB

class AddLabelVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBtxtFieldLabelName: UITextField!
    @IBOutlet weak var IBtxtFieldLabelPrice: UITextField!
    @IBOutlet weak var IBtxtFieldLabelURL: UITextField!
    @IBOutlet weak var IBtxtViewLabelInfo: UITextView!
    @IBOutlet weak var IBswitchIsActive: UISwitch!
    @IBOutlet weak var IBbtnLabelImage: UIButton!
    
    var selectedBrand = Brand()
    var imagePicker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    var imageURL = NSURL()
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
    
    func showSomethingWentWrong(){
        UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: "Please try again") { () -> () in
            
        }
    }
    
    //
    //MARK:- AWS Call Methods
    //
    func awsCallAddLabel(){
        if let brandName:String = selectedBrand.dynamoDB_Brand.BrandName{
            if let labelName:String = self.IBtxtFieldLabelName.text where labelName.characters.count > 0{
                if let _:UIImage = self.IBbtnLabelImage.backgroundImageForState(UIControlState.Normal){
                    if let labelPrice:String = self.IBtxtFieldLabelPrice.text where labelPrice.characters.count > 0{
                        if let labelURL:String = self.IBtxtFieldLabelURL.text where labelURL.characters.count > 0{
                            showLoading()
                            let imageName = "\(NSUUID().UUIDString).jpg"
                            
                            AWSHelper.uploadImageWithCompletion(imageName: imageName,imageURL:self.imageURL,uploadPathKey:pathKeyLabels, completionHandler: { (task, error) -> () in
                                if ((error) != nil){
                                    self.hideLoading()
                                    UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.debugDescription, onOk: { () -> () in
                                    
                                    })
                                }
                                else{
                                    let dynamoDB_Label = DynamoDB_Label()
                                    dynamoDB_Label.BrandName = brandName
                                    dynamoDB_Label.LabelName = labelName
                                    dynamoDB_Label.LabelImageName = imageName
                                    dynamoDB_Label.LabelPrice = labelPrice
                                    dynamoDB_Label.LabelURL = labelURL
                                    dynamoDB_Label.isActive = self.IBswitchIsActive.on  //return true if switch is on else return off
                    
                                    let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
                                    dynamoDBObjectMapper.save(dynamoDB_Label).continueWithBlock({(task: AWSTask) -> AnyObject? in
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
                                            UnlabelHelper.showAlert(onVC: self, title: "Success", message: "Label Added Successfully", onOk: { () -> () in
                                                self.navigationController?.popViewControllerAnimated(true)
                                            })
                                        }
                                        return nil
                                    })
                                }
                            })
                        }else { showSomethingWentWrong() }
                    }else { showSomethingWentWrong() }
                }else { showSomethingWentWrong() }
            }else { showSomethingWentWrong() }
        }else { showSomethingWentWrong() }
    }

}

//
//MARK:- IBAction Methods
//
extension AddLabelVC{
    @IBAction func IBActionSave(sender: AnyObject) {
        awsCallAddLabel()
    }
    
    @IBAction func IBActionIsActive(sender: UISwitch) {
        
    }
    
    @IBAction func IBActionChooseImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}



//
//MARK:- UIImagePickerControllerDelegate Methods
//
extension AddLabelVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //    imagePickerController(_:didFinishPickingMediaWithInfo:){
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.IBbtnLabelImage.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        self.IBbtnLabelImage.setTitle("", forState: UIControlState.Normal)
        
        
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