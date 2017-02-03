//
//  ProductViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 06/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ProductViewController: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var productImageCollectionView: UICollectionView!
  @IBOutlet weak var productPageControl: UIPageControl!
  @IBOutlet weak var IBSelectSize: UIButton!
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBProductTitle: UILabel!
  @IBOutlet weak var IBProductPrice: UILabel!
  var selectedBrand:Brand?
  var selectedProduct:Product?
  var productID: String?
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if selectedProduct == nil {
      selectedProduct = Product()
    }
    setUpCollectionView()
    if let brandName:String = selectedBrand?.Name{
      IBbtnTitle.setTitle(brandName.uppercased(), for: UIControlState())
    }
    

    productPageControl.numberOfPages = (selectedProduct?.arrProductsImages.count)!
    productPageControl.currentPage = 0
    productID = selectedProduct?.ProductID
    IBProductTitle.text = selectedProduct?.ProductName
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == S_ID_PRODUCT_INFO_SEGUE{
      if let productInfoViewController:ProductInfoViewController = segue.destination as? ProductInfoViewController{
        productInfoViewController.selectedProduct = self.selectedProduct
      }
    }
  }
  
  //MARK: -  Custom methods
  
  func wsReserveProduct(){
    UnlabelAPIHelper.sharedInstance.reserveProduct(productID!, onVC: self, success:{ (
      meta: JSON) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      debugPrint(meta)
      if !(UnlabelHelper.getBoolValue(sPOPUP_SEEN_ONCE)){
        self.addLikeFollowPopupView(FollowType.productStatus, initialFrame:  CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        UnlabelHelper.setBoolValue(true, key: sPOPUP_SEEN_ONCE)
      }
      
    }, failed: { (error) in
    })
    
  }
  
  func setUpCollectionView(){
    productImageCollectionView.layoutMargins = UIEdgeInsets.zero
    productImageCollectionView.preservesSuperviewLayoutMargins = false
    
    productImageCollectionView.register(UINib(nibName: PRODUCT_IMAGE_CELL, bundle: nil), forCellWithReuseIdentifier:REUSABLE_ID_PRODUCT_IMAGE_CELL )
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 0.0
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 0.0
    self.automaticallyAdjustsScrollViewInsets = true
    
  }
  
  //MARK: -  IBAction methods
  
  @IBAction func IBActionSelectSize(_ sender: Any) {
    self.addSortPopupView(SlideUpView.sizeSelection,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func likeProductAction(_ sender: Any) {
    
    if UnlabelHelper.isUserLoggedIn(){
      self.addLikeFollowPopupView(FollowType.product,initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    }else{
      UnlabelHelper.showLoginAlert(self, title: S_LOGIN, message: S_MUST_LOGGED_IN, onCancel: {}, onSignIn: {
      })
    }
  }
  @IBAction func addToCartAction(_ sender: Any) {
    
    if UnlabelHelper.isUserLoggedIn(){
      self.addForgotPopupView(CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    }else{
      UnlabelHelper.showLoginAlert(self, title: S_LOGIN, message: S_MUST_LOGGED_IN, onCancel: {}, onSignIn: {
      })
    }
  }
  
  @IBAction func backAction(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}

//MARK: -  Collection view methods

extension ProductViewController:UICollectionViewDelegate,UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return (selectedProduct?.arrProductsImages.count)!
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_PRODUCT_IMAGE_CELL, for: indexPath) as! ProductImageCell
    print("cell\(productCell)")
    productCell.productImage.contentMode = UIViewContentMode.scaleAspectFill;
   // productCell.productImage.image = UIImage(named:"Katie_Lookbook")
    if let url = URL(string: selectedProduct?.arrProductsImages[indexPath.row] as! String){
      productCell.productImage.sd_setImage(with: url, completed:
        { (iimage, error, type, url) in
          
          if let _ = error{
          }else{
            if (type == SDImageCacheType.none)  {
              productCell.productImage.alpha = 0;
              UIView.animate(withDuration: 0.35, animations: {
                productCell.productImage.alpha = 1;
              })
            } else  {
              productCell.productImage.alpha = 1;
            }
          }
      })
    }

    return productCell
  }
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    productPageControl.currentPage = indexPath.row
  }
}
extension ProductViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 392.0)
  }
}

//MARK: -  AddToCart Popup delegate methods

extension ProductViewController:AddToCartViewDelegate{
  
  func addForgotPopupView(_ initialFrame:CGRect){
    if let viewForgotLabelPopup:AddToCartPopup = Bundle.main.loadNibNamed(ADD_TO_CART_POPUP, owner: self, options: nil)? [0] as? AddToCartPopup{
      viewForgotLabelPopup.delegate = self
      viewForgotLabelPopup.frame = initialFrame
      viewForgotLabelPopup.alpha = 0
      
      view.addSubview(viewForgotLabelPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewForgotLabelPopup.frame = self.view.frame
        viewForgotLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewForgotLabelPopup.alpha = 1
      })
    }
  }
  
  func popupDidClickCancel(){
    
  }
  func popupClickReserve(){
    
    UnlabelLoadingView.sharedInstance.start(self.view)
    wsReserveProduct()
  }
}

//MARK: -  Like/Follow popup delegate methods

extension ProductViewController:LikeFollowPopupviewDelegate{
  
  func addLikeFollowPopupView(_ followType:FollowType,initialFrame:CGRect){
    if let likeFollowPopup:LikeFollowPopup = Bundle.main.loadNibNamed(LIKE_FOLLOW_POPUP, owner: self, options: nil)? [0] as? LikeFollowPopup{
      likeFollowPopup.delegate = self
      likeFollowPopup.followType = followType
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
  
  func popupDidClickClosePopup(){
    debugPrint("close popup")
  }
}

//MARK: -  Size selection popup delegate methods

extension ProductViewController: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.popupTitle = "SELECT A SIZE"
      viewSortPopup.frame = initialFrame
      viewSortPopup.alpha = 0
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
    }
  }
  func popupDidClickCloseButton(){
    
  }
  func popupDidClickDone(_ sortMode: String){
    IBSelectSize.setTitle(sortMode, for: .normal)
  }
}
