//
//  AddOrViewProductImageVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class AddOrViewProductImageVC: UIViewController {
  
  @IBOutlet weak var IBCollectionViewProductPhotos: UICollectionView!
  var iCount: Int = 5

  
    override func viewDidLoad() {
        super.viewDidLoad()
      setUpCollectionView()
      addNotFoundView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  fileprivate func addNotFoundView(){
    IBCollectionViewProductPhotos.backgroundView = nil
    let notFoundView:NotFoundView = Bundle.main.loadNibNamed("NotFoundView", owner: self, options: nil)! [0] as! NotFoundView
    notFoundView.delegate = self
    notFoundView.IBlblMessage.text = "Currently no photos."
    notFoundView.showViewLabelBtn = true
    IBCollectionViewProductPhotos.backgroundView = notFoundView
    IBCollectionViewProductPhotos.backgroundView?.isHidden = true
  }
  
  func setUpCollectionView(){
    IBCollectionViewProductPhotos.register(UINib(nibName: "ProductPhotoCell", bundle: nil), forCellWithReuseIdentifier: "ProductPhotoCell")
    IBCollectionViewProductPhotos.register(UINib(nibName: "ProductPhotoFooterCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ProductPhotoFooterCell")
  }
  @IBAction func IBActionRemovePhoto(_ sender: UIButton) {
   //print("button index \(sender.tag)")
  }
  @IBAction func IBActionDismiss(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func IBActionAddImage(_ sender: Any) {
    showActionSheet()
  }
  
  func showActionSheet(){
    let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let libraryAction: UIAlertAction = UIAlertAction(title: "Choose Photo", style: .default) { action -> Void in
      //Open photo library
      let imagePickerController = UIImagePickerController()
      imagePickerController.allowsEditing = false
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.delegate = self
      self.present(imagePickerController, animated: true, completion: nil)
    }
    let cameraAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
      //Open camera
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

}
extension AddOrViewProductImageVC: UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    if iCount > 0{
      IBCollectionViewProductPhotos.backgroundView?.isHidden = true
    }else{
      IBCollectionViewProductPhotos.backgroundView?.isHidden = false
    }

    return iCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    return getProductCell(forIndexPath: indexPath)
  }
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductPhotoCell{
    let productCell = IBCollectionViewProductPhotos.dequeueReusableCell(withReuseIdentifier: "ProductPhotoCell", for: indexPath) as! ProductPhotoCell
    productCell.IBButtonRemove.tag = indexPath.row
    productCell.IBProductImage.contentMode = UIViewContentMode.scaleAspectFill;
    productCell.IBProductImage.image = UIImage(named: "product_demo")
    self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    
    //***** To be done at API integration phase
    
    //    if let url = URL(string: arrProducts[indexPath.row - 3].arrProductsImages.first as! String){
    //
    //      productCell.IBimgProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
    //        if let _ = error{
    //          self.handleProductCellActivityIndicator(productCell, shouldStop: false)
    //        }else{
    //          if (type == SDImageCacheType.none)
    //          {
    //            productCell.IBimgProductImage.alpha = 0;
    //            UIView.animate(withDuration: 0.35, animations: {
    //              productCell.IBimgProductImage.alpha = 1;
    //            })
    //          }
    //          else
    //          {
    //            productCell.IBimgProductImage.alpha = 1;
    //          }
    //          self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    //        }
    //      })
    //    }
    return productCell
  }
  
  func handleProductCellActivityIndicator(_ productCell:ProductPhotoCell,shouldStop:Bool){
    productCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      productCell.IBactivityIndicator.stopAnimating()
    }else{
      productCell.IBactivityIndicator.startAnimating()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if iCount == 0{
      return CGSize.zero
    }
    else{
      return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
      
    case UICollectionElementKindSectionFooter:
      let footerView:ProductPhotoFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductPhotoFooterCell", for: indexPath) as! ProductPhotoFooterCell
      
      return footerView
      
    default:
      assert(false, "No such element")
      return UICollectionReusableView()
    }
  }
}
extension AddOrViewProductImageVC: NotFoundViewDelegate {
  
  func didSelectViewLabels() {
    showActionSheet()
  }
  
  func didSelectRegisterLogin() {
  }
  
  
}
extension AddOrViewProductImageVC: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width)/2.2, height: 271.0)
  }
}
extension AddOrViewProductImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismiss(animated: true, completion: nil)
  }
  
  internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
     print("Some \(image)")
    }
    else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      print("wrong \(image)")
    } else{
      print("Something went wrong")
    }
    
    self.dismiss(animated: true, completion: nil)  }
}
