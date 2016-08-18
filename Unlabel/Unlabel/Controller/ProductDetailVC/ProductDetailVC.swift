//
//  ProductDetailVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 27/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Branch
import SDWebImage
import SafariServices

class ProductDetailVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBbtnBuyOnBrand: UIButton!
    @IBOutlet weak var IBbtnShareInspiration: UIButton!
    @IBOutlet weak var IBlblPrice: UILabel!
    @IBOutlet weak var IBlblProductName: UILabel!
    
    @IBOutlet weak var IBImgProductImage: UIImageView!
    var product = Product()
    var deepLinkingCompletionDelegate: BranchDeepLinkingControllerCompletionDelegate?
    var activityIndicator:UIActivityIndicatorView?
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//MARK:- IBAction Methods
//
extension ProductDetailVC{
    @IBAction func IBActionShare(sender: AnyObject) {
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "label/\(product.BrandID)")
        branchUniversalObject.title = product.ProductName
        branchUniversalObject.imageUrl = UnlabelHelper.getCloudnaryObj().url(product.ProductImage)
        branchUniversalObject.contentDescription = "\(product.ProductName) from \(product.ProductBrandName), See more..."
        branchUniversalObject.addMetadataKey(PRM_BRAND_ID, value: product.BrandID)
        
        
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = "share inspiration"
        
        branchUniversalObject.listOnSpotlight()
    
        showLoading()
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties,  andCallback: { (url: String?, error: NSError?) -> Void in
            self.hideLoading()
            if error == nil ,let urlObj = url{
                self.share(shareText: "\(self.product.ProductName) from \(self.product.ProductBrandName) \(urlObj)", shareImage: self.IBImgProductImage.image)
            }else{
                self.share(shareText: "\(self.product.ProductName) from \(self.product.ProductBrandName)", shareImage: self.IBImgProductImage.image)
            }
        })
    }
    
    @IBAction func IBActionBuyProduct(sender: AnyObject) {
        GAHelper.trackEvent(GAEventType.BuyLabelClicked, labelName: product.ProductBrandName, productName: product.ProductName, buyProductName: product.ProductName)
        openSafariForURL(product.ProductURL)
    }
    
    @IBAction func IBActionBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension ProductDetailVC:SFSafariViewControllerDelegate,UIViewControllerTransitioningDelegate{
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
    
    func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
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
extension ProductDetailVC{
    private func setupOnLoad(){
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        
        if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(product.ProductImage)){
            IBImgProductImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                
                if (type == SDImageCacheType.None)
                {
                    self.IBImgProductImage.alpha = 0;
                    UIView.animateWithDuration(0.35, animations: {
                        self.IBImgProductImage.alpha = 1;
                    })
                }
                else
                {
                    self.IBImgProductImage.alpha = 1;
                }
            })
        }
        
        IBbtnBuyOnBrand.setTitle("BUY ON \(product.ProductBrandName.uppercaseString)", forState: .Normal)
        IBlblPrice.text = "$\(product.ProductPrice)"
        IBlblProductName.text = "\(product.ProductName)"
        
    }
    
    private func share(shareText shareText:String?,shareImage:UIImage?){
        
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            presentViewController(activityViewController, animated: true, completion: nil)
        }else{
            debugPrint("There is nothing to share")
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
}
