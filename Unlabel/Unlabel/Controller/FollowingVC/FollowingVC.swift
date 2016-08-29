//
//  FollowingVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 28/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import Branch
import Firebase
import SDWebImage
import SwiftyJSON

class FollowingVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
   @IBOutlet weak var IBcollectionViewFollowing: UICollectionView!
   
     private var arrFollowingBrandList:[Brand] = [Brand]()
       private let FEED_CELL_HEIGHT:CGFloat = 211
   
   private var didSelectBrand: Brand?
   
   @IBOutlet weak var bottonActivityIndicator: UIActivityIndicatorView!
   
   
    //
    //MARK:- VC Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
      
      addNotFoundView()
      self.firebaseCallGetFollowingBrands()
      
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
   
   private func openLoginSignupVC(){
      if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
//         loginSignupVC.delegate = self
         self.presentViewController(loginSignupVC, animated: true, completion: nil)
      }
   }
   
   @IBAction func IBActionStarClicked(sender: UIButton) {
      
      //Internet available
      if ReachabilitySwift.isConnectedToNetwork(){
         if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            if let selectedBrand:Brand = arrFollowingBrandList[sender.tag] where arrFollowingBrandList.count > 0{
               let _index = sender.tag
               
               
               //If already following
               if arrFollowingBrandList[_index].isFollowing{
                  arrFollowingBrandList[_index].isFollowing = false
               }else{
                  arrFollowingBrandList[_index].isFollowing = true
               }
               let _indexPath = NSIndexPath(forRow: _index, inSection: 0)
               
               IBcollectionViewFollowing.reloadItemsAtIndexPaths([_indexPath])
               

               FirebaseHelper.followUnfollowBrand(follow: arrFollowingBrandList[sender.tag].isFollowing, brandID: selectedBrand.ID, userID: userID, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                  //Followd/Unfollowd brand
                  if error == nil{
                     dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrFollowingBrandList.removeAtIndex(_index)
                         self.IBcollectionViewFollowing.reloadData()
                     })
                     
                  }else{
                     UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
                  }
               })
               
               
               
               
               
               if UnlabelHelper.getBoolValue(sPOPUP_SEEN_ONCE){
                  
               } else{
                  addPopupView(PopupType.Follow, initialFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT))
                  UnlabelHelper.setBoolValue(true, key: sPOPUP_SEEN_ONCE)
               }
               
               
               
            }
         }else{
            self.openLoginSignupVC()
         }
      }else{
         UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
      }
   }

}


//
//MARK:- ViewFollowingLabelPopup Methods
//

extension FollowingVC:PopupviewDelegate{
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
      debugPrint("delete account")
   }
   
   func popupDidClickClose(){
      
   }
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FollowingVC:UICollectionViewDelegate{
   
   
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      if let brandAtIndexPath:Brand = self.arrFollowingBrandList[indexPath.row]{
         
         let productViewController = self.storyboard?.instantiateViewControllerWithIdentifier(S_ID_PRODUCT_VC) as! ProductVC
         productViewController.selectedBrand = brandAtIndexPath
//         performSegueWithIdentifier(S_ID_PRODUCT_VC, sender: self)
            self.navigationController?.pushViewController(productViewController, animated: true)
         
      }
   }
   
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if let _ = lastEvaluatedKey{
//            return CGSizeMake(collectionView.frame.width, fFooterHeight)
//        }else{
//            return CGSizeZero
//        }
//        
//    }
    
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
extension FollowingVC:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
         if arrFollowingBrandList.count > 0 {
            IBcollectionViewFollowing.backgroundView?.hidden = true
         }else{
           
            IBcollectionViewFollowing.backgroundView?.hidden = false
         }
         return arrFollowingBrandList.count
    }
    
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      let feedVCCell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_FeedVCCell, forIndexPath: indexPath) as! FeedVCCell
      feedVCCell.IBlblBrandName.text = arrFollowingBrandList[indexPath.row].Name.uppercaseString
      feedVCCell.IBlblLocation.text = "\(arrFollowingBrandList[indexPath.row].city), \(arrFollowingBrandList[indexPath.row].location)"
      feedVCCell.IBbtnStar.tag = indexPath.row
      
      if arrFollowingBrandList[indexPath.row].isFollowing{
         feedVCCell.IBbtnStar.setImage(UIImage(named: "starred"), forState: .Normal)
      }else{
         feedVCCell.IBbtnStar.setImage(UIImage(named: "notStarred"), forState: .Normal)
      }
      
      feedVCCell.IBimgBrandImage.image = nil
      
      if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(arrFollowingBrandList[indexPath.row].FeatureImage)){
         feedVCCell.IBimgBrandImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
            if let _ = error{
               self.handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
            }else{
               if (type == SDImageCacheType.None)  {
                  feedVCCell.IBimgBrandImage.alpha = 0;
                  UIView.animateWithDuration(0.35, animations: {
                     feedVCCell.IBimgBrandImage.alpha = 1;
                  })
               }
               else  {
                  feedVCCell.IBimgBrandImage.alpha = 1;
               }
               self.handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: true)
            }
         })
      }
      
      return feedVCCell
   }
   
   
   private func handleFeedVCCellActivityIndicator(feedVCCell:FeedVCCell,shouldStop:Bool){
      feedVCCell.IBactivityIndicator.hidden = shouldStop
      if shouldStop {
         feedVCCell.IBactivityIndicator.stopAnimating()
      }else{
         feedVCCell.IBactivityIndicator.startAnimating()
      }
   }
   
}

//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension FollowingVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, FEED_CELL_HEIGHT)
    }
}



//
//MARK:- Firebase Call Methods
//

extension FollowingVC: NotFoundViewDelegate {
   
   func didSelectViewLabels() {
       navigationController?.popToRootViewControllerAnimated(true)
   }
   
   func addNotFoundView(){
      let notFoundView:NotFoundView = NSBundle.mainBundle().loadNibNamed("NotFoundView", owner: self, options: nil) [0] as! NotFoundView
      notFoundView.delegate = self
      notFoundView.IBlblMessage.text = "Not following any Labels."
      notFoundView.showViewLabelBtn = true
      IBcollectionViewFollowing.backgroundView = notFoundView
      IBcollectionViewFollowing.backgroundView?.hidden = true
   }
   
   private func getBrandsByID(brandID:String) {
      
     
         UnlabelLoadingView.sharedInstance.start(view)
         
         let fetchBrandParams = FetchBrandsRP()
         fetchBrandParams.brandGender = BrandGender.Both
         fetchBrandParams.brandId = brandID
         
         self.bottonActivityIndicator.startAnimating()
         UnlabelAPIHelper.sharedInstance.getSingleBrand(fetchBrandParams, success: { (brand:Brand, meta: JSON) in
            
            brand.isFollowing = true
            self.arrFollowingBrandList.append(brand)
            
            dispatch_async(dispatch_get_main_queue()) {
               UnlabelLoadingView.sharedInstance.stop(self.view)
               self.bottonActivityIndicator.stopAnimating()
               self.IBcollectionViewFollowing.reloadData()
            }
            
            }, failed: { (error) in
               UnlabelLoadingView.sharedInstance.stop(self.view)
               debugPrint(error)
               
               UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
         })

   }
   
   
   private func firebaseCallGetFollowingBrands() {
      if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID) {
         FirebaseHelper.getFollowingBrands(userID, withCompletionBlock: {[unowned self] (followingBrandIDs:[String]?) in
            if let followingBrandIDsObj = followingBrandIDs {
               
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                  for brandId in followingBrandIDsObj {
                        self.getBrandsByID(brandId)
                  }
               })
               
            }
         })
      }
   }
}



//
//MARK:- IBAction Methods
//
extension FollowingVC{
    @IBAction func IBActionBack(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension FollowingVC{
   
    
    private func setupOnLoad(){
      IBcollectionViewFollowing.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
    }
}