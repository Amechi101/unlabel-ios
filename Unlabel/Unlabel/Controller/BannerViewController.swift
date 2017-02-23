//
//  BannerViewController.swift
//  Unlabel
//
//  Created by SayOne on 21/12/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices


class BannerViewController: UIViewController {
  
  //MARK:-   IBOutlets,variable,constant declarations
  
  @IBOutlet weak var productImageCollectionView: UICollectionView!
  @IBOutlet weak var productPageControl: UIPageControl!
  @IBOutlet weak var bannerDescription: UILabel!
  
  //MARK:-   View Lifecycle methods
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
   // setUpCollectionView()
  //  setUpPageControl()
    
    bannerDescription.setTextWithLineSpacing(text: "Rent and tryout products from the best independent brands, create content and earn commission from your created content. ", lineSpace: 6.0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//MARK: -  Custom methods

extension BannerViewController{
  func setUpPageControl(){
    productPageControl.numberOfPages = 3
    productPageControl.currentPage = 0
  }
  func setUpCollectionView(){
    
    productImageCollectionView.layoutMargins = UIEdgeInsets.zero
    productImageCollectionView.preservesSuperviewLayoutMargins = false
    
    productImageCollectionView.register(UINib(nibName: PRODUCT_IMAGE_CELL, bundle: nil), forCellWithReuseIdentifier:REUSABLE_ID_PRODUCT_IMAGE_CELL )
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 0.0
    (productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 0.0
    self.automaticallyAdjustsScrollViewInsets = true
    
  }
}


//MARK:-   IBAction methods

extension BannerViewController{
  
  @IBAction func IBActionGotoUnlabel(_ sender: Any) {
    openSafariForURL(URL_UNLABEL)
  }
}


//MARK: -  Collection view methods

extension BannerViewController:UICollectionViewDelegate,UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return 3
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
    let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_PRODUCT_IMAGE_CELL, for: indexPath) as! ProductImageCell
    productCell.productImage.image = UIImage(named: "Katie_Lookbook")
    return productCell
  }
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    productPageControl.currentPage = indexPath.row
  }
}
extension BannerViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
  }
}


//MARK: - Safari ViewController Delegate Methods
extension BannerViewController: SFSafariViewControllerDelegate{
  func openSafariForURL(_ urlString:String){
    if let productURL:URL = URL(string: urlString){
      APP_DELEGATE.window?.tintColor = MEDIUM_GRAY_TEXT_COLOR
      let safariVC = SFSafariViewController(url: productURL)
      safariVC.delegate = self
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
