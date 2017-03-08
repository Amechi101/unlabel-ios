//
//  ManageContentVC.swift
//  Unlabel
//
//  Created by SayOne Technologies on 01/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

//MARK: -  Enum

enum ContentStatus{
  case reserve
  case rent
  case live
  case unknown
  case unreserved
}
class ManageContentVC: UIViewController {
  
  //MARK: -  IBOutlets,vars,constants
  
  @IBOutlet weak var IBButtonSortMode: UIButton!
  @IBOutlet weak var IBCollectionViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var IBCollectionViewContent: UICollectionView!
  @IBOutlet weak var IBReserveButton: UIButton!
  @IBOutlet weak var IBRentButton: UIButton!
  @IBOutlet weak var IBLiveButton: UIButton!
  var selectedProduct: Product!
  var selectedBrand: Brand!
  var contentStatus: ContentStatus = .reserve
  var sortMode: String = "NEW"
  var sortModeValue: String = "Newest to Oldest"
  var cur_rentalInfo: RentalInfo = RentalInfo()
    fileprivate var arrFilteredBrandList:[Brand] = []
    fileprivate var arrMenBrandList:[Brand] = [Brand]()
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    
    setUpCollectionView()
    getReservedProducts()
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: -  Navigation methods
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ManageToProductVC"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController{
        if let productViewController:ProductViewController = navViewController.viewControllers[0] as? ProductViewController{
        //  productViewController.IBbtnTitle.setTitle("ARMANI EXCHANGE", for: .normal)
          productViewController.selectedProduct = self.selectedProduct
          
          
          productViewController.selectedBrand = self.selectedBrand
          productViewController.contentStatus = self.contentStatus
        }
      }
    }
    else if segue.identifier == "ManageToLiveRent"{
      if let navViewController:UINavigationController = segue.destination as? UINavigationController{
        if let rentOrLiveProductDetailVC:RentOrLiveProductDetailVC = navViewController.viewControllers[0] as? RentOrLiveProductDetailVC{
       //   rentOrLiveProductDetailVC.IBbtnTitle.setTitle("ARMANI EXCHANGE", for: .normal)
          rentOrLiveProductDetailVC.contentStatus = self.contentStatus
          rentOrLiveProductDetailVC.selectedBrand = self.selectedBrand
          rentOrLiveProductDetailVC.selectedProduct = self.selectedProduct
        }
      }
    }
  }
  
}

//MARK: -  Custom methods

extension ManageContentVC{
  
  func setUpCollectionView(){
    IBCollectionViewContent.register(UINib(nibName: S_ID_Product_Content_Header, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: REUSABLE_ID_ProductContentHeaderCell)
    IBCollectionViewContent.register(UINib(nibName: REUSABLE_ID_ProductCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_ProductCell)
  }
  func updateToggleButton(){
    UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
      if self.contentStatus == ContentStatus.reserve{
        self.IBReserveButton.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        self.IBRentButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBLiveButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBCollectionViewTopConstraint.constant = 8.0
      }
      else if self.contentStatus == ContentStatus.rent{
        self.IBReserveButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBRentButton.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        self.IBLiveButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBCollectionViewTopConstraint.constant = 8.0
      }
      else if self.contentStatus == ContentStatus.live{
        self.IBReserveButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBRentButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBLiveButton.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        self.IBCollectionViewTopConstraint.constant = 44.0
      }
      else{
        self.IBReserveButton.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: .normal)
        self.IBRentButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBLiveButton.setTitleColor(EXTRA_LIGHT_GRAY_TEXT_COLOR, for: .normal)
        self.IBCollectionViewTopConstraint.constant = 8.0
      }
    }, completion: { _ in })
  }
  
  func getReservedProducts(){
    arrMenBrandList = []
    let fetchProductRequestParams = FetchProductParams()
    fetchProductRequestParams.sortMode = sortMode
    UnlabelAPIHelper.sharedInstance.getReserveProduct(fetchProductRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
        self.arrFilteredBrandList = []
        print("*** Meta *** \(meta)")
        self.arrMenBrandList.append(contentsOf: arrBrands)
      
      
        self.arrFilteredBrandList = self.arrMenBrandList
        self.IBCollectionViewContent.reloadData()
    }, failed: { (error) in
    })
    
  }
    func getRentedProducts(){
        arrMenBrandList = []
        let fetchProductRequestParams = FetchProductParams()
        fetchProductRequestParams.sortMode = ""
        UnlabelAPIHelper.sharedInstance.getRentedProduct(fetchProductRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
            self.arrFilteredBrandList = []
            print("*** Meta *** \(meta)")
            self.arrMenBrandList.append(contentsOf: arrBrands)
            self.arrFilteredBrandList = self.arrMenBrandList
            self.IBCollectionViewContent.reloadData()
        }, failed: { (error) in
        })
        
    }
    
    func getLiveProducts(){
        arrMenBrandList = []
        let fetchProductRequestParams = FetchProductParams()
        fetchProductRequestParams.sortMode = sortMode
        UnlabelAPIHelper.sharedInstance.getLiveProduct(fetchProductRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
            self.arrFilteredBrandList = []
            print("*** Meta *** \(meta)")
            self.arrMenBrandList.append(contentsOf: arrBrands)
            self.arrFilteredBrandList = self.arrMenBrandList
            self.IBCollectionViewContent.reloadData()
        }, failed: { (error) in
        })
        
    }
}

//MARK: -  IBAction methods

extension ManageContentVC{
  @IBAction func IBActionSortSelection(_ sender: Any) {
    self.addSortPopupView(SlideUpView.sortMode,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  @IBAction func IBActionToggleStatus(_ sender: Any) {
    let buttonID: Int = (sender as AnyObject).tag
    IBCollectionViewContent.reloadData()
    if buttonID == 1{
      contentStatus = ContentStatus.reserve
        getReservedProducts()
    }
    else if buttonID == 2{
      contentStatus = ContentStatus.rent
        getRentedProducts()
    }
    else if buttonID == 3{
      contentStatus = ContentStatus.live
        getLiveProducts()
    }
    else{
      contentStatus = ContentStatus.unknown
    }
    updateToggleButton()
  }
  
  @IBAction func IBActionViewRentalInfo(_ sender: AnyObject) {
    let rentalInfoVC: ViewRentalInfoVC = self.storyboard?.instantiateViewController(withIdentifier: S_ID_Rental_Info_VC) as! ViewRentalInfoVC
    cur_rentalInfo = arrFilteredBrandList[sender.tag].rentalInfo
    rentalInfoVC.rentalInfo = cur_rentalInfo
    self.present(rentalInfoVC, animated: true, completion: nil)
  }
}
//MARK:- UICollectionViewDataSource Methods
extension ManageContentVC: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return arrFilteredBrandList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return arrFilteredBrandList[section].arrProducts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    return getProductCell(forIndexPath: indexPath)
  }
  func getProductCell(forIndexPath indexPath:IndexPath)->ProductCell{
    let productCell = IBCollectionViewContent.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_ProductCell, for: indexPath) as! ProductCell
    productCell.IBlblProductName.text = (arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row].ProductName).capitalized
    
    //"Armani Jeans"//arrProducts[indexPath.row - 3].ProductName
    productCell.IBlblProductPrice.text = "$ " + arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row].ProductPrice//"$ 120.0" //"$" + arrProducts[indexPath.row - 3].ProductPrice
    productCell.IBimgProductImage.contentMode = UIViewContentMode.scaleAspectFill
    
    
    print("product id ******  \(arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row].ProductID)")
    
    
    if arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row].arrProductsImages.first != nil{
        if let url = URL(string:arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row].arrProductsImages.first as! String){
    
          productCell.IBimgProductImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
            if let _ = error{
              self.handleProductCellActivityIndicator(productCell, shouldStop: false)
            }else{
              if (type == SDImageCacheType.none)
              {
                productCell.IBimgProductImage.alpha = 0;
                UIView.animate(withDuration: 0.35, animations: {
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
    }
    else{
        productCell.IBimgProductImage.image = UIImage(named:"Group")
    }
    return productCell
  }
  
  func handleProductCellActivityIndicator(_ productCell:ProductCell,shouldStop:Bool){
    productCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      productCell.IBactivityIndicator.stopAnimating()
    }else{
      productCell.IBactivityIndicator.startAnimating()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    selectedProduct = arrFilteredBrandList[indexPath.section].arrProducts[indexPath.row]
    selectedBrand = arrFilteredBrandList[indexPath.section]
    
    if contentStatus == ContentStatus.reserve{
      performSegue(withIdentifier: "ManageToProductVC", sender: self)
    }
    else if contentStatus == ContentStatus.rent || contentStatus == ContentStatus.live{
      performSegue(withIdentifier: "ManageToLiveRent", sender: self)
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    if contentStatus == ContentStatus.reserve || contentStatus == ContentStatus.rent{
      return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    else if contentStatus == ContentStatus.live{
      return CGSize(width: collectionView.frame.width, height: 25.0)
    }
    else{
      return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let headerView:ProductContentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: REUSABLE_ID_ProductContentHeaderCell, for: indexPath) as! ProductContentHeader
      headerView.IBBrandNameLabel.text = (arrFilteredBrandList[indexPath.section].Name).uppercased()
      headerView.IBViewRentalInfo.tag = indexPath.section
      return headerView
    default:
      assert(false, "No such element")
      return UICollectionReusableView()
    }
  }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods

extension ManageContentVC:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width)/2.2, height: 271.0)
  }
}
//MARK: Sort Popup methods

extension ManageContentVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SORT BY"
      viewSortPopup.alpha = 0
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        viewSortPopup.alpha = 1
      })
      viewSortPopup.updateView()
    }
  }
  func popupDidClickCloseButton(){
    //delegate method to be implemented after API integration
  }
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
   // print(sortMode)
    sortModeValue = selectedItem.uName
    IBButtonSortMode.setTitle("Sort By: "+sortModeValue, for: .normal)
    self.sortMode = selectedItem.uId
    
    arrFilteredBrandList = []
    getLiveProducts()
  }
}
