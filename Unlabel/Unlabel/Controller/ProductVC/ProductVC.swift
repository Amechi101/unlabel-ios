//
//  ProductVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import SwiftyJSON

protocol ProductVCDelegate {
  func didClickFollow(forBrand brand:Brand)
}
class ProductVC: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  @IBOutlet weak var IBbtnTitle: UIButton!
  @IBOutlet weak var IBcollectionViewProduct: UICollectionView!
  let fFooterHeight:CGFloat = 81.0
  var activityIndicator:UIActivityIndicatorView?
  var selectedBrand: Brand!
  var delegate:ProductVCDelegate?
  var headerViewImage:UIImage?
  var arrProducts = [Product]()
  var selectedSizeProduct = [Product]()
  var selectedProduct: Product!
  var isProfileCompleted: Bool = false
  var sortMode: String = "NEW"
  var sortModeValue: String = "Date: Newest to Oldest"
  var nextPageURL:String?
  var labelHeight: CGFloat = 0.0
  var displayMode: String = String()
  var selectedGender: String = String()
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedBrand == nil {
      selectedBrand = Brand()
    }
    setupOnLoad()
    nextPageURL = nil
    getProductsOfBrand()
  }
  override func viewWillAppear(_ animated: Bool) {
    UnlabelHelper.setAppDelegateDelegates(self)
    if let _ = self.navigationController{
      navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    IBcollectionViewProduct.reloadData()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func IBActionSeeMore(_ sender: Any) {
    self.performSegue(withIdentifier: "SeeMoreDescription", sender: self)
  }
}

//MARK:- AppDelegateDelegates Methods

extension ProductVC:AppDelegateDelegates{
  func reachabilityChanged(_ reachable: Bool) {
    debugPrint("reachabilityChanged : \(reachable)")
  }
}

//MARK:- UICollectionViewDelegate Methods

extension ProductVC:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
    }
    else {
      if isProfileCompleted{
        self.selectedProduct = self.arrProducts[indexPath.row - 3]
        print(selectedProduct.ProductID)
        UnlabelAPIHelper.sharedInstance.getSizeProduct(selectedProduct.ProductID, success: { (sizeProduct:[Product], meta: JSON) in
          self.selectedSizeProduct = sizeProduct
          self.performSegue(withIdentifier: "ProductDetailSegue", sender: self)
          
        }, failed: { (error) in
        })
      }
      else{
        self.addLikeFollowPopupView(FollowType.profileIncomplete,initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
      }
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if nextPageURL?.characters.count == 0{
      return CGSize.zero
    }
    else{
      return CGSize(width: collectionView.frame.width, height: fFooterHeight)
    }
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionFooter:
      let footerView:ProductFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: REUSABLE_ID_ProductFooterView, for: indexPath) as! ProductFooterView
      return footerView
    default:
      assert(false, "No such element")
      return UICollectionReusableView()
    }
  }
}

//MARK:- UICollectionViewDataSource Methods
extension ProductVC:UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return arrProducts.count + 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    if indexPath.row == 0{
      return getProductHeaderCell(forIndexPath: indexPath)
    }else if indexPath.row == 1{
      return getProductDescCell(forIndexPath: indexPath)
    }else if indexPath.row == 2{
      return getProductSortCell(forIndexPath: indexPath)
    }
    else{
      return getProductCell(forIndexPath: indexPath)
    }
  }
  
  //Custom methods
  func getProductHeaderCell(forIndexPath indexPath:IndexPath)->ProductHeaderCell{
    let productHeaderCell = IBcollectionViewProduct.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductHeaderCell, for: indexPath) as! ProductHeaderCell
    productHeaderCell.IBBrandDescription.text = selectedBrand.Description
    print(productHeaderCell.IBBrandDescription.intrinsicContentSize.height)
    print(productHeaderCell.IBBrandDescription.bounds.height)
    if productHeaderCell.IBBrandDescription.intrinsicContentSize.height > productHeaderCell.IBBrandDescription.bounds.height{
      productHeaderCell.IBbtnSeeMore.isHidden = false
    }
    else{
      productHeaderCell.IBbtnSeeMore.isHidden = true
    }
    productHeaderCell.IBBrandLocation.text = selectedBrand.city + ", " + selectedBrand.location
    updateFollowButton(productHeaderCell.IBbtnFollow, isFollowing: selectedBrand.isFollowing)
    if let url = URL(string: selectedBrand.FeatureImage){
      productHeaderCell.IBimgHeaderImage.sd_setImage(with: url, completed:
        { (iimage, error, type, url) in
          
          if let _ = error{
          }else{
            self.headerViewImage = iimage
            if (type == SDImageCacheType.none)  {
              productHeaderCell.IBimgHeaderImage.alpha = 0;
              UIView.animate(withDuration: 0.35, animations: {
                productHeaderCell.IBimgHeaderImage.alpha = 1;
              })
            } else  {
              productHeaderCell.IBimgHeaderImage.alpha = 1;
            }
          }
      })
    }
    productHeaderCell.contentView.backgroundColor = .red
    return productHeaderCell
  }
  func getProductSortCell(forIndexPath indexPath:IndexPath)->ProductSortCell{
    let productSortCell = IBcollectionViewProduct.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductSortCell, for: indexPath) as! ProductSortCell
    productSortCell.IBSortModeSelection.addTarget(self, action: #selector(showSortPopup), for: .touchUpInside)
    productSortCell.IBSortModeSelection.setTitle("Sort By: "+sortModeValue, for: .normal)
    return productSortCell
  }
  func showSortPopup(){
    self.addSortPopupView(SlideUpView.sortMode,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  func getProductDescCell(forIndexPath indexPath:IndexPath)->ProductDescCell{
    let productDescCell = IBcollectionViewProduct.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductDescCell, for: indexPath) as! ProductDescCell
    if arrProducts.count == 0{
      productDescCell.IBlblDesc.text = selectedBrand.Name+" has no more products to rent from at this moment."
    }
    else{
      productDescCell.IBlblDesc.text = ""
    }
    return productDescCell
  }
  
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductCell{
    let productCell = IBcollectionViewProduct.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductCell, for: indexPath) as! ProductCell
    productCell.IBlblProductName.text = arrProducts[indexPath.row - 3].ProductName
    productCell.IBlblProductPrice.text = "$" + arrProducts[indexPath.row - 3].ProductPrice
    productCell.IBimgProductImage.contentMode = UIViewContentMode.scaleAspectFill;
    productCell.IBimgProductImage.clipsToBounds = true
    if arrProducts[indexPath.row - 3].arrProductsImages.count > 0{
      if let url = URL(string: arrProducts[indexPath.row - 3].arrProductsImages.first as! String){
        productCell.IBimgProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
          if let _ = error{
            self.handleProductCellActivityIndicator(productCell, shouldStop: false)
          }else{
            if (type == SDImageCacheType.none){
              productCell.IBimgProductImage.alpha = 0;
              UIView.animate(withDuration: 0.35, animations: {
                productCell.IBimgProductImage.alpha = 1;
              })
            }
            else{
              productCell.IBimgProductImage.alpha = 1;
            }
            self.handleProductCellActivityIndicator(productCell, shouldStop: true)
          }
        })
      }
    }
    else{
      productCell.IBimgProductImage.sd_setImage(with: nil, placeholderImage: UIImage(named: "Group"))
      self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    }
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
  
}


//MARK:- UICollectionViewDelegateFlowLayout Methods

extension ProductVC:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.row == 0{
      return CGSize(width: CGFloat(collectionView.frame.size.width), height: CGFloat(314.0))
    }else if indexPath.row == 1{
      if arrProducts.count == 0{
        return CGSize(width: (collectionView.frame.size.width)-5.5, height: 210.0)
      }
      else{
        return CGSize.zero
      }
    }else if indexPath.row == 2{
      if arrProducts.count == 0{
        return CGSize.zero
      }
      else{
        return CGSize(width: (collectionView.frame.size.width)-5.5, height: 60.0)
      }
    }
    else{
      return CGSize(width: (collectionView.frame.size.width)/2.08, height: 260.0)
    }
  }
}


//MARK:- Navigation Methods

extension ProductVC{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == S_ID_PRODUCT_DETAIL_WEBVIEW_VC{
      if let productDetailWVVC:ProductDetailsWebViewVC = segue.destination as? ProductDetailsWebViewVC{
        productDetailWVVC.selectedBrand = self.selectedBrand
        //Google analytics
        
        //GAHelper.trackEvent(GAEventType.ProductClicked, labelName: selectedBrand.Name, productName:product.ProductName, buyProductName: nil)
        //                    }
      }
    }else if segue.identifier == S_ID_ABOUT_LABEL_VC{
      if let aboutLabelVC:AboutLabelVC = segue.destination as? AboutLabelVC{
        aboutLabelVC.selectedBrand = selectedBrand
      }
    }
    else if segue.identifier == "ProductDetailSegue"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController{
        if let productViewController:ProductViewController = navViewController.viewControllers[0] as? ProductViewController{
          productViewController.selectedBrand = selectedBrand
          productViewController.selectedProduct = self.selectedProduct
          productViewController.selectedSizeProduct = self.selectedSizeProduct
        }
      }
    }
    else if segue.identifier == "SeeMoreDescription"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController{
        if let seeMoreDescriptionVC:SeeMoreDescriptionVC = navViewController.viewControllers[0] as? SeeMoreDescriptionVC{
          seeMoreDescriptionVC.selectedBrand = selectedBrand
        }
      }
    }
  }
}


//MARK:- ViewFollowingLabelPopup Methods

extension ProductVC:PopupviewDelegate{
  
  func addPopupView(_ popupType:PopupType,initialFrame:CGRect){
    let viewFollowingLabelPopup:ViewFollowingLabelPopup = Bundle.main.loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil)! [0] as! ViewFollowingLabelPopup
    viewFollowingLabelPopup.delegate = self
    viewFollowingLabelPopup.popupType = popupType
    viewFollowingLabelPopup.frame = initialFrame
    viewFollowingLabelPopup.alpha = 0
    view.addSubview(viewFollowingLabelPopup)
    UIView.animate(withDuration: 0.2, animations: {
      viewFollowingLabelPopup.frame = self.view.frame
      viewFollowingLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
      viewFollowingLabelPopup.alpha = 1
    })
//    if popupType == PopupType.follow{
//      viewFollowingLabelPopup.setFollowSubTitle("Brand")
//    }
    viewFollowingLabelPopup.updateView()
  }
  
  func popupDidClickCancel(){
    
  }
  
  func popupDidClickDelete(){
    debugPrint("delete account")
  }
  
  func popupDidClickClose(){
    
  }
}



//MARK:- IBAction Methods
extension ProductVC{
  
  @IBAction func unwindToProductViewController(_ segue: UIStoryboardSegue) {
    if segue.identifier == "unwindToProductViewController" {
      let productDetail = segue.source as! ProductDetailsWebViewVC
      self.selectedBrand = productDetail.selectedBrand!
      let headerCellIndexPath = IndexPath(item: 0, section: 0)
      IBcollectionViewProduct.reloadItems(at: [ headerCellIndexPath ])
    }
  }
  
  @IBAction func IBActionBack(_ sender: UIButton) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func IBActionFilter(_ sender: UIBarButtonItem) {
    //        openFilterScreen()
  }
  
  //For ProductFooterView
  @IBAction func IBActionViewMore(_ sender: AnyObject) {
    getProductsOfBrand()
   // debugPrint("IBActionViewMore")
  }
  
  @IBAction func IBActionFollow(_ sender: UIButton) {
    //Internet available
    if ReachabilitySwift.isConnectedToNetwork(){
      selectedBrand.isFollowing = !selectedBrand.isFollowing
      updateFollowButton(sender, isFollowing: selectedBrand.isFollowing)
      UnlabelAPIHelper.sharedInstance.followBrand(selectedBrand.ID, onVC: self, success:{ (
        meta: JSON) in
        if !(UnlabelHelper.getBoolValue(sFOLLOW_SEEN_ONCE)){
          self.addLikeFollowPopupView(FollowType.brand,initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
          UnlabelHelper.setBoolValue(true, key: sFOLLOW_SEEN_ONCE)
        }
        debugPrint(meta)
        
      }, failed: { (error) in
      })
      
    }else{
      UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
    }
  }
  @IBAction func IBActionShare(_ sender: UIButton) {
    self.share(shareText: "Check out \(selectedBrand.Name) on Unlabel. https://unlabel.us/", shareImage: headerViewImage)
  }
  
  //  @IBAction func IBActionViewProducts(_ sender: AnyObject) {
  //  }
  //
}

//MARK: Sort Popup methods

extension ProductVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SORT BY"
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
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
  //  print(sortMode)
    sortModeValue = selectedItem.uName
    arrProducts = []
    nextPageURL = nil
    IBcollectionViewProduct.reloadData()
    self.sortMode = selectedItem.uId
    getProductsOfBrand()
  }
}

//MARK:- UIGestureRecognizerDelegate Methods

extension ProductVC:UIGestureRecognizerDelegate{
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let navVC = navigationController{
      if navVC.viewControllers.count > 1{
        return true
      }else{
        return false
      }
    }else{
      return false
    }
  }
}


//MARK:- Custom and SFSafariViewControllerDelegate Methods

extension ProductVC:SFSafariViewControllerDelegate,UIViewControllerTransitioningDelegate{
  func openSafariForURL(_ urlString:String){
    if let productURL:URL = URL(string: urlString){
      APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
      let safariVC = UnlabelSafariVC(url: productURL)
      safariVC.delegate = self
      safariVC.transitioningDelegate = self
      self.present(safariVC, animated: true) { () -> Void in
        
      }
    }else{ showAlertWebPageNotAvailable() }
  }
  
  func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity]{
    return []
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController){
    APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
  }
  
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
    
  }
}

//MARK: - Product status Popup view Delegate

extension ProductVC: LikeFollowPopupviewDelegate{
  
  func addLikeFollowPopupView(_ followType:FollowType,initialFrame:CGRect){
    if let likeFollowPopup:LikeFollowPopup = Bundle.main.loadNibNamed(LIKE_FOLLOW_POPUP, owner: self, options: nil)? [0] as? LikeFollowPopup{
      likeFollowPopup.delegate = self
      likeFollowPopup.followType = followType
      likeFollowPopup.frame = initialFrame
      likeFollowPopup.alpha = 0
      view.addSubview(likeFollowPopup)
      UIView.animate(withDuration: 0.2, animations: {
        likeFollowPopup.frame = self.view.frame
        likeFollowPopup.frame.origin = CGPoint(x: 0, y: 0)
        likeFollowPopup.alpha = 1
        likeFollowPopup.updateView()
      })
      //  likeFollowPopup.updateView()
    }
  }
  
  func popupDidClickClosePopup(){
    debugPrint("close popup")
  }
}

//MARK:- Custom Methods

extension ProductVC{
  
  
  func getProductsOfBrand(){
    var nextPage:String?
    
    if let next:String = nextPage, next.characters.count == 0 {
      self.arrProducts = []
      return
    }else{
      nextPage = nextPageURL
    }
    
    
    
    
    let fetchProductRequestParams = FetchProductParams()
    fetchProductRequestParams.brandId = selectedBrand.ID
    fetchProductRequestParams.sortMode = sortMode
    fetchProductRequestParams.nextPageURL = nextPage
    fetchProductRequestParams.displayMode = self.displayMode
    fetchProductRequestParams.gender = self.selectedGender
    UnlabelAPIHelper.sharedInstance.getProductOfBrand(fetchProductRequestParams, success: { (arrBrands:[Product], meta: JSON) in
      print(meta)
      self.arrProducts.append(contentsOf: arrBrands)
      self.nextPageURL = meta["next"].stringValue
      if self.arrProducts.count > 0{
        let profileCompletion = meta["profile"].boolValue
        if profileCompletion{
          self.isProfileCompleted = true
        }
        else{
          self.isProfileCompleted = false
        }
      }
      self.IBcollectionViewProduct.reloadData()
    }, failed: { (error) in
    })
    
  }
  fileprivate func setupOnLoad(){
    activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
    if let brandName: String = selectedBrand.Name{
      IBbtnTitle.setTitle(brandName.uppercased(), for: UIControlState())
    }
    IBcollectionViewProduct.register(UINib(nibName: REUSABLE_ID_ProductDescCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductDescCell)
    IBcollectionViewProduct.register(UINib(nibName: REUSABLE_ID_ProductHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductHeaderCell)
    IBcollectionViewProduct.register(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
    IBcollectionViewProduct.register(UINib(nibName: REUSABLE_ID_ProductFooterView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_ProductFooterView)
    IBcollectionViewProduct.register(UINib(nibName: REUSABLE_ID_ProductSortCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductSortCell)
    self.automaticallyAdjustsScrollViewInsets = false
  }
  override func viewWillLayoutSubviews(){
    IBcollectionViewProduct.collectionViewLayout.invalidateLayout()
  }
  fileprivate func updateFollowButton(_ button:UIButton,isFollowing:Bool){
    if isFollowing{
      button.setTitle("Unfollow", for: UIControlState())
      button.layer.borderColor = UIColor.black.cgColor
      button.setTitleColor(UIColor.black, for: UIControlState())
    }else{
      button.setTitle("Follow", for: UIControlState())
      button.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.cgColor
      button.setTitleColor(LIGHT_GRAY_BORDER_COLOR, for: UIControlState())
    }
  }
  fileprivate func showLoading(){
    DispatchQueue.main.async { () -> Void in
      self.activityIndicator!.frame = self.view.frame
      self.activityIndicator!.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
      self.activityIndicator!.startAnimating()
      self.view.addSubview(self.activityIndicator!)
    }
  }
  fileprivate func hideLoading(){
    DispatchQueue.main.async { () -> Void in
      self.activityIndicator!.stopAnimating()
      self.activityIndicator!.removeFromSuperview()
    }
  }
  fileprivate func showAlertWebPageNotAvailable(){
    UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
      
    }
  }
  fileprivate func setTextWithLineSpacing(_ label:UILabel,text:String,lineSpacing:CGFloat){
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.alignment = NSTextAlignment.center
    paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
    let attrString = NSMutableAttributedString(string: text)
    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
    
    label.attributedText = attrString
  }
  fileprivate func share(shareText:String?,shareImage:UIImage?){
    var objectsToShare = [AnyObject]()
    
    if let shareTextObj = shareText{
      objectsToShare.append(shareTextObj as AnyObject)
    }
    if let shareImageObj = shareImage{
      objectsToShare.append(shareImageObj)
    }
    if selectedBrand.shareUrl?.absoluteString != ""{
      objectsToShare.append(selectedBrand.shareUrl as AnyObject)
    }
    if shareText != nil || shareImage != nil || selectedBrand.shareUrl?.absoluteString != ""{
      let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      
      present(activityViewController, animated: true, completion: nil)
    }else{
      debugPrint("There is nothing to share")
    }
  }
}
