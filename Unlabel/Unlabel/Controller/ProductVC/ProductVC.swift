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
    var selectedBrand = Brand()
    var lastEvaluatedKey:[NSObject : AnyObject]!
    var delegate:ProductVCDelegate?
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
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
            performSegueWithIdentifier(S_ID_PRODUCT_DETAIL_VC, sender: indexPath)
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
        return selectedBrand.arrProducts.count + 1          //+1 for header cell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if indexPath.row == 0{
            return getProductHeaderCell(forIndexPath: indexPath)
        }else{
            return getProductCell(forIndexPath: indexPath)
        }
    }
    
    //Custom methods
    func getProductHeaderCell(forIndexPath indexPath:NSIndexPath)->ProductHeaderCell{
        let productHeaderCell = IBcollectionViewProduct.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductHeaderCell, forIndexPath: indexPath) as! ProductHeaderCell
        
        productHeaderCell.IBbtnAboutBrand.setTitle("ABOUT", forState: .Normal)
        updateFollowButton(productHeaderCell.IBbtnFollow, isFollowing: selectedBrand.isFollowing)
        productHeaderCell.IBimgHeaderImage.image = nil
        
        if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(selectedBrand.FeatureImage)){
            productHeaderCell.IBimgHeaderImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                if let _ = error{
//                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
                }else{
                    if (type == SDImageCacheType.None)
                    {
                        productHeaderCell.IBimgHeaderImage.alpha = 0;
                        UIView.animateWithDuration(0.35, animations: {
                            productHeaderCell.IBimgHeaderImage.alpha = 1;
                        })
                    }
                    else
                    {
                        productHeaderCell.IBimgHeaderImage.alpha = 1;
                    }
//                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: true)
                }
            })
        }
        
        return productHeaderCell
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
            return CGSizeMake((collectionView.frame.size.width/2)-5.5, 260)
        }
    }
}

//
//MARK:- Navigation Methods
//
extension ProductVC{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_PRODUCT_DETAIL_VC{
            if let productDetailVC:ProductDetailVC = segue.destinationViewController as? ProductDetailVC{
                if let indexPath:NSIndexPath = sender as? NSIndexPath{
                    if let product:Product = selectedBrand.arrProducts[indexPath.row-1]{
                        product.ProductBrandName = selectedBrand.Name
                        productDetailVC.product = product
                        GAHelper.trackEvent(GAEventType.ProductClicked, labelName: selectedBrand.Name, productName:product.ProductName, buyProductName: nil)
                    }
                }
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
        debugPrint("Follow clicked")
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            if selectedBrand.isFollowing {
                selectedBrand.isFollowing = false
            }else{
                selectedBrand.isFollowing = true
            }
            
            updateFollowButton(sender, isFollowing: selectedBrand.isFollowing)
            
            if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
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
        
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductHeaderCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductFooterView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_ProductFooterView)

        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    private func updateFollowButton(button:UIButton,isFollowing:Bool){
        if isFollowing{
            button.setTitle("Unfollow", forState: .Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }else{
            button.setTitle("Follow", forState: .Normal)
            button.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.CGColor
            button.setTitleColor(LIGHT_GRAY_BORDER_COLOR, forState: .Normal)
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
    
//    func addTestData(){
//        for _ in 0...39{
//            arrProductList.append(Product())
//            IBcollectionViewProduct.reloadData()
//        }
//    }

}