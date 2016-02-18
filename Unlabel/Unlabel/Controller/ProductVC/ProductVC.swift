//
//  ProductVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 02/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB
import SafariServices

class ProductVC: UIViewController,UIViewControllerTransitioningDelegate {

    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBbtnTitle: UIButton!
    @IBOutlet weak var IBbtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBcollectionViewProduct: UICollectionView!
    
    let iPaginationCount = 2
    let fFooterHeight:CGFloat = 81.0
    var activityIndicator:UIActivityIndicatorView?
    var arrProductList = [Product]()
    var selectedBrand = Brand()
    var lastEvaluatedKey:[NSObject : AnyObject]!
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        awsCallFetchProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//
//MARK:- UICollectionViewDelegate Methods
//
extension ProductVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Not Header Cell
        if indexPath.row > 0{
            openSafariForIndexPath(indexPath)
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
            break
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
        return arrProductList.count + 1           //+1 for header cell
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
        
        if let brandImage:UIImage = selectedBrand.imgBrandImage{
            productHeaderCell.IBimgHeaderImage.image = brandImage
        }else{
            productHeaderCell.IBimgHeaderImage.image = UIImage(named: "splash")
        }
        
        if let brandDescription:String = selectedBrand.dynamoDB_Brand.Description{
            productHeaderCell.IBlblLabelDescription.text = brandDescription
        }else{
            productHeaderCell.IBlblLabelDescription.text = ""
        }
        
        if let brandLocation:String = selectedBrand.dynamoDB_Brand.Location{
            productHeaderCell.IBlblLabelLocation.text = brandLocation
        }else{
            productHeaderCell.IBlblLabelLocation.text = ""
        }
        
        return productHeaderCell
    }
    
    func getProductCell(forIndexPath indexPath:NSIndexPath)->ProductCell{
        let productCell = IBcollectionViewProduct.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_ProductCell, forIndexPath: indexPath) as! ProductCell
        
        if let productName:String = arrProductList[indexPath.row-1].dynamoDB_Product.ProductName{
            productCell.IBlblProductName.text = productName
        }else{
            productCell.IBlblProductName.text = "Product"
        }

        if let productPrice:CGFloat = arrProductList[indexPath.row-1].dynamoDB_Product.ProductPrice{
            productCell.IBlblProductPrice.text = "$\(productPrice)"
        }else{
            productCell.IBlblProductPrice.text = ""
        }
        
        if let productImage:UIImage = arrProductList[indexPath.row-1].imgProductImage{
            productCell.IBimgProductImage.image = productImage
        }else{
            productCell.IBimgProductImage.image = UIImage(named: "splash")
        }
        
        return productCell
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
//MARK:- SFSafariViewControllerDelegate Methods
//
extension ProductVC:SFSafariViewControllerDelegate{
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]{
        return []
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
    
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
    
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
        awsCallFetchProducts()
       print("IBActionViewMore")
    }
}


//
//MARK:- Custom Methods
//
extension ProductVC{
    func setupOnLoad(){
        lastEvaluatedKey = nil
        self.arrProductList = [Product]()
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        IBbtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
            forState: UIControlState.Normal)
        
        if let brandName:String = selectedBrand.dynamoDB_Brand.BrandName{
            IBbtnTitle.setTitle(brandName.uppercaseString, forState: .Normal)
        }
        
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductHeaderCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductHeaderCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
        IBcollectionViewProduct.registerNib(UINib(nibName: REUSABLE_ID_ProductFooterView, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_ProductFooterView)

        
        self.automaticallyAdjustsScrollViewInsets = false

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
    
    func openSafariForIndexPath(indexPath:NSIndexPath){
        if let productURLString:String = arrProductList[indexPath.row-1].dynamoDB_Product.ProductURL{
            if let productURL:NSURL = NSURL(string: productURLString){
                let safariVC = UnlabelSafariVC(URL: productURL)
                safariVC.delegate = self
                safariVC.transitioningDelegate = self
                self.presentViewController(safariVC, animated: true) { () -> Void in
                    
                }
            }else{ showAlertWebPageNotAvailable() }
        }else{ showAlertWebPageNotAvailable() }
    }
    
    func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
    }

}


//
//MARK:- AWS Call Methods
//
extension ProductVC{
    func awsCallFetchProducts(){
        showLoading()
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        scanExpression.exclusiveStartKey = self.lastEvaluatedKey
        scanExpression.limit = iPaginationCount;
        
        scanExpression.filterExpression = "BrandName = :brandNameKey AND isActive = :isActiveKey"
        scanExpression.expressionAttributeValues = [":brandNameKey": selectedBrand.dynamoDB_Brand.BrandName,":isActiveKey":true]
        
        dynamoDBObjectMapper.scan(DynamoDB_Product.self, expression: scanExpression).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
            
            //If error
            if let error = task.error{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.localizedDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If exception
            if let exception = task.exception{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.debugDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If got result
            if let result = task.result{
                if let paginatedOutput:AWSDynamoDBPaginatedOutput = task.result as? AWSDynamoDBPaginatedOutput{
                    self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey //Update lastEvaluatedKey
                    if let lastEvaluatedKeyObj = paginatedOutput.lastEvaluatedKey{
//                        self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey // Update lastEvaluatedKey
                        print(" more data available")// more data found
                    }else{
                        print("No more data available")//no more data found
                    }
                    
                }

                
                //If result items count > 0
                if let arrItems:[DynamoDB_Product] = result.items as? [DynamoDB_Product] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        for (index, product) in arrItems.enumerate() {
                            var productObj = Product()
                            productObj.dynamoDB_Product = product
                            
                            AWSHelper.downloadImageWithCompletion(forImageName: product.ProductImageName, uploadPathKey: pathKeyProducts, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let image = UIImage(data: downloadedData){
                                            productObj.imgProductImage = image
                                            self.IBcollectionViewProduct.reloadItemsAtIndexPaths([NSIndexPath(forRow: index+1, inSection: 0)])
                                        }
                                    })
                                }
                            })
                            self.arrProductList.append(productObj)
                        }
                        defer{
                            self.hideLoading()
                            self.IBcollectionViewProduct.reloadData()
                        }
                    })
                }else{
                    self.hideLoading()
                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                    })
                }
            }else{
                self.hideLoading()
                UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                })
            }
            
            
            return nil
        }
    }
}
