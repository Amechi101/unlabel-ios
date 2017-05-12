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
  
  //MARK: -  IBOutlets,vars,constants
  @IBOutlet var IBTextViewNote: UITextView!
  @IBOutlet weak var IBButtonUpdate: UIButton!
  @IBOutlet var views: UIView!
  var placeholderLabel : UILabel!
  var noteText : String = ""
  
  //MARK: -  View lifecycle methods
   override func viewDidLoad() {
    super.viewDidLoad()
    IBTextViewNote.delegate = self
    IBButtonUpdate.isHidden = true
    placeholderLabel = UILabel()
    placeholderLabel.text = "Start writing your Bio here..."
    placeholderLabel.font = UnlabelHelper.getNeutraface2Text(style: "Book", size: 16.0)
    placeholderLabel.sizeToFit()
    placeholderLabel.frame.origin = CGPoint(x: 5, y: (IBTextViewNote.font?.pointSize)! / 2)
    placeholderLabel.textColor = LIGHT_GRAY_TEXT_COLOR
    placeholderLabel.isHidden = !IBTextViewNote.text.isEmpty
    IBTextViewNote.addSubview(placeholderLabel)
    getInfluencerProfileBio()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  Custom methods
  func getInfluencerProfileBio() {
    UnlabelAPIHelper.sharedInstance.getInfluencerBio( self, success:{ (
      meta: JSON) in
      print(meta)
      DispatchQueue.main.async(execute: { () -> Void in
        self.IBTextViewNote.text = meta["bio"].stringValue
        self.placeholderLabel.isHidden = !self.IBTextViewNote.text.isEmpty
      })
    }, failed: { (error) in
    })
  }
  
  func getCSRFToken() -> String {
    if let xcsrf:String =  UnlabelHelper.getDefaultValue("X-CSRFToken")! as String{
      return xcsrf
    } else {
      return ""
    }
  }
  
  //MARK: -  IBAction methods
  @IBAction func IBActionChangeImage(_ sender: Any) {
  }
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    
    UnlabelAPIHelper.sharedInstance.saveInfluencerBio(self.IBTextViewNote.text ,onVC: self, success:{ (
      meta: JSON) in
      self.IBButtonUpdate.isHidden = true
      self.IBTextViewNote.resignFirstResponder()
    }, failed: { (error) in
    })
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: -  UITextView delegate methods
  func textViewDidBeginEditing(_ textView: UITextView) {
    IBTextViewNote.textColor = DARK_GRAY_COLOR
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    IBTextViewNote.textColor = LIGHT_GRAY_TEXT_COLOR
    if IBTextViewNote.text != "" {
      IBButtonUpdate.isHidden = false
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    self.placeholderLabel.isHidden = !textView.text.isEmpty
    if IBTextViewNote.text != "" {
      IBButtonUpdate.isHidden = false
      IBTextViewNote.textColor = DARK_GRAY_COLOR
    } else {
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
}
