//
//  AddOrViewProductImageVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 10/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class AddOrViewProductImageVC: UIViewController {
  @IBOutlet weak var IBCollectionViewProductPhotos: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
      setUpCollectionView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func setUpCollectionView(){
    IBCollectionViewProductPhotos.register(UINib(nibName: "ProductPhotoCell", bundle: nil), forCellWithReuseIdentifier: "ProductPhotoCell")
  }
  @IBAction func IBActionRemovePhoto(_ sender: Any) {
  }


}
extension AddOrViewProductImageVC: UICollectionViewDataSource{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    return getProductCell(forIndexPath: indexPath)
  }
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductPhotoCell{
    let productCell = IBCollectionViewProductPhotos.dequeueReusableCell(withReuseIdentifier: "ProductPhotoCell", for: indexPath) as! ProductPhotoCell
    productCell.IBProductImage.contentMode = UIViewContentMode.scaleAspectFill;
    productCell.IBProductImage.image = UIImage(named: "product_demo")
    self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    
    //***** To be done at API integration phase
    
    //    if let url = URL(string: arrProducts[indexPath.row - 3].arrProductsImages.first as! String){
    //
    //      productCell.IBimgProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
    //        if let _ = error{
    //          self.handleProductCellActivityIndicator(productCell, shouldStop: false)
    //        }else{
    //          if (type == SDImageCacheType.none)
    //          {
    //            productCell.IBimgProductImage.alpha = 0;
    //            UIView.animate(withDuration: 0.35, animations: {
    //              productCell.IBimgProductImage.alpha = 1;
    //            })
    //          }
    //          else
    //          {
    //            productCell.IBimgProductImage.alpha = 1;
    //          }
    //          self.handleProductCellActivityIndicator(productCell, shouldStop: true)
    //        }
    //      })
    //    }
    return productCell
  }
  
  func handleProductCellActivityIndicator(_ productCell:ProductPhotoCell,shouldStop:Bool){
    productCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      productCell.IBactivityIndicator.stopAnimating()
    }else{
      productCell.IBactivityIndicator.startAnimating()
    }
  }
}

extension AddOrViewProductImageVC:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width)/2.2, height: 271.0)
  }
}
