//
//  RentOrLiveProductDetailVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 09/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage

class RentOrLiveProductDetailVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var productImageCollectionView: UICollectionView!
  @IBOutlet weak var productPageControl: UIPageControl!
  @IBOutlet weak var IBSelectSize: UIButton!
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBProductTitle: UILabel!
  @IBOutlet weak var IBProductPrice: UILabel!
  @IBOutlet weak var IBBtnProductDetail: UIButton!
  @IBOutlet weak var IBBtnProductImage: UIButton!
  @IBOutlet weak var IBBtnProductNote: UIButton!
  @IBOutlet weak var IBBtnProductStats: UIButton!
  @IBOutlet weak var IBBtnGoLive: UIButton!
  @IBOutlet weak var IBConstraintStatsHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintSelectSizeHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintGoLive: NSLayoutConstraint!
  @IBOutlet weak var IBScrollView: UIScrollView!
  @IBOutlet weak var IBViewStats: UIView!
  var contentStatus: ContentStatus = .unreserved
  var selectedProduct:Product?
  var productID: String?
  var selectedBrand:Brand?
  
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedProduct == nil {
      selectedProduct = Product()
    }
    
    
    if let brandName:String = selectedBrand?.Name{
      IBbtnTitle.setTitle(brandName.uppercased(), for: UIControlState())
      
    }
    IBScrollView.contentInset = UIEdgeInsetsMake(-64.0, 0.0, 0.0, 0.0)
    IBScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(-64.0, 0.0, 0.0, 0.0)
    if contentStatus == ContentStatus.live{
      IBConstraintGoLive.constant = 0.0
    }
    else if contentStatus == ContentStatus.rent{
      IBConstraintStatsHeight.constant = 0.0
      IBViewStats.isHidden = true
      IBConstraintSelectSizeHeight.constant = 0.0
    }
    
    print((selectedProduct?.arrProductsImages.count)!)
    setUpCollectionView()
    productPageControl.numberOfPages = (selectedProduct?.arrProductsImages.count)!
    productPageControl.currentPage = 0
    productID = selectedProduct?.ProductID
    IBProductTitle.text = selectedProduct?.ProductName
    IBProductPrice.text = "$ " + (selectedProduct?.ProductPrice)!

  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
  
  @IBAction func IBActionDismissView(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func IBActionGoLive(_ sender: Any) {
    self.addGoLivePopupView(CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionSelectSize(_ sender: Any) {
    self.addSortPopupView(SlideUpView.sizeSelection,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
}

//MARK: -  AddToCart Popup delegate methods

extension RentOrLiveProductDetailVC: GoLivePopupDelegate{
  
  func addGoLivePopupView(_ initialFrame:CGRect){
    if let viewForgotLabelPopup:GoLivePopupView = Bundle.main.loadNibNamed("GoLivePopupView", owner: self, options: nil)? [0] as? GoLivePopupView{
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
    //delegate method to be implemented after API integration
  }
  func popupDidClickGoLive(){
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: -  Size selection popup delegate methods

extension RentOrLiveProductDetailVC: SortModePopupViewDelegate{
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
    //delegate method to be implemented after API integration
  }
  func popupDidClickDone(_ sortMode: String){
    IBSelectSize.setTitle(sortMode, for: .normal)
  }
}

//MARK: -  Collection view methods

extension RentOrLiveProductDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
  
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
extension RentOrLiveProductDetailVC: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 392.0)
  }
}
