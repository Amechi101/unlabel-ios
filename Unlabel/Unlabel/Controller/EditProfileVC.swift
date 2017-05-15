//
//  EditProfileVC.swift
//  Unlabel
//
//  Created by Ravisankar V on 19/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SwiftyJSON
import Alamofire

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBTextfieldFullname: UITextField!
  @IBOutlet weak var IBLabelFullname: UILabel!
  @IBOutlet weak var IBViewfullname: UIView!
  @IBOutlet weak var IBLabelLastname: UILabel!
  @IBOutlet weak var IBtextfieldLastname: UITextField!
  @IBOutlet weak var IBViewLastname: UIView!
  @IBOutlet weak var IBLabelEmail: UILabel!
  @IBOutlet weak var IBtextfieldEmail: UITextField!
  @IBOutlet weak var IBViewEmail: UIView!
  @IBOutlet weak var IBTextfieldContactNumber: UITextField!
  @IBOutlet weak var IBTextfieldUsername: UITextField!
  @IBOutlet weak var IBProfileImage: UIImageView!
  @IBOutlet weak var IBInfluencerKind: UIButton!
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.IBProfileImage.contentMode = .scaleToFill
    self.IBProfileImage.layer.cornerRadius = self.IBProfileImage.bounds.size.width/2
    self.IBProfileImage.clipsToBounds = true
    getInfluencerProfileInfo()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionUpdate(_ sender: Any) {
    if !isValidEmail() {
      // shows alert in isValidEmail() method
    } else if (IBTextfieldFullname.text?.isEmpty)! || (IBtextfieldLastname.text?.isEmpty)! || (IBTextfieldContactNumber.text?.isEmpty)! {
      UnlabelHelper.showAlert(onVC: self, title: "Empty Input", message: "Please provide value for all field.", onOk: {})
    } else {
      saveInfluencerProfileInfo()
    }
//     self.addLikeFollowPopupView(FollowType.profileUpdate, initialFrame:  CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  
  @IBAction func IBActionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionChangeImage(_ sender: Any) {
    showActionSheet()
  }
  
  @IBAction func IBActionSelectSpecialization(_ sender: Any) {
    self.addSortPopupView(SlideUpView.influencerKind,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  
  //MARK: -  Custom methods
  
  func getInfluencerProfileInfo() {
    UnlabelAPIHelper.sharedInstance.getProfileInfo( self, success:{ (
      meta: JSON) in
      print(meta)
      DispatchQueue.main.async(execute: { () -> Void in
        self.IBTextfieldFullname.text = meta["first_name"].stringValue
        self.IBtextfieldLastname.text = meta["last_name"].stringValue
        self.IBtextfieldEmail.text = meta["email"].stringValue
        self.IBTextfieldContactNumber.text = meta["contact_number"].stringValue
        
        if meta["influencer_industry"].null != NSNull(){
          self.IBInfluencerKind.setTitle(meta["influencer_industry"].stringValue, for: .normal)
        }
        if meta["image"].null != NSNull(){
          self.IBProfileImage.sd_setImage(with: URL(string: meta["image"].stringValue))
        }
        if meta["ucc_handle"].null != NSNull(){
          self.IBTextfieldUsername.text = meta["ucc_handle"].stringValue
        }
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
  
  func saveInfluencerProfileInfo() {
    let userParam = User()
    userParam.firstname = IBTextfieldFullname.text!
    userParam.lastname = IBtextfieldLastname.text!
    userParam.email = IBtextfieldEmail.text!
    userParam.username = IBTextfieldUsername.text!
    userParam.contactNumber = IBTextfieldContactNumber.text!
    userParam.iccIndustry = (IBInfluencerKind.titleLabel?.text)!
    let imageName: String =  UnlabelHelper.getcurrentDateTime() + ".jpeg"
    let parameters = ["image": imageName,"contact_number": userParam.contactNumber,"email": userParam.email,"first_name": userParam.firstname,"last_name": userParam.lastname,"influencer_industry": userParam.iccIndustry,"ucc_handle":userParam.username]
    let image = IBProfileImage.image
    Alamofire.upload(multipartFormData: {
      multipartFormData in
      if let imageData = UIImageJPEGRepresentation(image!, 0.6) {
        multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
      }
      for (key, value) in parameters {
        multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
      }
    }, usingThreshold: UInt64.init() , to: v4BaseUrl + "api_v2/influencer_profile_update/", method: .post, headers: ["X-CSRFToken":getCSRFToken()], encodingCompletion: {
      encodingResult in
      switch encodingResult {
      case .success(let upload, _, _):
        upload.responseJSON {
          response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            print("json: \(json)")
            _ = self.navigationController?.popViewController(animated: true)
          case .failure(let error):
            print("error: \(error.localizedDescription)")
          }
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    })

  }
  
  func getUccAvailability() {
    UnlabelAPIHelper.sharedInstance.getUccAvailability( self.IBTextfieldUsername.text!, success:{ (
      meta: JSON,statusCode:Int) in
      print(meta,statusCode)
      if statusCode == 409 {
        UnlabelHelper.showAlert(onVC: self, title: "Already in Use", message: "Please select another UCC handle ", onOk: {})
      }
    }, failed: { (error) in
    })
  }

  //MARK: -  Image picker view methods
  
  func camera() {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerControllerSourceType.camera
    self.present(myPickerController, animated: true, completion: nil)
  }
  
  func photoLibrary() {
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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    IBProfileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: -  UITextfield delegate methods

extension EditProfileVC: UITextFieldDelegate {
  
  fileprivate func isValidEmail()->Bool {
    if let email = IBtextfieldEmail.text, email.characters.count > 0 {
      if UnlabelHelper.isValidEmail(IBtextfieldEmail.text!) {
        if let email = IBtextfieldEmail.text, email.characters.count > 30 {
          UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Email must be less than 30 characters", onOk: { () -> () in })
          
          return false
        }else{
         
          return true
        }
      } else {
        UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "This email address doesn’t look quite right", onOk: { () -> () in })
        
        return false
      }
    } else {
      UnlabelHelper.showAlert(onVC: self, title: "Email Error", message: "Please provide your email to proceed", onOk: { () -> () in })
     
      return false
    }
  }
  func textFieldDidEndEditing(_ textField: UITextField){
    if textField == IBTextfieldUsername {
      getUccAvailability()
    }
  }
}

//MARK: Sort Popup methods

extension EditProfileVC: SortModePopupViewDelegate {
  
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect) {
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView {
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SELECT INDUSTRY"
      viewSortPopup.alpha = 0
      APP_DELEGATE.window?.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
    }
  }
  
  func popupDidClickCloseButton() {
  }
  
  func popupDidClickDone(_ selectedItem: UnlabelStaticList) {
    IBInfluencerKind.setTitle(selectedItem.uName, for: .normal)
  }
}
//MARK: -  Like/Follow popup delegate methods

extension EditProfileVC: LikeFollowPopupviewDelegate {
  
  func addLikeFollowPopupView(_ followType:FollowType,initialFrame:CGRect) {
    if let likeFollowPopup:LikeFollowPopup = Bundle.main.loadNibNamed(LIKE_FOLLOW_POPUP, owner: self, options: nil)? [0] as? LikeFollowPopup {
      likeFollowPopup.delegate = self
      likeFollowPopup.followType = followType
      likeFollowPopup.productStatusMessage = "You have successfully updated your Profile."
      likeFollowPopup.frame = initialFrame
      likeFollowPopup.alpha = 0
      APP_DELEGATE.window?.addSubview(likeFollowPopup)
      UIView.animate(withDuration: 0.2, animations: {
        likeFollowPopup.frame = self.view.frame
        likeFollowPopup.frame.origin = CGPoint(x: 0, y: 0)
        likeFollowPopup.alpha = 1
      })
      likeFollowPopup.updateView()
    }
  }
  
  func popupDidClickClosePopup() {
     _ = self.navigationController?.popViewController(animated: true)
  }
}

