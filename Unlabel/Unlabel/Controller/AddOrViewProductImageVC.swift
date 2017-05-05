//
//  AddOrViewProductImageVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class AddOrViewProductImageVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBCollectionViewProductPhotos: UICollectionView!
  var selectedProduct: Product = Product()
  var productImageArray: [ProductImages] = [ProductImages]()
  var contentStatus: ContentStatus = .rent
  var displayOrder: String = String()
  fileprivate let fFooterHeight:CGFloat = 40.0
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    addNotFoundView()
    getProductImages()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  Custom methods
  
  func getProductImages() {
    self.productImageArray = []
    UnlabelAPIHelper.sharedInstance.getProductImage(selectedProduct.ProductID ,onVC: self, success:{ (arrImage:[ProductImages],
      meta: JSON) in
      self.productImageArray.append(contentsOf: arrImage)
      self.IBCollectionViewProductPhotos.reloadData()
    }, failed: { (error) in
    })
  }
  
  func removeProductImages() {
    let productImage : ProductImages = ProductImages()
    productImage.pProduct = selectedProduct.ProductID
    productImage.pDisplayOrder = displayOrder
    UnlabelAPIHelper.sharedInstance.removeProductPhot(productImage ,onVC: self, success:{(meta: JSON) in
      self.getProductImages()
      self.IBCollectionViewProductPhotos.reloadData()
    }, failed: { (error) in
    })
  }
  
  func saveProfileImage(_ pickedImage: UIImage) {
    let imageName: String = selectedProduct.ProductName + UnlabelHelper.getcurrentDateTime() + ".jpeg"
    let parameters = [
      "image": imageName,"note": selectedProduct.ProductID
    ]
    Alamofire.upload(multipartFormData: {
      multipartFormData in
      if let imageData = UIImageJPEGRepresentation(pickedImage, 0.6) {
        multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
      }
      for (key, value) in parameters {
        multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
      }
    }, usingThreshold: UInt64.init() , to: v4BaseUrl + "api_v2/influencer_add_product_images/", method: .post, headers: ["X-CSRFToken":getCSRFToken()], encodingCompletion: {
      encodingResult in
      switch encodingResult {
      case .success(let upload, _, _):
        upload.responseJSON {
          response in
          switch response.result {
          case .success(let data):
          //  let json = JSON(data)
            self.getProductImages()
          case .failure(let error):
            print("error: \(error.localizedDescription)")
          }
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    })
  }
  
  func getCSRFToken() -> String {
    if let xcsrf:String =  UnlabelHelper.getDefaultValue("X-CSRFToken")! as String {
      
      return xcsrf
    } else {
      
      return ""
    }
  }
  
  fileprivate func addNotFoundView() {
    IBCollectionViewProductPhotos.backgroundView = nil
    let notFoundView:NotFoundView = Bundle.main.loadNibNamed("NotFoundView", owner: self, options: nil)! [0] as! NotFoundView
    notFoundView.delegate = self
    notFoundView.IBlblMessage.text = "Currently no photos."
    if contentStatus == ContentStatus.live {
      notFoundView.showViewLabelBtn = false
    } else {
      notFoundView.showViewLabelBtn = true
    }
    IBCollectionViewProductPhotos.backgroundView = notFoundView
    IBCollectionViewProductPhotos.backgroundView?.isHidden = true
  }
  
  func setUpCollectionView() {
    IBCollectionViewProductPhotos.register(UINib(nibName: "ProductPhotoCell", bundle: nil), forCellWithReuseIdentifier: "ProductPhotoCell")
    IBCollectionViewProductPhotos.register(UINib(nibName: "ProductPhotoFooterCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ProductPhotoFooterCell")
  }
  
  func showActionSheet() {
    let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let libraryAction: UIAlertAction = UIAlertAction(title: "Choose Photo", style: .default) { action -> Void in
      let imagePickerController = UIImagePickerController()
      imagePickerController.allowsEditing = false
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.delegate = self
      self.present(imagePickerController, animated: true, completion: nil)
    }
    let cameraAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
      let imagePickerController = UIImagePickerController()
      imagePickerController.allowsEditing = false
      imagePickerController.sourceType = .camera
      imagePickerController.delegate = self
      self.present(imagePickerController, animated: true, completion: nil)
    }
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
      //Dismiss the action sheet
    }
    actionSheetController.addAction(libraryAction)
    actionSheetController.addAction(cameraAction)
    actionSheetController.addAction(cancelAction)
    self.present(actionSheetController, animated: true, completion: nil)
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionRemovePhoto(_ sender: UIButton) {
    let product: ProductImages = productImageArray[sender.tag]
    displayOrder = product.pDisplayOrder
    removeProductImages()
  }
  
  @IBAction func IBActionDismiss(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionAddImage(_ sender: Any) {
    showActionSheet()
  }
}

//MARK: -  Collection delegate methods

extension AddOrViewProductImageVC: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if productImageArray.count > 0 {
      IBCollectionViewProductPhotos.backgroundView?.isHidden = true
    } else {
      IBCollectionViewProductPhotos.backgroundView?.isHidden = false
    }
    
    return productImageArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return getProductCell(forIndexPath: indexPath)
  }
  
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductPhotoCell {
    let productCell = IBCollectionViewProductPhotos.dequeueReusableCell(withReuseIdentifier: "ProductPhotoCell", for: indexPath) as! ProductPhotoCell
    productCell.IBButtonRemove.tag = indexPath.row
    
    if contentStatus == ContentStatus.live {
      productCell.IBVireRemoveContainer.isHidden = true
    } else {
      productCell.IBVireRemoveContainer.isHidden = false
    }
    let productImage: ProductImages = self.productImageArray[indexPath.row]
    productCell.IBProductImage.contentMode = UIViewContentMode.scaleAspectFill;
    productCell.IBProductImage.clipsToBounds = true
    self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    if let url = URL(string: productImage.pImageUrl ) {
      productCell.IBProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
        if let _ = error {
          self.handleProductCellActivityIndicator(productCell, shouldStop: false)
        } else {
          if (type == SDImageCacheType.none) {
            productCell.IBProductImage.alpha = 0;
            UIView.animate(withDuration: 0.35, animations: {
              productCell.IBProductImage.alpha = 1;
            })
          } else {
            productCell.IBProductImage.alpha = 1;
          }
          self.handleProductCellActivityIndicator(productCell, shouldStop: true)
        }
      })
    }
    
    return productCell
  }
  
  func handleProductCellActivityIndicator(_ productCell:ProductPhotoCell,shouldStop:Bool) {
    productCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      productCell.IBactivityIndicator.stopAnimating()
    } else {
      productCell.IBactivityIndicator.startAnimating()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if productImageArray.count == 0 {
      
      return CGSize.zero
    } else {
      if contentStatus == ContentStatus.live {
        
        return CGSize.zero
      } else {
        print(collectionView.frame.width)
        print(collectionView.frame.size.width)
        print(SCREEN_WIDTH)
        
        return CGSize(width: SCREEN_WIDTH, height: fFooterHeight)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionFooter:
      if contentStatus == ContentStatus.live {
        
        return UICollectionReusableView()
      } else {
        let footerView:ProductPhotoFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductPhotoFooterCell", for: indexPath) as! ProductPhotoFooterCell
        
        return footerView
      }
    default:
      assert(false, "No such element")
      
      return UICollectionReusableView()
    }
  }
}

extension AddOrViewProductImageVC: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width)/2.2, height: 271.0)
  }
}

//MARK: -  NotFound delegate methods

extension AddOrViewProductImageVC: NotFoundViewDelegate {
  
  func didSelectViewLabels() {
    showActionSheet()
  }
  
}

//MARK: -  Image picker delegate methods

extension AddOrViewProductImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismiss(animated: true, completion: nil)
  }
  
  internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      saveProfileImage(image)
    } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      saveProfileImage(image)
    }
    self.dismiss(animated: true, completion: nil)
  }
}
