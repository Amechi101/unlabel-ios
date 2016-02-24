//
//  AddProductVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 10/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSDynamoDB

protocol AddProductVCDelegate{
    func shouldReloadData(shouldReload:Bool)
}

class AddProductVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBtxtFieldProductName: UITextField!
    @IBOutlet weak var IBtxtFieldProductPrice: UITextField!
    @IBOutlet weak var IBtxtFieldProductURL: UITextField!
    @IBOutlet weak var IBswitchIsActive: UISwitch!
    @IBOutlet weak var IBbtnProductImage: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var imagePicker = UIImagePickerController()
    var selectedBrand = Brand()
    var selectedProduct = Product()
    var imageURL = NSURL()
    
    var delegate:AddProductVCDelegate?
    var sSuccessMessage:String?
    var imageName:String?

    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        //Chech if new brand or editing existing one,
        //Editing
        if let productNameCharacters:Int = selectedProduct.dynamoDB_Product.ProductName.characters.count where productNameCharacters > 0{
            if let brandName:String = selectedProduct.dynamoDB_Product.BrandID{
                if let productName:String = selectedProduct.dynamoDB_Product.ProductName{
                    if let productImageName:String = selectedProduct.dynamoDB_Product.ProductImageName{
                        if let productPrice:CGFloat = selectedProduct.dynamoDB_Product.ProductPrice{
                            if let productURL:String = selectedProduct.dynamoDB_Product.ProductURL{
                                if let isProductActive:Bool = selectedProduct.dynamoDB_Product.isActive{
                                    if let productImage:UIImage = selectedProduct.imgProductImage{
                                        IBtxtFieldProductName.text = productName
                                        IBtxtFieldProductPrice.text = "\(productPrice)"
                                        IBtxtFieldProductURL.text = productURL
                                        IBswitchIsActive.on = isProductActive
                                        
                                        IBbtnProductImage.setBackgroundImage(productImage, forState: UIControlState.Normal)
                                        changeImageDataToNSURL(productImageName, imageData: UIImagePNGRepresentation(productImage)!)
                                        self.imageName = productImageName
                                        sSuccessMessage = "Product Edited Successfully"
                                        self.IBbtnProductImage.setTitle("", forState: UIControlState.Normal)
                                        self.title = "Edit \(brandName)"
                                    }else{ showUnableToEdit() }
                                }else{ showUnableToEdit() }
                            }else{ showUnableToEdit() }
                        }else{ showUnableToEdit() }
                    }else{ showUnableToEdit() }
                }else{ showUnableToEdit() }
            }else{ showUnableToEdit() }
        //Adding new brand
        }else{
            imageName = "\(NSUUID().UUIDString).png"
            sSuccessMessage = "Product Added Successfully"
            self.title = "Add New Product"
        }

        self.title = "Add Product to \(selectedBrand.dynamoDB_Brand.BrandName)"
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
extension AddProductVC{
    @IBAction func IBActionSave(sender: AnyObject) {
        self.resignFirstResponder()
        awsCallAddProduct()
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
extension AddProductVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //    imagePickerController(_:didFinishPickingMediaWithInfo:){
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.IBbtnProductImage.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        self.IBbtnProductImage.setTitle("", forState: UIControlState.Normal)
        
        
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
        
//        let imageData = NSData(contentsOfFile: localPath)!
        imageURL = NSURL(fileURLWithPath: localPath)
      
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


//
//MARK:- AWS Call Methods
//
extension AddProductVC{
    func awsCallAddProduct(){
        if let brandName:String = selectedBrand.dynamoDB_Brand.BrandName{
            if let productName:String = self.IBtxtFieldProductName.text where productName.characters.count > 0{
                if let _:UIImage = self.IBbtnProductImage.backgroundImageForState(UIControlState.Normal){
                    if let productPrice:CGFloat = CGFloat((IBtxtFieldProductPrice.text! as NSString).floatValue)  where productPrice > 0{
                        if let productURL:String = self.IBtxtFieldProductURL.text where productURL.characters.count > 0{
                            showLoading()
                            
                            AWSHelper.uploadImageWithCompletion(imageName: imageName!,imageURL:self.imageURL,uploadPathKey:pathKeyProducts, completionHandler: { (task, error) -> () in
                                if ((error) != nil){
                                    self.hideLoading()
                                    UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.debugDescription, onOk: { () -> () in
                                        
                                    })
                                }
                                else{
                                    let dynamoDB_Product = DynamoDB_Product()
                                    dynamoDB_Product.BrandID = brandName
                                    dynamoDB_Product.ProductName = productName
                                    dynamoDB_Product.ProductImageName = self.imageName!
                                    dynamoDB_Product.ProductPrice = productPrice
                                    dynamoDB_Product.ProductURL = productURL
                                    dynamoDB_Product.isActive = self.IBswitchIsActive.on  //return true if switch is on else return off
                                    
                                    let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
                                    dynamoDBObjectMapper.save(dynamoDB_Product).continueWithBlock({(task: AWSTask) -> AnyObject? in
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
                                            UnlabelHelper.showAlert(onVC: self, title: "Success", message: self.sSuccessMessage!, onOk: { () -> () in
                                                self.delegate?.shouldReloadData(true)
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
//MARK:- Custom Methods
//
extension AddProductVC{
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
    
    func showUnableToEdit(){
        UnlabelHelper.showAlert(onVC: self, title: "Image Not Loaded,or something went wrong", message: "Please try again to edit", onOk: { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func changeImageDataToNSURL(imageName:String,imageData:NSData){
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        // getting local path
        let localPath = (documentDirectory as NSString).stringByAppendingPathComponent(imageName)
        
        imageData.writeToFile(localPath, atomically: true)
        imageURL = NSURL(fileURLWithPath: localPath)
    }
}