//
//  RentOrLiveProductDetailVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 09/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

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
  @IBOutlet weak var IBBtnProductShare: UIButton!  
  @IBOutlet weak var IBBtnGoLive: UIButton!
  @IBOutlet weak var IBConstraintStatsHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintSelectSizeHeight: NSLayoutConstraint!
  @IBOutlet weak var IBConstraintGoLive: NSLayoutConstraint!
  @IBOutlet weak var IBScrollView: UIScrollView!
  @IBOutlet weak var IBViewStats: UIView!
  var productImage:UIImage?
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
      IBBtnProductShare.isHidden = false
      IBBtnProductImage.setTitle("View Images", for: .normal)
      IBBtnProductNote.setTitle("View Product Note", for: .normal)
      IBSelectSize.isUserInteractionEnabled = false
      IBSelectSize.setTitle(selectedProduct?.ProductsSize, for: .normal)
    }
    else if contentStatus == ContentStatus.rent{
      getProductNote()
      getProductImages()
      IBBtnProductShare.isHidden = true
      IBConstraintStatsHeight.constant = 0.0
      IBViewStats.isHidden = true
      IBConstraintSelectSizeHeight.constant = 0.0
      IBSelectSize.isUserInteractionEnabled = false
      IBSelectSize.setTitle(selectedProduct?.ProductsSize, for: .normal)
    }
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
  func getSizeList() -> [UnlabelStaticList]{
    var arrSize = [UnlabelStaticList]()
      for thisSize in (selectedProduct?.arrProductsSizes)!{
        let pSize = UnlabelStaticList(uId: "", uName: "",isSelected:false)
        pSize.uId = thisSize as! String
        pSize.uName = thisSize as! String
        arrSize.append(pSize)
      }
    return arrSize
  }
  func getProductImages() {
    UnlabelAPIHelper.sharedInstance.getProductImage((selectedProduct?.ProductID)! ,onVC: self, success:{ (arrImage:[ProductImages],
      meta: JSON) in
      self.IBBtnProductImage.setTitle("Update Images", for: .normal)
      
    }, failed: { (error) in
    })
  }
  func getProductNote() {
    UnlabelAPIHelper.sharedInstance.getProductNote((selectedProduct?.ProductID)! ,onVC: self, success:{ (
      meta: JSON) in
      print(meta)
      let productNote: String = meta["note"].stringValue
      if !productNote.isEmpty{
        self.IBBtnProductNote.setTitle("Update Product Note", for: .normal)
      }
    }, failed: { (error) in
    })
  }
  func wsGoLiveProduct(){
    UnlabelAPIHelper.sharedInstance.goLiveProduct((selectedProduct?.ProductID)!, onVC: self, success:{ (
      meta: JSON) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      debugPrint(meta)
      self.dismiss(animated: true, completion: nil)
    }, failed: { (error) in
    })
  }
  //MARK: -  IBAction methods
  
  @IBAction func IBActionDismissView(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func IBActionGoLive(_ sender: Any) {
    self.addGoLivePopupView(CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionSelectSize(_ sender: Any) {
  //  self.addSortPopupView(SlideUpView.sizeSelection,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddProductNote"{
      if let addProductNoteVC:AddProductNoteVC = segue.destination as? AddProductNoteVC{
        addProductNoteVC.selectedProduct = self.selectedProduct!
        addProductNoteVC.contentStatus = self.contentStatus
      }
    }
    else if segue.identifier == "AddProductImage"{
      if let addOrViewProductImageVC:AddOrViewProductImageVC = segue.destination as? AddOrViewProductImageVC{
        addOrViewProductImageVC.selectedProduct = self.selectedProduct!
        addOrViewProductImageVC.contentStatus = self.contentStatus
      }
    }
  }
  
  @IBAction func IBActionShare(_ sender: UIButton) {
    self.share(shareText: "Check out \(selectedProduct?.ProductName) on Unlabel. https://unlabel.us/", shareImage: productImage)
  }
  fileprivate func share(shareText:String?,shareImage:UIImage?){
    var objectsToShare = [AnyObject]()
    if let shareTextObj = shareText{
      objectsToShare.append(shareTextObj as AnyObject)
    }
    if let shareImageObj = shareImage{
      objectsToShare.append(shareImageObj)
    }
    if selectedProduct?.shareUrl?.absoluteString != ""{
      objectsToShare.append(selectedProduct?.shareUrl as AnyObject)
    }
    if shareText != nil || shareImage != nil || selectedProduct?.shareUrl?.absoluteString != ""{
      let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      
      present(activityViewController, animated: true, completion: nil)
    }else{
      debugPrint("There is nothing to share")
    }
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
    wsGoLiveProduct()
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
      viewSortPopup.arrDatasource = getSizeList()
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
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
    IBSelectSize.setTitle(selectedItem.uName, for: .normal)
  }
}

//MARK: -  Collection view methods

extension RentOrLiveProductDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return (selectedProduct?.arrProductsImages.count)!
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_PRODUCT_IMAGE_CELL, for: indexPath) as! ProductImageCell
    productCell.productImage.contentMode = UIViewContentMode.scaleAspectFill
    if let url = URL(string: selectedProduct?.arrProductsImages[indexPath.row] as! String){
      productCell.productImage.sd_setImage(with: url, completed:
        { (iimage, error, type, url) in
          if let _ = error{
          }else{
            self.productImage = iimage
            if (type == SDImageCacheType.none)  {
              productCell.productImage.alpha = 0
              UIView.animate(withDuration: 0.35, animations: {
                productCell.productImage.alpha = 1
              })
            } else  {
              productCell.productImage.alpha = 1
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
