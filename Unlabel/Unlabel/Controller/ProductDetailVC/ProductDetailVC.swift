//
//  ProductDetailVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 27/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    @IBOutlet weak var IBImgProductImage: UIImageView!
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
    }
    
    @IBAction func IBActionBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
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
