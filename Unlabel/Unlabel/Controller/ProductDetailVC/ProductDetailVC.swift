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
     @IBAction func IBActionBuyProduct(_ sender: AnyObject) {
        GAHelper.trackEvent(GAEventType.BuyLabelClicked, labelName: product.ProductBrandName, productName: product.ProductName, buyProductName: product.ProductName)
        openSafariForURL(product.ProductURL)
    }
    
    @IBAction func IBActionBack(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

//
//MARK:- Custom and SFSafariViewControllerDelegate Methods
//
extension ProductDetailVC:SFSafariViewControllerDelegate,UIViewControllerTransitioningDelegate{
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
    
    func showAlertWebPageNotAvailable(){
        UnlabelHelper.showAlert(onVC: self, title: "WebPage Not Available", message: "Please try again later.") { () -> () in
            
        }
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


//
//MARK:- Custom Methods
//
extension ProductDetailVC{
    fileprivate func setupOnLoad(){
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        
//        if let url = URL(string: UnlabelHelper.getCloudnaryObj().url(product.ProductImage)){
//            IBImgProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
//                
//                if (type == SDImageCacheType.none)
//                {
//                    self.IBImgProductImage.alpha = 0;
//                    UIView.animate(withDuration: 0.35, animations: {
//                        self.IBImgProductImage.alpha = 1;
//                    })
//                }
//                else
//                {
//                    self.IBImgProductImage.alpha = 1;
//                }
//            })
//        }
//        
        IBbtnBuyOnBrand.setTitle("BUY ON \(product.ProductBrandName.uppercased())", for: UIControlState())
        IBlblPrice.text = "$\(product.ProductPrice)"
        IBlblProductName.text = "\(product.ProductName)"
        
    }
    
    fileprivate func share(shareText:String?,shareImage:UIImage?){
        
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            debugPrint("There is nothing to share")
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
}
