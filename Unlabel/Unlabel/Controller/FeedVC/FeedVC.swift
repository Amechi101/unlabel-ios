//
//  FeedVC.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import Branch
import Firebase
import SDWebImage
import SwiftyJSON

enum MainVCType:Int{
    case Feed
    case Following
    case Filter
}

enum FilterType:Int{
    case Unknown
    case Men
    case Women
}

class FeedVC: UIViewController {
    
    //
    //MARK:- IBOutlets, constants, vars
    //
    @IBOutlet weak var IBbarBtnHamburger: UIBarButtonItem!
    @IBOutlet weak var IBbtnHamburger: UIButton!
    @IBOutlet weak var IBbtnUnlabel: UIButton!
    @IBOutlet weak var IBcollectionViewFeed: UICollectionView!
    
    @IBOutlet weak var bottonActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var IBbtnLeftBarButton: UIButton!
    @IBOutlet weak var IBbtnFilter: UIButton!
    
    private let FEED_CELL_HEIGHT:CGFloat = 211
    private let fFooterHeight:CGFloat = 28.0
    private let fHeaderHeight:CGFloat = 54.0
    private let refreshControl = UIRefreshControl()
    
//    private var arrBrandList:[Brand] = [Brand]()
    var arrFilteredBrandList:[Brand] = [Brand]()
    
    private var arrMenBrandList:[Brand] = [Brand]()
    private var arrWomenBrandList:[Brand] = [Brand]()
    
    private var didSelectBrand:Brand?
    private var filterChildVC:FilterVC?
    private var leftMenuChildVC:LeftMenuVC?
    private var headerView:FeedVCHeaderCell?
    
    var mainVCType:MainVCType = .Feed
    var filteredNavTitle:String?
    var filteredString:String?
    var sFilterCategory:String?
    var sFilterLocation:String?
    
//    var nextPageURL:String?
    var nextPageURLMen:String?
    var nextPageURLWomen:String?
    var nextPageURLBoth:String?
    
    var isLoading = false
    
    var deepLinkingCompletionDelegate: BranchDeepLinkingControllerCompletionDelegate?
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        UnlabelHelper.setAppDelegateDelegates(self)
    }
    
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
         if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID) {
            wsCallGetLabelsResetOffset(false)
         }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//
//MARK:- Navigation Methods
//
extension FeedVC{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_PRODUCT_VC{
            if let productVC:ProductVC = segue.destinationViewController as? ProductVC{
                if let brand:Brand = didSelectBrand{
                    productVC.selectedBrand = brand
                    productVC.delegate = self
                    GAHelper.trackEvent(GAEventType.LabelClicked, labelName: brand.Name, productName: nil, buyProductName: nil)
                }
            }
        }else if segue.identifier == SEGUE_FILTER_LABELS{
            if let commonTableVC:CommonTableVC = segue.destinationViewController as? CommonTableVC{
                commonTableVC.commonVCType = .FilterLabels
                commonTableVC.filterType = (headerView?.selectedTab)!
                commonTableVC.arrFilteredBrandList = arrFilteredBrandList
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == SEGUE_FILTER_LABELS{
            if headerView?.selectedTab == .Men{
                return arrMenBrandList.count > 0
            }else if headerView?.selectedTab == .Women{
                return arrWomenBrandList.count > 0
            }else{
                return false
            }
        }else{
            return true
        }
    }
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FeedVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let brandAtIndexPath:Brand? = self.arrFilteredBrandList[indexPath.row]{
            didSelectBrand = brandAtIndexPath
        }
        performSegueWithIdentifier(S_ID_PRODUCT_VC, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
     
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: REUSABLE_ID_FeedVCHeaderCell, forIndexPath: indexPath) as? FeedVCHeaderCell
            
            if mainVCType == .Feed{
//                headerView?.IBconstraintGenderContainerHeight.constant = fHeaderHeight
                IBbtnFilter.hidden = false
                headerView?.IBlblFilterTitle.hidden = true
                headerView?.IBbtnMen.hidden = false
                headerView?.IBbtnWomen.hidden = false
                
                var selectedTabString = String()
                
                if headerView?.selectedTab == .Men {
                    selectedTabString = "Men"
                }else if headerView?.selectedTab == .Women{
                    selectedTabString = "Women"
                }else{
                
                }
                
                if let sFilterCategory = sFilterCategory{
                    headerView?.IBlblFilterTitle.hidden = false
                    selectedTabString =  selectedTabString + " - " + sFilterCategory
                }
                
                if let sFilterLocation = sFilterLocation{
                    headerView?.IBlblFilterTitle.hidden = false
                    selectedTabString = selectedTabString + " - " + sFilterLocation
                }
                
                headerView?.IBbtnMen.hidden = !((headerView?.IBlblFilterTitle.hidden)!)
                headerView?.IBbtnWomen.hidden = !((headerView?.IBlblFilterTitle.hidden)!)
                
                headerView?.IBlblFilterTitle.text = selectedTabString
                
            }else if mainVCType == .Filter{
//                headerView?.IBconstraintGenderContainerHeight.constant = 0
                IBbtnFilter.hidden = true
                
                
            }else{
               
            }
            
            
            return headerView!
            
        case UICollectionElementKindSectionFooter:
            let footerView:FeedVCFooterCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell, forIndexPath: indexPath) as! FeedVCFooterCell
            
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
extension FeedVC:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if arrFilteredBrandList.count > 0{
            IBcollectionViewFeed.backgroundView?.hidden = true
        }else{
            IBcollectionViewFeed.backgroundView?.hidden = false
        }
        
        return arrFilteredBrandList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
//        print("\(indexPath)")
        if indexPath.item == arrFilteredBrandList.count - 1 {
            wsCallGetLabelsResetOffset(false)
        }
        
        let feedVCCell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_FeedVCCell, forIndexPath: indexPath) as! FeedVCCell
        feedVCCell.IBlblBrandName.text = arrFilteredBrandList[indexPath.row].Name.uppercaseString
        feedVCCell.IBlblLocation.text = "\(arrFilteredBrandList[indexPath.row].city), \(arrFilteredBrandList[indexPath.row].location)"
        feedVCCell.IBbtnStar.tag = indexPath.row
        
        if arrFilteredBrandList[indexPath.row].isFollowing{
            feedVCCell.IBbtnStar.setImage(UIImage(named: "starred"), forState: .Normal)
        }else{
            feedVCCell.IBbtnStar.setImage(UIImage(named: "notStarred"), forState: .Normal)
        }
        
        feedVCCell.IBimgBrandImage.image = nil
        
        if let url = NSURL(string: UnlabelHelper.getCloudnaryObj().url(arrFilteredBrandList[indexPath.row].FeatureImage)){
            feedVCCell.IBimgBrandImage.sd_setImageWithURL(url, completed: { (iimage:UIImage!, error:NSError!, type:SDImageCacheType, url:NSURL!) in
                if let _ = error{
                    self.handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
                }else{
                    if (type == SDImageCacheType.None)
                    {
                        feedVCCell.IBimgBrandImage.alpha = 0;
                        UIView.animateWithDuration(0.35, animations: {
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

//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension FeedVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSizeMake(SCREEN_WIDTH, fHeaderHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, FEED_CELL_HEIGHT)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.frame.width, fFooterHeight)
    }
    
}


//
//MARK:- LeftMenuVCDelegate Methods
//
extension FeedVC:LeftMenuVCDelegate{
    func didSelectRowAtIndexPath(indexPath: NSIndexPath) {
        handleLeftMenuSelection(forIndexPath:indexPath)
    }
}

//
//MARK:- FilterVCDelegate Methods
//
extension FeedVC: FilterVCDelegate{
    func didClickShowLabels(category: String?, location: String?) {
        arrFilteredBrandList = []
        arrMenBrandList = []
        arrWomenBrandList = []
        sFilterCategory = category
        sFilterLocation = location
        
        var shouldShowClear = false
        
        if let _ = category{
            shouldShowClear = true
        }
        
        if let _ = location{
            shouldShowClear = true
        }
        
        updateFilterButton(shouldShowClear: shouldShowClear)
        
        wsCallGetLabels()
//        wsCallGetLabelsResetOffset(true)
    }
    
    private func updateFilterButton(shouldShowClear shouldShowClear:Bool){
        if shouldShowClear {
            IBbtnFilter.setImage(nil, forState: .Normal)
            IBbtnFilter.setTitle(Strings.clear, forState: .Normal)
            IBbtnFilter.frame.size.width = 60
        }else{
            IBbtnFilter.setTitle(nil, forState: .Normal)
            IBbtnFilter.setImage(UIImage(named: IMG_SEARCH), forState: .Normal)
            IBbtnFilter.frame.size.width = 60
        }
        navigationController?.navigationBar.setNeedsLayout()
    }
    
    private func updateTabView(shouldShowTabs shouldShowTabs:Bool){
        if shouldShowTabs {
            headerView?.IBbtnMen.hidden = false
            headerView?.IBbtnWomen.hidden = false
            headerView?.IBlblFilterTitle.hidden = true
        }else{
            headerView?.IBbtnMen.hidden = true
            headerView?.IBbtnWomen.hidden = true
            headerView?.IBlblFilterTitle.hidden = false
        }
    }
}

//
//MARK:- LeftMenuVCDelegate,FilterVCDelegate Common Delegate Methods
//
extension FeedVC{
    func willCloseChildVC(childVCName: String) {
        headerButtonEnabled(setEnabled: true)
    }
}

//
//MARK:- AppDelegateDelegates Methods
//
extension FeedVC:AppDelegateDelegates{
    func reachabilityChanged(reachable: Bool) {
        if reachable{
            if mainVCType == .Feed{
                if arrFilteredBrandList.count == 0{
                    wsCallGetLabels()
                }
            }else if mainVCType == .Following{
                
            }else if mainVCType == .Filter{
                
            }else{
                debugPrint("unknown vctype")
            }
        }
        debugPrint("reachabilityChanged : \(reachable)")
    }
    
}

//
//MARK:- ProductVCDelegate Call Methods
//
extension FeedVC:ProductVCDelegate{
    func didClickFollow(forBrand brand: Brand) {
//        arrFilteredBrandList[brand.currentIndex] = brand
//        IBcollectionViewFeed.reloadData()
    }
}


//
//MARK:- LoginSignupVCDelegate Methods
//
extension FeedVC:LoginSignupVCDelegate{
    func willDidmissViewController() {
//        var userDisplayName = S_LOGIN_REGISTER
//        
//        if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
//            if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
//                userDisplayName = displayName
//            }
//        }
//        
//        IBlblUserName.text = userDisplayName
    }
}


//
//MARK:- BranchDeepLinkingController Methods
//
extension FeedVC: BranchDeepLinkingController {
    func configureControlWithData(data: [NSObject : AnyObject]!) {
        if let brandId = data[PRM_BRAND_ID]{
            print(brandId)
        }
        
        // show the picture
    }
    
    func closePressed() {
        self.deepLinkingCompletionDelegate!.deepLinkingControllerCompleted()
    }
}

//
//MARK:- NotFoundView Methods
//

extension FeedVC:NotFoundViewDelegate{
    /**
     If user not following any brand, show this view
     */
    func addNotFoundView(){
        let notFoundView:NotFoundView = NSBundle.mainBundle().loadNibNamed("NotFoundView", owner: self, options: nil) [0] as! NotFoundView
        notFoundView.delegate = self
        IBcollectionViewFeed.backgroundView = notFoundView
        IBcollectionViewFeed.backgroundView?.hidden = true
    }
    
    func didSelectViewLabels() {
        popVC()
    }
}


//
//MARK:- ViewFollowingLabelPopup Methods
//

extension FeedVC:PopupviewDelegate{
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
//MARK:- IBAction Methods
//
extension FeedVC{
    @IBAction func IBActionHamburger(sender: UIButton) {
        handleHamburgerAndBack(sender)
    }
    
    @IBAction func IBActionSwipeRight(sender: AnyObject) {
        handleHamburgerAndBack(sender)
    }
    
    @IBAction func IBActionStarClicked(sender: UIButton) {
        
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
                if let selectedBrandID:String = arrFilteredBrandList[sender.tag].ID{
                    
                    //If already following
                    if arrFilteredBrandList[sender.tag].isFollowing{
                        arrFilteredBrandList[sender.tag].isFollowing = false
                    }else{
                        arrFilteredBrandList[sender.tag].isFollowing = true
                    }
                  
                     IBcollectionViewFeed.reloadData()
                    
                    FirebaseHelper.followUnfollowBrand(follow: arrFilteredBrandList[sender.tag].isFollowing, brandID: selectedBrandID, userID: userID, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                        //Followd/Unfollowd brand
                        if error == nil{
                           self.firebaseCallGetFollowingBrands(nil)
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
    
    @IBAction func IBActionFilterMen(sender: UIButton) {
        if let headerView = headerView{
            headerView.updateFilterHeader(forFilterType: .Men)
            if arrMenBrandList.count == 0{
                wsCallGetLabels()
            }else{
                updateFilterArray()
            }
        }
    }
    
    @IBAction func IBActionFilterWomen(sender: UIButton) {
        if let headerView = headerView{
            headerView.updateFilterHeader(forFilterType: .Women)
            if arrWomenBrandList.count == 0{
                wsCallGetLabels()
            }else{
                updateFilterArray()
            }
        }
    }
    
//    @IBAction func IBActionFilterMnW(sender: UIButton) {
//        if let headerView = headerView{
//            headerView.updateFilterHeader(forFilterType: .Both)
//            if arrBothBrandList.count == 0{
//                wsCallGetLabels()
//            }else{
//                updateFilterArray()
//            }
//        }
//    }
    
    @IBAction func IBActionFilter(sender: AnyObject) {
        if sFilterLocation != nil || sFilterCategory != nil {
            arrFilteredBrandList = []
            arrMenBrandList = []
            arrWomenBrandList = []
            sFilterCategory = nil
            sFilterLocation = nil
            wsCallGetLabels()
            updateTabView(shouldShowTabs: true)
            updateFilterButton(shouldShowClear: false)
        }else{
            addFilterVCAsChildVC(viewControllerName: S_ID_FILTER_VC)
        }
    }
   
}


//
//MARK:- Custom Methods
//
extension FeedVC{
    
    /**
     Setup UI on VC Load.
     */
    private func setupOnLoad(){
        registerCells()
        setupNavBar()
        (IBcollectionViewFeed.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /**
     Add pull to refresh on Collectionview
     */
    private func addPullToRefresh(){
        refreshControl.addTarget(self, action: #selector(FeedVC.wsCallGetLabels), forControlEvents: .ValueChanged)
        IBcollectionViewFeed.addSubview(refreshControl)
    }
    
    private func registerCells(){
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCFooterCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell)
    }
    
    private func setupNavBar(){
        var titleText = "UNLABEL"
        var leftBarButtonImage = IMG_HAMBURGER
        
        if mainVCType == .Feed{
            addNotFoundView()
            addPullToRefresh()
            wsCallGetLabels()
            IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Bold", size: 28)
        }else if mainVCType == .Filter{
            addNotFoundView()
            if let filteredNavTitleObj = filteredNavTitle{
                titleText = "\(filteredNavTitleObj)"
            }
            IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 18)
            IBbtnUnlabel.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, forState: .Normal)
        }
        
        if self.navigationController?.viewControllers.count > 1{
            leftBarButtonImage = IMG_BACK
        }
        
        
        IBbtnUnlabel.titleLabel?.textColor = UIColor.blackColor()
        IBbtnUnlabel.setTitle(titleText.uppercaseString, forState: .Normal)
        IBbtnHamburger.setImage(UIImage(named: leftBarButtonImage), forState: .Normal)
        
    }
    
    /**
     Open Left Menu as child view controller
     */
    private func openLeftMenu(){
        addChildVC(forViewController: S_ID_LEFT_MENU_VC)
    }
    
    /**
     Open Filter Screen as child view controller
     */
    private func openFilterScreen(){
        addChildVC(forViewController: S_ID_FILTER_VC)
    }
    
    /**
     Enable/Disable header buttons, basically this prevents user to open menu if
     another is opened.
     */
    private func headerButtonEnabled(setEnabled setEnabled:Bool){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationItem.leftBarButtonItem?.enabled = setEnabled
            self.navigationItem.rightBarButtonItem?.enabled = setEnabled
        }
    }
    
    /**
     Open ChildViewController for given ViewController's Storyboard ID
     - parameter VCName: ViewController's Storyboard ID
     */
    private func addChildVC(forViewController VCName:String){
        headerButtonEnabled(setEnabled: false)
        
        if VCName == S_ID_LEFT_MENU_VC{
            addLeftMenuAsChildVC(viewControllerName: VCName)
        }else if VCName == S_ID_FILTER_VC{
            addFilterVCAsChildVC(viewControllerName: VCName)
        }else if VCName == S_ID_LAUNCH_LOADING_VC{
            addLaunchLoadingAsChildVC(viewControllerName: VCName)
            removeChildVCIfExists(VCName)
        }
    }
    
    /**
     Adding Loading screen until data is fetched
     */
    private func addLaunchLoadingAsChildVC(viewControllerName VCName:String){
        let launchLoadingVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as! LaunchLoadingVC
        //        launchLoadingVC.delegate = self
        launchLoadingVC.view.frame.size = self.view.frame.size
        
        //Animate leftViewController entry
        //        leftMenuVC.view.frame.origin.x = -self.view.frame.size.width
        //        leftMenuVC.view.alpha = 0
        //        UIView.animateWithDuration(0.3) { () -> Void in
        //            leftMenuVC.view.alpha = 1
        //            leftMenuVC.view.frame.origin.x = 0
        //        }
        
        self.navigationController!.addChildViewController(launchLoadingVC)
        launchLoadingVC.didMoveToParentViewController(self)
        
        self.navigationController!.view.addSubview(launchLoadingVC.view)
    }
    
    /**
     Adding Left Menu As Child VC
     */
    private func addLeftMenuAsChildVC(viewControllerName VCName:String){
        if leftMenuChildVC == nil{
            leftMenuChildVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as? LeftMenuVC
            leftMenuChildVC!.delegate = self
        }
        
        
        leftMenuChildVC!.view.frame.size = self.view.frame.size
        navigationController!.addChildViewController(leftMenuChildVC!)
        leftMenuChildVC!.didMoveToParentViewController(self)
        
        navigationController?.view.addSubview(leftMenuChildVC!.view)
        
        var userDisplayName = S_LOGIN_REGISTER
        
        if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            if let displayName = UnlabelHelper.getDefaultValue(PRM_DISPLAY_NAME){
                userDisplayName = displayName
            }
        }
        
        leftMenuChildVC!.IBlblUserName.text = userDisplayName
        
        
        //Animate leftViewController entry
        leftMenuChildVC!.view.frame.origin.x = -self.view.frame.size.width
        leftMenuChildVC!.view.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.leftMenuChildVC!.view.alpha = 1
            self.leftMenuChildVC!.view.frame.origin.x = 0
            self.leftMenuChildVC?.view.frame.size.height = SCREEN_HEIGHT
        }
        
        
    }
    
    /**
     Adding Filter VC As Child VC
     */
    private func addFilterVCAsChildVC(viewControllerName VCName:String){
        if filterChildVC == nil{
            filterChildVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as? FilterVC
            filterChildVC!.delegate = self
        }
        
        filterChildVC?.selectedFilterType = (headerView?.selectedTab)!
        filterChildVC!.view.frame.size = self.view.frame.size
        navigationController!.addChildViewController(filterChildVC!)
        filterChildVC!.didMoveToParentViewController(self)
        
        navigationController?.view.addSubview(filterChildVC!.view)
        
        //Animate filterVC entry
        filterChildVC!.view.frame.origin.x = self.view.frame.size.width
        filterChildVC!.view.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.filterChildVC!.view.alpha = 1
            self.filterChildVC!.view.frame.origin.x = 0
            self.filterChildVC?.view.frame.size.height = SCREEN_HEIGHT
        }
        
        filterChildVC?.setupBeforeAppear()
    }
    
    /**
     Removes ChildViewController for given ViewController's Storyboard ID
     if already it exists, this happens when user click action to open
     ChildVC more than once.
     - parameter VCName: ViewController's Storyboard ID
     */
    private func removeChildVCIfExists(VCName:String){
        if isChildVCExists(vcName: VCName){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let childVCFromStoryboard:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(VCName)
                childVCFromStoryboard.willMoveToParentViewController(nil)
                childVCFromStoryboard.view.removeFromSuperview()
                childVCFromStoryboard.removeFromParentViewController()
            })
        }else{
            debugPrint("Child VC Doesn't existst for : \(VCName)")
        }
    }
    
    private func isChildVCExists(vcName VCName:String)->Bool{
        var isExists:Bool = false
        
        for vc in self.navigationController!.childViewControllers{
            let childVC:UIViewController = vc
            let childVCFromStoryboard:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(VCName)
            
            if isExists == false{
                if childVC.nibName == childVCFromStoryboard.nibName{
                    isExists = true
                }
            }
        }
        
        return isExists
    }
    
    private func handleLeftMenuSelection(forIndexPath indexPath:NSIndexPath){
        if indexPath.row == LeftMenuItems.Discover.rawValue{
            openDiscover()
        }else if indexPath.row == LeftMenuItems.Following.rawValue{
            openFollowing()
        } else if indexPath.row == LeftMenuItems.Settings.rawValue{
            openSettings()
        }
    }
    
    private func openDiscover(){
        
    }
    
    private func openFollowing(){
      performSegueWithIdentifier(S_ID_FOLLOWING_VC, sender: self)

    }
   
    private func openSettings(){
        performSegueWithIdentifier(S_ID_SETTINGS_VC, sender: self)
    }
    
    private func addTestData(){
        for _ in 0...39{
            arrFilteredBrandList.append(Brand())
            IBcollectionViewFeed.reloadData()
        }
    }
    
    private func popVC(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     Used whan hamberger on FeedVC and Back on Following Screen pressed or swiped from left to right
     */
    private func handleHamburgerAndBack(sender: AnyObject){
        if mainVCType.rawValue == MainVCType.Feed.rawValue{
            openLeftMenu()
        }else if mainVCType.rawValue == MainVCType.Following.rawValue{
            popVC()
        }else if mainVCType.rawValue == MainVCType.Filter.rawValue{
            popVC()
        }else{
            debugPrint("handleHamburgerAndBack uknown")
        }
    }
    
    private func handleFeedVCCellActivityIndicator(feedVCCell:FeedVCCell,shouldStop:Bool){
        feedVCCell.IBactivityIndicator.hidden = shouldStop
        if shouldStop {
            feedVCCell.IBactivityIndicator.stopAnimating()
        }else{
            feedVCCell.IBactivityIndicator.startAnimating()
        }
    }
    
//    private func updateFilterArray(){
//        let brands = brandsObj
//       arrFilteredBrandList = []
//        
//        for (_,var brand) in brands.enumerate(){
//            if filterType == .Men{
//                if brand.Menswear {
//                        
//                    if brand.Menswear && brand.Womenswear == true{
//                        brand.arrProducts = getFilteredProducts(forFilterType: filterType, arrProducts: brand.arrProducts)
//                    }
//                    
//                    arrFilteredBrandList.append(brand)
//                }else{
//                       
//                }
//                
//            }else if filterType == .Women{
//                if brand.Womenswear {
//                        
//                    if brand.Menswear && brand.Womenswear == true {
//                        brand.arrProducts = getFilteredProducts(forFilterType: filterType, arrProducts: brand.arrProducts)
//                    }
//                       
//                    arrFilteredBrandList.append(brand)
//                }else{
//                        
//                }
//            }else if filterType == .Both{
//            
//            }else{
//            
//            }
//        }
//
////        print(arrBrandList.count)
////        print(arrFilteredBrandList.count)
//        
//        arrBrandList = brandsObj
//        self.IBcollectionViewFeed.reloadData()
//    }
    
    private func getSelectedGender()->BrandGender{
        if headerView?.selectedTab == .Men{
            return BrandGender.Men
        }else if headerView?.selectedTab == .Women{
            return BrandGender.Women
        }else{
            return BrandGender.Men
        }
    }
    
    private func openLoginSignupVC(){
        if let loginSignupVC:LoginSignupVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_LOGIN_SIGNUP_VC) as? LoginSignupVC{
            loginSignupVC.delegate = self
            self.presentViewController(loginSignupVC, animated: true, completion: nil)
        }
    }
    
    private func updateFilterArray(){
        if headerView?.selectedTab == .Men{
            arrFilteredBrandList = arrMenBrandList
        }else if headerView?.selectedTab == .Women{
            arrFilteredBrandList = arrWomenBrandList
        }else{
            
        }
        IBcollectionViewFeed.reloadData()
    }
    
}


func getFilteredProducts(forFilterType filterType:FilterType,arrProducts:[Product])->[Product]{
    var filteredProducts = [Product]()
    if filterType == .Men{
        for product in arrProducts{
            if product.isMale || product.isUnisex{
                filteredProducts.append(product)
            }
        }
    }else{
        for product in arrProducts{
            if product.isFemale || product.isUnisex{
                filteredProducts.append(product)
            }
        }
    }
    
    return filteredProducts
}

//
//MARK:- Firebase Call Methods
//

extension FeedVC{
    /**
     Firebase call get all following brands
     */
   private func firebaseCallGetFollowingBrands(arBrands: [Brand]?){
      if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
         FirebaseHelper.getFollowingBrands(userID, withCompletionBlock: { (followingBrandIDs:[String]?) in
            if let followingBrandIDsObj = followingBrandIDs{
               var arrToBeUpdated = [Brand]()
               
               if arBrands != nil {
                  let hasFollowingBrands = arBrands!.filter {
                     let _brandID = $0.ID
                     return followingBrandIDsObj.filter { $0 == _brandID }.count > 0
                  }
                  arrToBeUpdated = hasFollowingBrands
               }
               
               if self.headerView?.selectedTab == .Men {
                  arrToBeUpdated = self.arrMenBrandList
               }else if self.headerView?.selectedTab == .Women{
                  arrToBeUpdated = self.arrWomenBrandList
               }else{
                  arrToBeUpdated = self.arrMenBrandList
               }
               
               for  brand in arrToBeUpdated {
                  if followingBrandIDsObj.contains(brand.ID){
                     brand.isFollowing = true
                  } else {
                     brand.isFollowing = false
                  }
               }
               
               if self.headerView?.selectedTab == .Men {
                  self.arrMenBrandList = arrToBeUpdated
               }else if self.headerView?.selectedTab == .Women{
                  self.arrWomenBrandList = arrToBeUpdated
               }else{
                  self.arrMenBrandList = arrToBeUpdated
               }
               
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                  self.IBcollectionViewFeed.reloadData()
               })
               
               // uncessary values here...
               //                    self.updateFilterArray()
            }
         })
      }
   }
}

//
//MARK:- WS Call Methods
//

extension FeedVC{
    /**
     WS call get all brands
     */
//    private func wsCallGetBrands(fetchBrandsRP:FetchBrandsRP){
//        
//    }
    
    
    func wsCallGetLabels(){
        wsCallGetLabelsResetOffset(true)
    }
    
    func wsCallGetLabelsResetOffset(reset:Bool) {
        var nextPageURL:String? = String()
        
        if headerView?.selectedTab == .Men{
            nextPageURL = nextPageURLMen
        }else if headerView?.selectedTab == .Women{
            nextPageURL = nextPageURLWomen
        }else{
            
        }
        
        if reset {
            if headerView?.selectedTab == .Men{
                nextPageURLMen = nil
                arrMenBrandList = []
            }else if headerView?.selectedTab == .Women{
                nextPageURLWomen = nil
                arrWomenBrandList = []
            }else{
            
            }
//            nextPageURL = nil
//            arrBrandList = []
        } else if let next:String = nextPageURL where next.characters.count == 0 {
            return
        }
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork() && !isLoading{
            isLoading = true
            
            if headerView?.selectedTab == .Men{
                if self.nextPageURLMen == nil {
                    UnlabelLoadingView.sharedInstance.start(view)
                }else{
                    self.bottonActivityIndicator.startAnimating()
                }

            }else if headerView?.selectedTab == .Women{
                if self.nextPageURLWomen == nil {
                    UnlabelLoadingView.sharedInstance.start(view)
                }else{
                    self.bottonActivityIndicator.startAnimating()
                }

            }else{
                UnlabelLoadingView.sharedInstance.start(view)
            }
            
            
        let fetchBrandsRequestParams = FetchBrandsRP()
        fetchBrandsRequestParams.filterCategory = self.sFilterCategory
        fetchBrandsRequestParams.filterLocation = self.sFilterLocation
            
        if headerView?.selectedTab == .Men{
            fetchBrandsRequestParams.nextPageURL = nextPageURLMen
        }else if headerView?.selectedTab == .Women{
            fetchBrandsRequestParams.nextPageURL = nextPageURLWomen
        }else{
            
        }
        
            fetchBrandsRequestParams.brandGender = getSelectedGender()
            
            if let selectedTab = headerView?.selectedTab{
                fetchBrandsRequestParams.selectedTab = selectedTab
            }
            
            
            UnlabelAPIHelper.sharedInstance.getBrands(fetchBrandsRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
                self.firebaseCallGetFollowingBrands(arrBrands)
                self.isLoading = false
                
                UnlabelLoadingView.sharedInstance.stop(self.view)
                self.bottonActivityIndicator.stopAnimating()
               
                self.arrFilteredBrandList = []
               
               
                if fetchBrandsRequestParams.selectedTab == .Men{
                    self.arrMenBrandList.appendContentsOf(arrBrands)
                    self.arrFilteredBrandList = self.arrMenBrandList
                    self.nextPageURLMen = meta["next"].stringValue
                }else if fetchBrandsRequestParams.selectedTab == .Women{
                    self.arrWomenBrandList.appendContentsOf(arrBrands)
                    self.arrFilteredBrandList = self.arrWomenBrandList
                    self.nextPageURLWomen = meta["next"].stringValue
                }else{
                
                }
                
//                self.updateFilterArray()
                self.refreshControl.endRefreshing()
               
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                  self.IBcollectionViewFeed.reloadData()
               })
               
                }, failed: { (error) in
                    self.isLoading = false
                    UnlabelLoadingView.sharedInstance.stop(self.view)
                    self.bottonActivityIndicator.stopAnimating()
                    debugPrint(error)
                    self.refreshControl.endRefreshing()
                    UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
            })
        }else{
            self.refreshControl.endRefreshing()
            if !ReachabilitySwift.isConnectedToNetwork(){
                UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
            }
        }
    }
}