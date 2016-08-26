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
   @IBOutlet weak var IBcollectionViewFollowing: UICollectionView! {
      didSet {
          addNotFoundView()
      }
   }
   
     private var arrFollowingBrandList:[Brand] = [Brand]()
      private let FEED_CELL_HEIGHT:CGFloat = 211
   
   @IBOutlet weak var bottonActivityIndicator: UIActivityIndicatorView!
   
   
    //
    //MARK:- VC Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        getBrands()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FollowingVC:UICollectionViewDelegate{
//   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//      if let brandAtIndexPath:Brand? = self.arrFollowingBrandList[indexPath.row]{
//         didSelectBrand = brandAtIndexPath
//      }
//      performSegueWithIdentifier(S_ID_PRODUCT_VC, sender: self)
//   }
   
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

extension FollowingVC {
   
   func addNotFoundView(){
      let notFoundView:NotFoundView = NSBundle.mainBundle().loadNibNamed("NotFoundView", owner: self, options: nil) [0] as! NotFoundView
      IBcollectionViewFollowing.backgroundView = notFoundView
      IBcollectionViewFollowing.backgroundView?.hidden = true
   }
   
   private func getBrands() {
      
      let fetchBrandParams = FetchBrandsRP()
      fetchBrandParams.brandGender = BrandGender.Both
      self.bottonActivityIndicator.startAnimating()
      UnlabelAPIHelper.sharedInstance.getBrands(fetchBrandParams, success: { (arrBrands:[Brand], meta: JSON) in
         
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.firebaseCallGetFollowingBrands(arrBrands)
         })
         
        
         
         }, failed: { (error) in
             UnlabelLoadingView.sharedInstance.stop(self.view)
             debugPrint(error)
           
            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
      })
   }
   
   
   
   private func firebaseCallGetFollowingBrands(arrBrands:[Brand]){
      if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
         FirebaseHelper.getFollowingBrands(userID, withCompletionBlock: { (followingBrandIDs:[String]?) in
            if let followingBrandIDsObj = followingBrandIDs {
               
               let arrToBeUpdated = arrBrands.filter { followingBrandIDsObj.contains($0.ID)  }
               
               for  brand in arrToBeUpdated {
                  if followingBrandIDsObj.contains(brand.ID){
                     brand.isFollowing = true
                  } else {
                     brand.isFollowing = false
                  }
               }
               self.arrFollowingBrandList = arrToBeUpdated
               
               UnlabelLoadingView.sharedInstance.stop(self.view)
               self.bottonActivityIndicator.stopAnimating()
               
               dispatch_async(dispatch_get_main_queue()) {
                  self.IBcollectionViewFollowing.reloadData()
               }
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
         
        self.title = LeftMenuItems.Following.getLeftMenuTitle
      
      
        IBcollectionViewFollowing.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
    }
}