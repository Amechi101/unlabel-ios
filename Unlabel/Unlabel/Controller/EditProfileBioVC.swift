//
//  EditProfileBioVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class EditProfileBioVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
  
  @IBOutlet var IBImageSelected: UIImageView!
  @IBOutlet var IBTextViewNote: UITextView!
  @IBOutlet weak var IBButtonUpdate: UIButton!
  
  @IBOutlet var views: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    IBTextViewNote.delegate = self
    IBButtonUpdate.isHidden = true
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func IBActionChangeImage(_ sender: Any) {
    showActionSheet()
  }
  @IBAction func IBActionUpdate(_ sender: Any) {
    
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
