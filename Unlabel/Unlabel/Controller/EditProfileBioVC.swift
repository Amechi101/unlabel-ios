//
//  EditProfileBioVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class EditProfileBioVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
  
  @IBOutlet var IBImageSelected: UIImageView!
  @IBOutlet var IBTextViewNote: UITextView!
  @IBOutlet weak var IBButtonUpdate: UIButton!
  
  @IBOutlet var views: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    IBImageSelected.clipsToBounds = true
    IBTextViewNote.delegate = self
    IBButtonUpdate.isHidden = true
    getInfluencerProfileBio()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  func getInfluencerProfileBio() {
    UnlabelAPIHelper.sharedInstance.getInfluencerBio( self, success:{ (
      meta: JSON) in
      print(meta)
      self.IBImageSelected.sd_setImage(with: URL(string: meta["image"].stringValue))
      self.IBTextViewNote.text = meta["bio"].stringValue
    }, failed: { (error) in
    })
  }
  @IBAction func IBActionChangeImage(_ sender: Any) {
    showActionSheet()
  }
  @IBAction func IBActionUpdate(_ sender: Any) {
    let parameters = [
      "image": "bio_image_file22_02_2017.jpeg","bio": IBTextViewNote.text!
    ]
    let image = IBImageSelected.image
    
    
    print(getCSRFToken())
    Alamofire.upload(multipartFormData: {
      multipartFormData in
      
      if let imageData = UIImageJPEGRepresentation(image!, 0.6) {
        multipartFormData.append(imageData, withName: "image", fileName: "bio_image_file22_02_2017.jpeg", mimeType: "image/jpeg")
      }
      
      for (key, value) in parameters {
        multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
        
      }
    }, usingThreshold: UInt64.init() , to: v4BaseUrl + "api_v2/influencer_image_bio/", method: .post, headers: ["X-CSRFToken":getCSRFToken()], encodingCompletion: {
      encodingResult in
      
      switch encodingResult {
      case .success(let upload, _, _):
        
        upload.responseJSON {
          response in
          
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            print("json: \(json)")
          case .failure(let error):
            print("error: \(error.localizedDescription)")
          }
//          print("JSON: \(response)")
//          if let JSON = response.result.value {
//            print("JSON: \(JSON)")
//          }
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    })
  }
  
  func getCSRFToken() -> String{
    if let xcsrf:String =  UnlabelHelper.getDefaultValue("X-CSRFToken")! as String{
      return xcsrf
    }
    else{
      return ""
    }
  }
  
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.views.frame.origin.y == 0{
        self.views.frame.origin.y -= keyboardSize.height
      }
    }
    
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.views.frame.origin.y != 0{
        self.views.frame.origin.y += keyboardSize.height
      }
    }
  }
  func textViewDidBeginEditing(_ textView: UITextView){
    IBTextViewNote.textColor = DARK_GRAY_COLOR
  }
  func textViewDidEndEditing(_ textView: UITextView){
    IBTextViewNote.textColor = LIGHT_GRAY_TEXT_COLOR
    if IBTextViewNote.text != ""{
      IBButtonUpdate.isHidden = false
    }
  }
  func textViewDidChange(_ textView: UITextView){
    if IBTextViewNote.text != ""{
      IBButtonUpdate.isHidden = false
      IBTextViewNote.textColor = DARK_GRAY_COLOR
    }
    else{
      IBButtonUpdate.isHidden = true
    }
  }
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if(text == "\n") {
      IBTextViewNote.resignFirstResponder()
      return false
    }
    return true
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func camera()
  {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceType.camera
    
    self.present(myPickerController, animated: true, completion: nil)
    
  }
  
  func photoLibrary()
  {
    
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    
    self.present(myPickerController, animated: true, completion: nil)
    
  }
  
  func showActionSheet() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
      self.photoLibrary()
    }))
    actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
      self.camera()
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    self.present(actionSheet, animated: true, completion: nil)
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    
    IBImageSelected.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
    
  }
  
  
  
}
