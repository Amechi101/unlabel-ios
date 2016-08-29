//
//  ProductVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Branch
import Firebase
import SDWebImage
import SafariServices

protocol ProductVCDelegate {
    func didClickFollow(forBrand brand:Brand)
}
class ProductVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBcollectionViewProduct: UICollectionView!
    
    let iPaginationCount = 2
    let fFooterHeight:CGFloat = 81.0
    var activityIndicator:UIActivityIndicatorView?
    var selectedBrand:Brand!
    var lastEvaluatedKey:[NSObject : AnyObject]!
    var delegate:ProductVCDelegate?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
      if selectedBrand == nil {
         selectedBrand = Brand()
      }
      
        setupOnLoad()
    
//        addTestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        UnlabelHelper.setAppDelegateDelegates(self)
        if let _ = self.navigationController{
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
   
   @IBAction func unwindToProductViewController(segue: UIStoryboardSegue) {
      if segue.identifier == "unwindToProductViewController" {
         let productDetail = segue.sourceViewController as! ProductDetailsWebViewVC
          self.selectedBrand = productDetail.selectedBrand!
         let headerCellIndexPath = NSIndexPath(forItem: 0, inSection: 0)
         IBcollectionViewProduct.reloadItemsAtIndexPaths([ headerCellIndexPath ])
       }
   }
}

//
//MARK:- AppDelegateDelegates Methods
//
extension ProductVC:AppDelegateDelegates{
    func reachabilityChanged(reachable: Bool) {
        debugPrint("reachabilityChanged : \(reachable)")
    }
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension ProductVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Not Header Cell
        if indexPath.row > 0{
            performSegueWithIdentifier(S_ID_PRODUCT_DETAIL_WEBVIEW_VC, sender: indexPath)
//            openSafariForIndexPath(indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let _ = lastEvaluatedKey{
            return CGSizeMake(collectionView.frame.width, fFooterHeight)
        }else{
            return CGSizeZero
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
        switch kind {
        
        case UICollectionElementKindSectionFooter:
            let footerView:ProductFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: REUSABLE_ID_ProductFooterView, forIndexPath: indexPath) as! ProductFooterView
            
            return footerView
            
        default:
            assert(false, "No such element")
            return UICollectionReusableView()
        }
    }
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension ProductVC:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 2
//        return selectedBrand.arrProducts.count + 1          //+1 for header cell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if indexPath.row == 0{
            return getProductHeaderCell(forIndexPath: indexPath)
        }else if indexPath.row == 1{
            return getProductDescCell(forIndexPath: indexPath)
        }else{
            return UICollectionViewCell()
        }
    }
    
    //Custom methods
   func getProductHeaderCell(forIndexPath indexPath:NSIndexPath)->ProductHeaderCell{
      let productHeaderCell = IBcollectionViewProduct.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductHeaderCell, forIndexPath: indexPath) as! ProductHeaderCell
      
      productHeaderCell.IBbtnAboutBrand.setTitle("ABOUT", forState: .Normal)
      productHeaderCell.IBimgHeaderImage.image = nil
      
      updateFollowButton(productHeaderCell.IBbtnFollow, isFollowing: selectedBrand.isFollowing)
      
      if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(selectedBrand.FeatureImage)){
         productHeaderCell.IBimgHeaderImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
            if let _ = error{
               //                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
            }else{
               if (type == SDImageCacheType.None)  {
                  productHeaderCell.IBimgHeaderImage.alpha = 0;
                  UIView.animateWithDuration(0.35, animations: {
                     productHeaderCell.IBimgHeaderImage.alpha = 1;
                  })
               } else  {
                  productHeaderCell.IBimgHeaderImage.alpha = 1;
               }
               //                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: true)
            }
         })
      }
      return productHeaderCell
   }
   
    func getProductDescCell(forIndexPath indexPath:NSIndexPath)->ProductDescCell{
        let productDescCell = IBcollectionViewProduct.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductDescCell, forIndexPath: indexPath) as! ProductDescCell
        setTextWithLineSpacing(productDescCell.IBlblDesc, text: "We are working hard to let you purchase products from \(selectedBrand.Name) right here on Unlabel. In the meantime you can follow \(selectedBrand.Name) for updates and purchase products on their website directly.", lineSpacing: 3.0)
        return productDescCell
    }
    
    func getProductCell(forIndexPath indexPath:NSIndexPath)->ProductCell{
        let productCell = IBcollectionViewProduct.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductCell, forIndexPath: indexPath) as! ProductCell
        
        if let productName:String = selectedBrand.arrProducts[indexPath.row - 1].ProductName{
            productCell.IBlblProductName.text = productName
        }else{
            productCell.IBlblProductName.text = "Product"
        }

        if let productPrice:String = selectedBrand.arrProducts[indexPath.row - 1].ProductPrice{
            productCell.IBlblProductPrice.text = "$\(productPrice)"
        }else{
            productCell.IBlblProductPrice.text = ""
        }
        
        if let productImage:String = selectedBrand.arrProducts[indexPath.row - 1].ProductImage{
            if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(productImage)){
                
                productCell.IBimgProductImage.contentMode = UIViewContentMode.ScaleAspectFill;
                
                productCell.IBimgProductImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                    if let _ = error{
                        self.handleProductCellActivityIndicator(productCell, shouldStop: false)
                    }else{
                        if (type == SDImageCacheType.None)
                        {
                            productCell.IBimgProductImage.alpha = 0;
                            UIView.animateWithDuration(0.35, animations: {
                                productCell.IBimgProductImage.alpha = 1;
                            })
                        }
                        else
                        {
                            productCell.IBimgProductImage.alpha = 1;
                        }
                        
                        self.handleProductCellActivityIndicator(productCell, shouldStop: true)
                    }
                })
            }
            
        }else{
            productCell.IBimgProductImage.image = UIImage()
        }
        
        return productCell
    }
    
    func handleProductCellActivityIndicator(productCell:ProductCell,shouldStop:Bool){
        productCell.IBactivityIndicator.hidden = shouldStop
        if shouldStop {
            productCell.IBactivityIndicator.stopAnimating()
        }else{
            productCell.IBactivityIndicator.startAnimating()
        }
    }
    
}


//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension ProductVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSizeMake(collectionView.frame.size.width, 291)
        }else{
            return CGSizeMake((collectionView.frame.size.width)-5.5, 240)
        }
    }
}

//
//MARK:- Navigation Methods
//
extension ProductVC{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_PRODUCT_DETAIL_WEBVIEW_VC{
            if let productDetailWVVC:ProductDetailsWebViewVC = segue.destinationViewController as? ProductDetailsWebViewVC{
//                if let indexPath:NSIndexPath = sender as? NSIndexPath{
                    productDetailWVVC.selectedBrand = self.selectedBrand
//                    if let product:Product = selectedBrand.arrProducts[indexPath.row-1]{
//                        product.ProductBrandName = selectedBrand.Name
//                        productDetailVC.product = product
//                        GAHelper.trackEvent(GAEventType.ProductClicked, labelName: selectedBrand.Name, productName:product.ProductName, buyProductName: nil)
//                    }
//                }
            }
        }else if segue.identifier == S_ID_ABOUT_LABEL_VC{
            if let aboutLabelVC:AboutLabelVC = segue.destinationViewController as? AboutLabelVC{
                aboutLabelVC.selectedBrand = selectedBrand
            }
        }
    }
}

//
//MARK:- ViewFollowingLabelPopup Methods
//

extension ProductVC:PopupviewDelegate{
    /**
     If user not following any brand, show this view
     */
    func addPopupView(popupType:PopupType,initialFrame:CGRect){
        let viewFollowingLabelPopup:ViewFollowingLabelPopup = NSBundle.mainBundle().loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil) [0] as! ViewFollowingLabelPopup
        viewFollowingLabelPopup.delegate = self
        viewFollowingLabelPopup.popupType = popupType
        viewFollowingLabelPopup.frame = initialFrame
        viewFollowingLabelPopup.alpha = 0
        view.addSubview(viewFollowingLabelPopup)
        UIView.animateWithDuration(0.2) {
            viewFollowingLabelPopup.frame = self.view.frame
            viewFollowingLabelPopup.frame.origin = CGPointMake(0, 0)
            viewFollowingLabelPopup.alpha = 1
        }
        if popupType == PopupType.Follow{
            viewFollowingLabelPopup.setFollowSubTitle("Brand")
        }
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



//
//MARK:- IBAction Methods
//
extension ProductVC{
    @IBAction func IBActionBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
//        openFilterScreen()
    }
    
    //For ProductFooterView
    @IBAction func IBActionViewMore(sender: AnyObject) {
//        awsCallFetchProducts()
       debugPrint("IBActionViewMore")
    }
    
   @IBAction func IBActionFollow(sender: UIButton) {
      //  return;
      
      
      debugPrint("Follow clicked")
      //Internet available
      if ReachabilitySwift.isConnectedToNetwork(){
         if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            selectedBrand.isFollowing = !selectedBrand.isFollowing
            updateFollowButton(sender, isFollowing: selectedBrand.isFollowing)
            FirebaseHelper.followUnfollowBrand(follow:selectedBrand.isFollowing,brandID:selectedBrand.ID, userID: userID, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
               if error != nil{
                  
               }else{
                  self.IBcollectionViewProduct.reloadData()
               }
            })
            
            if UnlabelHelper.getBoolValue(sPOPUP_SEEN_ONCE){
               
            }else{
               addPopupView(PopupType.Follow, initialFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT))
               UnlabelHelper.setBoolValue(true, key: sPOPUP_SEEN_ONCE)
            }
         } else {
            self.openLoginSignupVC()
         }
         
         delegate?.didClickFollow(forBrand: selectedBrand)
         self.IBcollectionViewProduct.reloadData()
      }else{
         UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
   }
   
    @IBAction func IBActionAboutBrandClicked(sender: AnyObject) {
        performSegueWithIdentifier(S_ID_ABOUT_LABEL_VC, sender: self)
    }
    
    @IBAction func IBActionViewProducts(sender: AnyObject) {
        performSegueWithIdentifier(S_ID_PRODUCT_DETAIL_WEBVIEW_VC, sender: self)
    }
   
   private func openLoginSignupVC(){
      if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
//         loginSignupVC.delegate = self
         self.presentViewController(loginSignupVC, animated: true, completion: nil)
      }
   }
   
}

//
//MARK:- UIGestureRecognizerDelegate Methods
//
extension ProductVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
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

//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension ProductVC:SFSafariViewControllerDelegate,UIViewControllerTransitioningDelegate{
    func openSafariForURL(urlString:String){
        if let productURL:NSURL = NSURL(string: urlString){
            APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
            let safariVC = UnlabelSafariVC(URL: productURL)
            safariVC.delegate = self
            safariVC.transitioningDelegate = self
            self.presentViewController(safariVC, animated: true) { () -> Void in
                
            }
        }else{ showAlertWebPageNotAvailable() }
    }
    
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]{
        return []
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        APP_DELEGATE.window?.tintColor = WINDOW_TINT_COLOR
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
        
    }
}


//
//MARK:- Custom Methods
//
extension ProductVC{
    private func setupOnLoad(){
        lastEvaluatedKey = nil

        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        
        if let brandName:String = selectedBrand.Name{
            IBbtnTitle.setTitle(brandName.uppercaseString, forState: .Normal)
        }
        
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductDescCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductDescCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductHeaderCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductFooterView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_ProductFooterView)

        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
   private func updateFollowButton(button:UIButton,isFollowing:Bool){
      if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
         if isFollowing{
            button.setTitle("Unfollow", forState: .Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
         }else{
            button.setTitle("Follow", forState: .Normal)
            button.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
            button.setTitleColor(LIGHT_GRAY_BORDER_COLOR, forState: .Normal)
         }
      } else {
//         self.openLoginSignupVC()
      }
   }
   
    private func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.frame = self.view.frame
            self.activityIndicator!.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            self.activityIndicator!.startAnimating()
            self.view.addSubview(self.activityIndicator!)
        }
    }
    
    private func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
        }
    }
    
    private func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
    }
    
    private func setTextWithLineSpacing(label:UILabel,text:String,lineSpacing:CGFloat){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        label.attributedText = attrString
    }
    
//    func addTestData(){
//        for _ in 0...39{
//            arrProductList.append(Product())
//            IBcollectionViewProduct.reloadData()
//        }
//    }

}