    //
//  ViewController.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
    
enum MainVCType:Int{
    case Feed
    case Following
}
    
class FeedVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBbarBtnHamburger: UIBarButtonItem!
    @IBOutlet weak var IBbtnHamburger: UIButton!
    @IBOutlet weak var IBbarBtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBbtnUnlabel: UIButton!
    @IBOutlet weak var IBcollectionViewFeed: UICollectionView!
    
    private let FEED_CELL_HEIGHT:CGFloat = 211
    private let fFooterHeight:CGFloat = 28.0
    private let refreshControl = UIRefreshControl()
    private var arrBrandList:[Brand] = [Brand]()
    private var arrFilteredBrandList:[Brand] = [Brand]()
    private var didSelectIndexPath:NSIndexPath?
    private var filterChildVC:FilterVC?
    private var leftMenuChildVC:LeftMenuVC?
    private var mainVCType:MainVCType = .Feed

    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
//        wsCallGetLabels()
        setupOnLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            self.firebaseCallGetFollowingBrands()
        }
        UnlabelHelper.setAppDelegateDelegates(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- Navigation Methods
//
extension FeedVC{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_PRODUCT_VC{
            if let productVC:ProductVC = segue.destinationViewController as? ProductVC{
                if let brand:Brand = self.arrFilteredBrandList[self.didSelectIndexPath!.row]{
                    productVC.selectedBrand = brand
                    productVC.delegate = self
                    GAHelper.trackEvent(GAEventType.LabelClicked, labelName: brand.Name, productName: nil, buyProductName: nil)
                }
            }
        }
    }
}
    

//
//MARK:- UICollectionViewDelegate Methods
//
extension FeedVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        didSelectIndexPath = indexPath
        performSegueWithIdentifier(S_ID_PRODUCT_VC, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSizeMake(collectionView.frame.width, fFooterHeight)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
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
        return arrFilteredBrandList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let feedVCCell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_FeedVCCell, forIndexPath: indexPath) as! FeedVCCell
        feedVCCell.IBlblBrandName.text = arrFilteredBrandList[indexPath.row].Name.uppercaseString
        feedVCCell.IBlblLocation.text = "\(arrFilteredBrandList[indexPath.row].OriginCity), \(arrFilteredBrandList[indexPath.row].StateOrCountry)"
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
                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: false)
                }else{
                    handleFeedVCCellActivityIndicator(feedVCCell, shouldStop: true)
                }
            })
        }
        
        return feedVCCell
    }
}

    func handleFeedVCCellActivityIndicator(feedVCCell:FeedVCCell,shouldStop:Bool){
        feedVCCell.IBactivityIndicator.hidden = shouldStop
        if shouldStop {
            feedVCCell.IBactivityIndicator.stopAnimating()
        }else{
        feedVCCell.IBactivityIndicator.startAnimating()
        }
    }

//
//MARK:- UICollectionViewDelegateFlowLayout Methods
//
extension FeedVC:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, FEED_CELL_HEIGHT)
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
extension FeedVC:FilterVCDelegate{
    func didClickApply(forFilterModel filterModel: Brand) {
        
        //If anything from filter is selected
        if filterModel.Menswear || filterModel.Womenswear || filterModel.Clothing || filterModel.Accessories || filterModel.Jewelry || filterModel.Shoes || filterModel.Bags {
            arrFilteredBrandList = []
            for brand in arrBrandList{
                if (((filterModel.Menswear == brand.Menswear) && (filterModel.Menswear == true)) ||
                    ((filterModel.Womenswear == brand.Womenswear) && (filterModel.Womenswear == true)) ||
                    ((filterModel.Clothing == brand.Clothing) && (filterModel.Clothing == true)) ||
                    ((filterModel.Accessories == brand.Accessories) && (filterModel.Accessories == true)) ||
                    ((filterModel.Jewelry == brand.Jewelry) && (filterModel.Jewelry == true)) ||
                    ((filterModel.Shoes == brand.Shoes) && (filterModel.Shoes == true)) ||
                    ((filterModel.Bags == brand.Bags) && (filterModel.Bags == true))){
                        arrFilteredBrandList.append(brand)
                }
            }
    
        //Nothing selected in filter screen
        }else{
          debugPrint("Nothing Selected for filtering")
        }
        
        IBcollectionViewFeed.reloadData()
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
            
            }else{
                print("unknown vctype")
            }
        }
        print("reachabilityChanged : \(reachable)")
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
    }
    
    func didSelectViewLabels() {
        popVC()
    }
}
    
//
//MARK:- IBAction Methods
//
extension FeedVC{
    @IBAction func IBActionHamburger(sender: UIButton) {
        handleHamburgerAndBack(sender)
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
        openFilterScreen()
    }
    
    @IBAction func IBActionSwipeRight(sender: AnyObject) {
        handleHamburgerAndBack(sender)
    }
    
    @IBAction func IBActionSwipeLeft(sender: AnyObject) {
        openFilterScreen()
    }
    
    @IBAction func IBActionStarClicked(sender: UIButton) {
        
        //Internet available
        if ReachabilitySwift.isConnectedToNetwork(){
            if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
                if let selectedBrandID:String = arrFilteredBrandList[sender.tag].ID{
                    
                    //If already following
                    if arrFilteredBrandList[sender.tag].isFollowing{
                        arrFilteredBrandList[sender.tag].isFollowing = false
                        
                        //If not already following
                    }else{
                        arrFilteredBrandList[sender.tag].isFollowing = true
                    }
                    
                    FirebaseHelper.followUnfollowBrand(follow: arrFilteredBrandList[sender.tag].isFollowing, brandID: selectedBrandID, userID: userID, withCompletionBlock: { (error:NSError!, firebase:Firebase!) in
                        //Followd/Unfollowd brand
                        if error == nil{
                            self.firebaseCallGetFollowingBrands()
                        }else{
                            UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
                        }
                    })
                    
                    IBcollectionViewFeed.reloadData()
                }
            }
        }else{
            UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
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
    func setupOnLoad(){
        addPullToRefresh()
        IBbarBtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
                forState: UIControlState.Normal)
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCFooterCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell)
        IBbtnHamburger.tag = mainVCType.rawValue //Important to handle Hamburger and Back clicks
        
        if mainVCType == .Feed{
            wsCallGetLabels()
            IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Bold", size: 28)
            IBbtnUnlabel.titleLabel?.textColor = UIColor.blackColor()
            IBbtnUnlabel.setTitle("UNLABEL", forState: .Normal)
            self.IBbarBtnFilter.title = "FILTER     "
            self.IBbarBtnFilter.enabled = true
            IBbtnHamburger.setImage(UIImage(named: IMG_HAMBURGER), forState: .Normal)
        }else if mainVCType == .Following{
            addNotFoundView()
            IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 16)
            IBbtnUnlabel.titleLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
            IBbtnUnlabel.setTitle("FOLLOWING", forState: .Normal)
            self.IBbarBtnFilter.title = ""
            self.IBbarBtnFilter.enabled = false
            IBbtnHamburger.setImage(UIImage(named: IMG_BACK), forState: .Normal)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /**
    Add pull to refresh on Collectionview
     */
    func addPullToRefresh(){
        refreshControl.addTarget(self, action: #selector(FeedVC.wsCallGetLabels), forControlEvents: .ValueChanged)
        IBcollectionViewFeed.addSubview(refreshControl)
    }
    
    /**
     Open Left Menu as child view controller
     */
    func openLeftMenu(){
        addChildVC(forViewController: S_ID_LEFT_MENU_VC)
    }
    
    /**
     Open Filter Screen as child view controller
     */
    func openFilterScreen(){
        addChildVC(forViewController: S_ID_FILTER_VC)
    }
    
    /**
     Enable/Disable header buttons, basically this prevents user to open menu if
     another is opened.
     */
    func headerButtonEnabled(setEnabled setEnabled:Bool){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationItem.leftBarButtonItem?.enabled = setEnabled
            self.navigationItem.rightBarButtonItem?.enabled = setEnabled
        }
    }
    
    /**
     Open ChildViewController for given ViewController's Storyboard ID
     - parameter VCName: ViewController's Storyboard ID
     */
    func addChildVC(forViewController VCName:String){
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
    func addLaunchLoadingAsChildVC(viewControllerName VCName:String){
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
    func addLeftMenuAsChildVC(viewControllerName VCName:String){
        if leftMenuChildVC == nil{
            leftMenuChildVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as? LeftMenuVC
            leftMenuChildVC!.delegate = self
        }
        leftMenuChildVC!.view.frame.size = self.view.frame.size
        navigationController!.addChildViewController(leftMenuChildVC!)
        leftMenuChildVC!.didMoveToParentViewController(self)
        
        navigationController?.view.addSubview(leftMenuChildVC!.view)
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
    func addFilterVCAsChildVC(viewControllerName VCName:String){
        if filterChildVC == nil{
            filterChildVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as? FilterVC
            filterChildVC!.delegate = self
        }
        
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
    }

    /**
     Removes ChildViewController for given ViewController's Storyboard ID
     if already it exists, this happens when user click action to open
     ChildVC more than once.
     - parameter VCName: ViewController's Storyboard ID
     */
    func removeChildVCIfExists(VCName:String){
        if isChildVCExists(vcName: VCName){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let childVCFromStoryboard:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(VCName)
                childVCFromStoryboard.willMoveToParentViewController(nil)
                childVCFromStoryboard.view.removeFromSuperview()
                childVCFromStoryboard.removeFromParentViewController()
            })
        }else{
            print("Child VC Doesn't existst for : \(VCName)")
        }
    }

    func isChildVCExists(vcName VCName:String)->Bool{
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
    
    func handleLeftMenuSelection(forIndexPath indexPath:NSIndexPath){
        if indexPath.row == LeftMenuItems.Discover.rawValue{
            openDiscover()
//        }else if indexPath.row == LeftMenuItems.Following.rawValue{
//            openFollowing()
        }else if indexPath.row == LeftMenuItems.Settings.rawValue{
            openSettings()
        }
    }
    
    func openDiscover(){
        
    }
    
    func openFollowing(){
            if let feedVC:FeedVC = storyboard?.instantiateViewControllerWithIdentifier(S_ID_FEED_VC) as? FeedVC{
                feedVC.mainVCType = .Following
                navigationController?.showViewController(feedVC, sender: self)
        }
    }
    
    func openSettings(){
        performSegueWithIdentifier(S_ID_SETTINGS_VC, sender: self)
    }
    
    func addTestData(){
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
        }
    }
}

    //
    //MARK:- ProductVCDelegate Call Methods
    //
    
    extension FeedVC:ProductVCDelegate{
        func didClickFollow(forBrand brand: Brand) {
            arrFilteredBrandList[brand.currentIndex] = brand
            IBcollectionViewFeed.reloadData()
        }
    }
    
//
//MARK:- Firebase Call Methods
//

extension FeedVC{
    /**
    Firebase call get all following brands
     */
    func firebaseCallGetFollowingBrands(){
        if let userID = UnlabelHelper.getDefaultValue(PRM_USER_ID){
            FirebaseHelper.getFollowingBrands(userID, withCompletionBlock: { (followingBrandIDs:[String]?) in
                if let followingBrandIDsObj = followingBrandIDs{
                    for brand in self.arrBrandList{
                        if followingBrandIDsObj.contains(brand.ID){
                            brand.isFollowing = true
                        }
                    }

                    self.IBcollectionViewFeed.reloadData()
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
        func wsCallGetLabels(){
            //Internet available
            if ReachabilitySwift.isConnectedToNetwork(){
                UnlabelAPIHelper.getBrands({ (arrBrands:[Brand]) in
                    self.arrBrandList = arrBrands
                    self.arrFilteredBrandList = arrBrands
                    self.IBcollectionViewFeed.reloadData()
                    self.refreshControl.endRefreshing()
                }) { (error) in
                    print(error)
                    self.refreshControl.endRefreshing()
                    UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: S_TRY_AGAIN, onOk: {})
                }
            }else{
                self.refreshControl.endRefreshing()
                UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
            }
        }
    }