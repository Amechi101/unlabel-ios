//
//  ManageContentVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 01/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class ManageContentVC: UIViewController {
  
  @IBOutlet weak var IBSortButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var IBCollectionViewContent: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    IBCollectionViewContent.register(UINib(nibName: "ProductContentHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProductContentHeaderCell")
    IBCollectionViewContent.register(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func IBActionSortSelection(_ sender: Any) {
  }
  @IBAction func IBActionToggleStatus(_ sender: Any) {
  }
  
  @IBAction func IBActionViewRentalInfo(_ sender: AnyObject) {
    let rentalInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "RentalInfoVC")
    self.present(rentalInfoVC!, animated: true, completion: nil)
  }
  
}
//MARK:- UICollectionViewDataSource Methods
extension ManageContentVC: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    return getProductCell(forIndexPath: indexPath)
  }
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductCell{
    let productCell = IBCollectionViewContent.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductCell, for: indexPath) as! ProductCell
    productCell.IBlblProductName.text = "Armani Jeans"//arrProducts[indexPath.row - 3].ProductName
    productCell.IBlblProductPrice.text = "$ 120.0" //"$" + arrProducts[indexPath.row - 3].ProductPrice
    productCell.IBimgProductImage.contentMode = UIViewContentMode.scaleAspectFill;
    productCell.IBimgProductImage.image = UIImage(named: "Group")
    self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    
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
  
  func handleProductCellActivityIndicator(_ productCell:ProductCell,shouldStop:Bool){
    productCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      productCell.IBactivityIndicator.stopAnimating()
    }else{
      productCell.IBactivityIndicator.startAnimating()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    if nextPageURL?.characters.count == 0{
//      return CGSize.zero
//    }
//    else{
      return CGSize(width: collectionView.frame.width, height: 50.0)
//    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let headerView:ProductContentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductContentHeaderCell", for: indexPath) as! ProductContentHeader
      return headerView
    default:
      assert(false, "No such element")
      return UICollectionReusableView()
    }
  }
}
//MARK:- UICollectionViewDelegateFlowLayout Methods
extension ManageContentVC:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (collectionView.frame.size.width)/2.2, height: 271.0)
  }
}
