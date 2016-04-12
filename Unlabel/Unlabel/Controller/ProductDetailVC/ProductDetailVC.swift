//
//  ProductDetailVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 27/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
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
    let windowTintColor = APP_DELEGATE.window?.tintColor
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        // Do any additional setup after loading the view.
    }

    func setupOnLoad(){
        if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(product.ProductImage)){
            IBImgProductImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in

            })
        }
        
        IBbtnBuyOnBrand.setTitle("BUY ON \(product.ProductBrandName.uppercaseString)", forState: .Normal)
        IBlblPrice.text = "$\(product.ProductPrice)"
        IBlblProductName.text = "\(product.ProductName)"

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//MARK:- IBAction Methods
//
extension ProductDetailVC{
    
    @IBAction func IBActionShare(sender: AnyObject) {
        share(shareText: "Check this amazing label, don't miss any of them. http://unlabel.us", shareImage: IBImgProductImage.image)
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
        APP_DELEGATE.window?.tintColor = windowTintColor
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool){
        
    }
}

//
//MARK:- Custom Methods
//
extension ProductDetailVC{
    func share(shareText shareText:String?,shareImage:UIImage?){
        
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
            print("There is nothing to share")
        }
    }
}
