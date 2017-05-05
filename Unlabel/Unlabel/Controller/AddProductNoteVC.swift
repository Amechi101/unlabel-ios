//
//  AddProductNoteVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 13/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddProductNoteVC: UIViewController , UITextViewDelegate {
  
  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet var IBTextViewNote : UITextView!
  @IBOutlet weak var IBButtonDone: UIButton!
  var placeholderLabel : UILabel!
  var selectedProduct: Product = Product()
  var contentStatus: ContentStatus = .rent
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getProductNote()
    IBButtonDone.isHidden = IBTextViewNote.text.isEmpty
    IBButtonDone.isHidden = true
    IBTextViewNote.delegate = self
    placeholderLabel = UILabel()
    placeholderLabel.text = "Start writing here…"
    placeholderLabel.font = UnlabelHelper.getNeutraface2Text(style: "Book", size: 16.0)
    placeholderLabel.sizeToFit()
    placeholderLabel.frame.origin = CGPoint(x: 5, y: (IBTextViewNote.font?.pointSize)! / 2)
    placeholderLabel.textColor = LIGHT_GRAY_TEXT_COLOR
    placeholderLabel.isHidden = !IBTextViewNote.text.isEmpty
    IBTextViewNote.addSubview(placeholderLabel)
    IBTextViewNote.becomeFirstResponder()
    if contentStatus == ContentStatus.live {
      placeholderLabel.isHidden = true
      IBTextViewNote.isUserInteractionEnabled = false
      IBTextViewNote.resignFirstResponder()
      IBTextViewNote.isEditable = false
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//MARK:- Custom Methods

extension AddProductNoteVC {
  
  func getProductNote() {
    UnlabelAPIHelper.sharedInstance.getProductNote(selectedProduct.ProductID ,onVC: self, success:{ (
      meta: JSON) in
      self.IBTextViewNote.text = meta["note"].stringValue
      self.placeholderLabel.isHidden = !self.IBTextViewNote.text.isEmpty
    }, failed: { (error) in
    })
  }
  
  func saveProductNote() {
    UnlabelAPIHelper.sharedInstance.saveProductNote(selectedProduct.ProductID,note: self.IBTextViewNote.text ,onVC: self, success:{ (
      meta: JSON) in
      self.IBButtonDone.isHidden = true
    }, failed: { (error) in
    })
  }
}

//MARK:- IBAction Methods

extension AddProductNoteVC {
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionDone(_ sender: Any) {
    IBTextViewNote.resignFirstResponder()
    IBTextViewNote.textColor = LIGHT_GRAY_TEXT_COLOR
    saveProductNote()
  }
}

//MARK:- UITextField delegate Methods

extension AddProductNoteVC {
  
  func textViewDidBeginEditing(_ textView: UITextView){
    IBTextViewNote.textColor = DARK_GRAY_COLOR
    IBButtonDone.isHidden = IBTextViewNote.text.isEmpty
  }
  
  func textViewDidEndEditing(_ textView: UITextView){
    IBTextViewNote.textColor = LIGHT_GRAY_TEXT_COLOR
  }
  
  func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
    IBButtonDone.isHidden = IBTextViewNote.text.isEmpty
  }
}
