//
//  FollowingVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 28/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire


class FollowingVC: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  
  @IBOutlet weak var IBcollectionViewFollowing: UICollectionView!
  @IBOutlet weak var bottonActivityIndicator: UIActivityIndicatorView!
  fileprivate var arrFilteredBrandList:[Brand] = []
  fileprivate let FEED_CELL_HEIGHT:CGFloat = 211
  fileprivate var didSelectBrand: Brand?
  fileprivate let refreshControl = UIRefreshControl()
  fileprivate var arrMenBrandList:[Brand] = [Brand]()
  fileprivate var arrWomenBrandList:[Brand] = [Brand]()
  var nextPageURLMen:String?
  var nextPageURLWomen:String?
  var nextPageURLBoth:String?
  var isLoading = false
  fileprivate let fFooterHeight:CGFloat = 28.0
  fileprivate var headerView:FeedVCHeaderCell?
  
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupOnLoad()
   // IBcollectionViewFollowing.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID) {
      wsCallGetLabelsResetOffset(false)
    }
    IBcollectionViewFollowing.reloadData()
  }
  
  fileprivate func addNotFoundView(){
    IBcollectionViewFollowing.backgroundView = nil
    let notFoundView:NotFoundView = Bundle.main.loadNibNamed("NotFoundView", owner: self, options: nil)! [0] as! NotFoundView
    notFoundView.delegate = self
    notFoundView.IBlblMessage.text = "Not following any brands."
    notFoundView.showViewLabelBtn = true
    IBcollectionViewFollowing.backgroundView = notFoundView
    IBcollectionViewFollowing.backgroundView?.isHidden = true
  }

}


//MARK:- ViewFollowingLabelPopup Methods

extension FollowingVC:PopupviewDelegate{
  func addPopupView(_ popupType:PopupType,initialFrame:CGRect){
    let viewFollowingLabelPopup:ViewFollowingLabelPopup = Bundle.main.loadNibNamed("ViewFollowingLabelPopup", owner: self, options: nil)! [0] as! ViewFollowingLabelPopup
    viewFollowingLabelPopup.delegate = self
    viewFollowingLabelPopup.popupType = popupType
    viewFollowingLabelPopup.frame = initialFrame
    viewFollowingLabelPopup.alpha = 0
    view.addSubview(viewFollowingLabelPopup)
    UIView.animate(withDuration: 0.2, animations: {
      viewFollowingLabelPopup.frame = self.view.frame
      viewFollowingLabelPopup.frame.origin = CGPoint(x: 0, y: 0)
      viewFollowingLabelPopup.alpha = 1
    })
    if popupType == PopupType.follow{
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


//MARK:- UICollectionViewDelegate Methods

extension FollowingVC:UICollectionViewDelegate{
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let brandAtIndexPath:Brand = self.arrFilteredBrandList[indexPath.row]{
      
      let productViewController = self.storyboard?.instantiateViewController(withIdentifier: S_ID_PRODUCT_VC) as! ProductVC
      productViewController.selectedBrand = brandAtIndexPath
      self.navigationController?.pushViewController(productViewController, animated: true)
      
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
      
    case UICollectionElementKindSectionFooter:
      let footerView:FeedVCFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell, for: indexPath) as! FeedVCFooterCell
      return footerView
    default:
      assert(false, "No such element")
      return UICollectionReusableView()
    }
  }
}

//MARK:- UICollectionViewDataSource Methods

extension FollowingVC:UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    if arrFilteredBrandList.count > 0{
      IBcollectionViewFollowing.backgroundView?.isHidden = true
    }else{
      IBcollectionViewFollowing.backgroundView?.isHidden = false
    }
    
    return arrFilteredBrandList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    if indexPath.item == arrFilteredBrandList.count - 1 {
      wsCallGetLabelsResetOffset(false)
    }
    
    let feedVCCell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSABLE_ID_FeedVCCell, for: indexPath) as! FeedVCCell
    feedVCCell.IBlblBrandName.text = arrFilteredBrandList[indexPath.row].Name.uppercased()
    feedVCCell.IBlblLocation.text = "\(arrFilteredBrandList[indexPath.row].city), \(arrFilteredBrandList[indexPath.row].location)"
    feedVCCell.IBbtnStar.tag = indexPath.row
    
    if arrFilteredBrandList[indexPath.row].isFollowing{
      feedVCCell.IBbtnStar.setImage(UIImage(named: "starred"), for: UIControlState())
    }else{
      feedVCCell.IBbtnStar.setImage(UIImage(named: "notStarred"), for: UIControlState())
    }
    
    feedVCCell.IBimgBrandImage.image = nil
    
    if let url = URL(string: arrFilteredBrandList[indexPath.row].FeatureImage){
      
      feedVCCell.IBimgBrandImage.sd_setImage(with: url, completed: { (iimage, error, type, url) in
        if let _ = error{
          self.handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
        }else{
          if (type == SDImageCacheType.none)
          {
            feedVCCell.IBimgBrandImage.alpha = 0;
            UIView.animate(withDuration: 0.35, animations: {
              feedVCCell.IBimgBrandImage.alpha = 1;
            })
          }
          else
          {
            feedVCCell.IBimgBrandImage.alpha = 1;
          }
          self.handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: true)
        }
      })
    }
    
    return feedVCCell
  }
  
  

  
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
extension FollowingVC:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: FEED_CELL_HEIGHT)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: fFooterHeight)
  }
}

//MARK:- Not found view delegate Methods

extension FollowingVC: NotFoundViewDelegate {
  
  func didSelectViewLabels() {
    _ = navigationController?.popToRootViewController(animated: true)
  }
  
  func didSelectRegisterLogin() {
  }
  
  
  fileprivate func getBrandsByID(_ brandID:String) {
    
    let fetchBrandParams = FetchBrandsRP()
    fetchBrandParams.brandGender = BrandGender.Both
    fetchBrandParams.brandId = brandID
    
    UnlabelAPIHelper.sharedInstance.getSingleBrand(fetchBrandParams, success: { (brand:Brand, meta: JSON) in
      brand.isFollowing = true
      self.arrFilteredBrandList.append(brand)
      
      DispatchQueue.main.async {
        UnlabelLoadingView.sharedInstance.stop(self.view)
        self.IBcollectionViewFollowing.reloadData()
      }
      
    }, failed: { (error) in
      UnlabelLoadingView.sharedInstance.stop(self.view)
      debugPrint(error)
      UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
    })
    
  }
  
}



//MARK:- IBAction Methods

extension FollowingVC{
  
  @IBAction func IBActionStarClicked(_ sender: UIButton) {
    
    //Internet available
    if ReachabilitySwift.isConnectedToNetwork(){
      if UnlabelHelper.isUserLoggedIn(){
        UnlabelLoadingView.sharedInstance.start(APP_DELEGATE.window!)
        if let selectedBrandID:String = arrFilteredBrandList[sender.tag].ID{
          
          //If already following
          if arrFilteredBrandList[sender.tag].isFollowing{
            arrFilteredBrandList[sender.tag].isFollowing = false
          }else{
            arrFilteredBrandList[sender.tag].isFollowing = true
          }
          
          IBcollectionViewFollowing.reloadData()
          debugPrint(arrFilteredBrandList)
          debugPrint([sender.tag])
          UnlabelAPIHelper.sharedInstance.followBrand(selectedBrandID, onVC: self, success:{ (
            meta: JSON) in
            
            debugPrint(meta)
            self.wsCallGetLabels()
            
          }, failed: { (error) in
            UnlabelLoadingView.sharedInstance.stop(self.view)
          })
        }
      }else{
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
    }
  }

  @IBAction func IBActionBack(_ sender: UIButton) {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }
}


//MARK:- Custom Methods

extension FollowingVC{
  
  fileprivate func setupNavBar(){
    addNotFoundView()
    addPullToRefresh()
    wsCallGetLabels()
  }
  fileprivate func setupOnLoad(){
    registerCells()
    setupNavBar()
    (IBcollectionViewFollowing.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  /**
   Add pull to refresh on Collectionview
   */
  fileprivate func addPullToRefresh(){
    refreshControl.addTarget(self, action: #selector(FeedVC.wsCallGetLabels), for: .valueChanged)
    IBcollectionViewFollowing.addSubview(refreshControl)
  }
  
  fileprivate func registerCells(){
    IBcollectionViewFollowing.register(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
    IBcollectionViewFollowing.register(UINib(nibName: REUSABLE_ID_FeedVCFooterCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell)
  }
  fileprivate func handleFeedVCCellActivityIndicator(_ feedVCCell:FeedVCCell,shouldStop:Bool){
    feedVCCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      feedVCCell.IBactivityIndicator.stopAnimating()
    }else{
      feedVCCell.IBactivityIndicator.startAnimating()
    }
  }

}
extension FollowingVC{
  func wsCallGetLabels(){
    wsCallGetLabelsResetOffset(true)
  }
  
  func wsCallGetLabelsResetOffset(_ reset:Bool) {
    var nextPageURL:String? = String()
    
//    if headerView?.selectedTab == .men{
      nextPageURL = nextPageURLMen
//    }else if headerView?.selectedTab == .women{
//      nextPageURL = nextPageURLWomen
//    }else{
      
//    }
    
    if reset {
//      if headerView?.selectedTab == .men{
        nextPageURLMen = nil
        arrMenBrandList = []
//      }
//      else if headerView?.selectedTab == .women{
//        nextPageURLWomen = nil
//        arrWomenBrandList = []
//      }
//    else{
        
//      }
      //            nextPageURL = nil
      //            arrBrandList = []
    } else if let next:String = nextPageURL, next.characters.count == 0 {
      return
    }
    //Internet available
    if ReachabilitySwift.isConnectedToNetwork() && !isLoading{
      isLoading = true
      
//      if headerView?.selectedTab == .men{
        if self.nextPageURLMen == nil {
          UnlabelLoadingView.sharedInstance.start(view)
        }else{
          self.bottonActivityIndicator.startAnimating()
        }
        
//      }else if headerView?.selectedTab == .women{
//        if self.nextPageURLWomen == nil {
//          UnlabelLoadingView.sharedInstance.start(view)
//        }else{
//          self.bottonActivityIndicator.startAnimating()
//        }
        
//      }
//    else{
//        UnlabelLoadingView.sharedInstance.start(view)
//      }
      
      
      let fetchBrandsRequestParams = FetchBrandsRP()
      fetchBrandsRequestParams.sortMode = "AZ"
      
//      if headerView?.selectedTab == .men{
        fetchBrandsRequestParams.nextPageURL = nextPageURLMen
//      }else if headerView?.selectedTab == .women{
//        fetchBrandsRequestParams.nextPageURL = nextPageURLWomen
//      }else{
        
//      }
      
//      if let selectedTab = headerView?.selectedTab{
//        fetchBrandsRequestParams.selectedTab = selectedTab
//      }
      
      
      UnlabelAPIHelper.sharedInstance.getFollowedBrands(fetchBrandsRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
        self.isLoading = false
        
        UnlabelLoadingView.sharedInstance.stop(self.view)
        self.bottonActivityIndicator.stopAnimating()
        
        self.arrFilteredBrandList = []
        print("*** Meta *** \(meta)")
        
        if fetchBrandsRequestParams.selectedTab == .men{
          self.arrMenBrandList.append(contentsOf: arrBrands)
          self.arrFilteredBrandList = self.arrMenBrandList
          self.nextPageURLMen = meta["next"].stringValue
          
        }else if fetchBrandsRequestParams.selectedTab == .women{
          self.arrWomenBrandList.append(contentsOf: arrBrands)
          self.arrFilteredBrandList = self.arrWomenBrandList
        }else{
          
        }
        self.refreshControl.endRefreshing()
        
        DispatchQueue.main.async(execute: { () -> Void in
          self.IBcollectionViewFollowing.reloadData()
        })
        
      }, failed: { (error) in
        self.isLoading = false
        UnlabelLoadingView.sharedInstance.stop(self.view)
        self.bottonActivityIndicator.stopAnimating()
        debugPrint(error)
        self.refreshControl.endRefreshing()
      })
    }else{
      self.refreshControl.endRefreshing()
      if !ReachabilitySwift.isConnectedToNetwork(){
        UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
    }
  }
}

