//
//  ProductVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

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
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    
//        addTestData()
//        awsCallFetchProducts()
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
        print("reachabilityChanged : \(reachable)")
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
        
        productHeaderCell.IBlblLabelDescription.text = selectedBrand.Description
        productHeaderCell.IBlblLabelLocation.text = "\(selectedBrand.OriginCity), \(selectedBrand.StateOrCountry)"
        
        productHeaderCell.IBimgHeaderImage.image = nil
        
        if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(selectedBrand.FeatureImage)){
            productHeaderCell.IBimgHeaderImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                if let _ = error{
//                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
                }else{
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
                productCell.IBimgProductImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                    if let _ = error{
                        self.handleProductCellActivityIndicator(productCell, shouldStop: false)
                    }else{
                        self.handleProductCellActivityIndicator(productCell, shouldStop: true)
                    }
                })
            }
            
        }else{
            productCell.IBimgProductImage.image = UIImage(named: "splash")
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
            return CGSizeMake(collectionView.frame.size.width, 360)
        }else{
            return CGSizeMake((collectionView.frame.size.width/2)-6, 260)
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
        print("delete account")
    }
    
    func popupDidClickClose(){
        
    }
}



//
//MARK:- IBAction Methods
//
extension ProductVC{
    @IBAction func IBActionBack(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
//        openFilterScreen()
    }
    
    //For ProductFooterView
    @IBAction func IBActionViewMore(sender: AnyObject) {
//        awsCallFetchProducts()
       print("IBActionViewMore")
    }
    
    @IBAction func IBActionFollow(sender: UIButton) {
        print("Follow clicked")

        updateFollowButton(sender, isFollowing: true)
        
        if let fbAccessToken = FB_ACCESS_TOKEN{
            FirebaseHelper.followBrand(selectedBrand.ID, userID: FB_ACCESS_TOKEN, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                if error != nil{
                    
                }else{
                    
                }
            })
            if UnlabelHelper.getBoolValue(sPOPUP_SEEN_ONCE){
                
            }else{
                addPopupView(PopupType.Follow, initialFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT))
                UnlabelHelper.setBoolValue(true, key: sPOPUP_SEEN_ONCE)
            }
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
//MARK:- Custom Methods
//
extension ProductVC{
    func setupOnLoad(){
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
    
    func updateFollowButton(button:UIButton,isFollowing:Bool){
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
    
    func showLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.frame = self.view.frame
            self.activityIndicator!.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
            self.activityIndicator!.startAnimating()
            self.view.addSubview(self.activityIndicator!)
        }
    }
    
    func hideLoading(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
        }
    }
    
//    func addTestData(){
//        for _ in 0...39{
//            arrProductList.append(Product())
//            IBcollectionViewProduct.reloadData()
//        }
//    }

}


//
//MARK:- AWS Call Methods
//
extension ProductVC{
//    func awsCallFetchProducts(){
////        showLoading()
//        
//        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        
//        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
//        scanExpression.exclusiveStartKey = self.lastEvaluatedKey
//        scanExpression.limit = iPaginationCount;
//        
//        scanExpression.filterExpression = "BrandName = :brandNameKey AND isActive = :isActiveKey"
//        scanExpression.expressionAttributeValues = [":brandNameKey": selectedBrand.dynamoDB_Brand.BrandName,":isActiveKey":true]
//        
//        dynamoDBObjectMapper.scan(DynamoDB_Product.self, expression: scanExpression).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
//            
//            //If error
//            if let error = task.error{
//                self.hideLoading()
//                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.localizedDescription, onOk: { () -> () in
//                    
//                })
//                return nil
//            }
//            
//            //If exception
//            if let exception = task.exception{
//                self.hideLoading()
//                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.debugDescription, onOk: { () -> () in
//                    
//                })
//                return nil
//            }
//            
//            //If got result
//            if let result = task.result{
//                if let paginatedOutput:AWSDynamoDBPaginatedOutput = task.result as? AWSDynamoDBPaginatedOutput{
//                    self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey //Update lastEvaluatedKey
//                    if let lastEvaluatedKeyObj = paginatedOutput.lastEvaluatedKey{
////                        self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey // Update lastEvaluatedKey
//                        print(" more data available")// more data found
//                    }else{
//                        print("No more data available")//no more data found
//                    }
//                    
//                }
//
//                
//                //If result items count > 0
//                if let arrItems:[DynamoDB_Product] = result.allItems as? [DynamoDB_Product] where arrItems.count>0{
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        for (index, product) in arrItems.enumerate() {
//                            var productObj = Product()
//                            productObj.dynamoDB_Product = product
//                            
//                            AWSHelper.downloadImageWithCompletion(forImageName: product.ProductImageName, uploadPathKey: pathKeyProducts, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
//                                if let downloadedData = data{
//                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                        if let image = UIImage(data: downloadedData){
//                                            productObj.imgProductImage = image
//                                            self.IBcollectionViewProduct.reloadItemsAtIndexPaths([NSIndexPath(forRow: index+1, inSection: 0)])
//                                        }
//                                    })
//                                }
//                            })
//                            self.arrProductList.append(productObj)
//                        }
//                        defer{
//                            self.hideLoading()
//                            self.IBcollectionViewProduct.reloadData()
//                        }
//                    })
//                }else{
//                    self.hideLoading()
//                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
//                    })
//                }
//            }else{
//                self.hideLoading()
//                UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
//                })
//            }
//            
//            
//            return nil
//        }
//    }
}
