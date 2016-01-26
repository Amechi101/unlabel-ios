//
//  AddBrandVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Parse

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
                    if let brandMainImage = IBbtnChooseImage.backgroundImageForState(UIControlState.Normal){
                        if let imageData = UIImagePNGRepresentation(brandMainImage) where imageData.length <= 10485760{
                                showLoading()
                        
                                let brandObj = PFObject(className: PARSE_BRAND)
                                brandObj[PRM_BRAND_NAME] = brandName
                                brandObj[PRM_DESCRIPTION] = brandDescription
                                brandObj[PRM_LOCATION] = brandLocation
                        
                                let imageFile = PFFile(name: "\(NSUUID().UUIDString).png", data: imageData)
                                brandObj[PRM_MAIN_IMAGE] = imageFile
                                brandObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                    self.hideLoading()
                                    if let _ = error{
                                        self.showSomethingWentWrong()
                                    }else{
                                        UnlabelHelper.showAlert(onVC: self, title: "Brand added", message: "Success!", onOk: { () -> () in
                                            self.navigationController?.popViewControllerAnimated(true)
                                        })
                                    }
                                    print("Object has been saved.")
                                }
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
        UnlabelHelper.showAlert(onVC: self, title: "Something Went Wrong!", message: "Please try again") { () -> () in
            
        }
    }
}


//
//MARK:- UIImagePickerControllerDelegate Methods
//
extension AddBrandVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.IBbtnChooseImage.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        self.IBbtnChooseImage.setTitle("", forState: UIControlState.Normal)
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

