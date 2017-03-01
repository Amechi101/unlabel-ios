 //
 //  FeedVC.swift
 //  Unlabel
 //
 //  Created by Amechi Egbe on 12/11/15.
 //  Copyright © 2015 Unlabel. All rights reserved.
 //
 
 import UIKit
 import SDWebImage
 import SwiftyJSON
 import Alamofire
 // FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
 // Consider refactoring the code to use the non-optional operators.
 fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
 }
 
 // FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
 // Consider refactoring the code to use the non-optional operators.
 fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
 }
 
 
 enum MainVCType:Int{
  case feed
  case following
  case filter
 }
 
 enum FilterType:Int{
  case unknown
  case men
  case women
 }
 
 class FeedVC: UIViewController {
  
  //MARK:- IBOutlets, constants, vars
  @IBOutlet weak var IBbarBtnHamburger: UIBarButtonItem!
  @IBOutlet weak var IBbtnHamburger: UIButton!
  @IBOutlet weak var IBbtnUnlabel: UIButton!
  @IBOutlet weak var IBcollectionViewFeed: UICollectionView!
  
  @IBOutlet weak var bottonActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var IBbtnLeftBarButton: UIButton!
  
  
  
  fileprivate let FEED_CELL_HEIGHT:CGFloat = 211
  fileprivate let fFooterHeight:CGFloat = 28.0
  fileprivate let fHeaderHeight:CGFloat = 54.0
  fileprivate let refreshControl = UIRefreshControl()
  
  //    private var arrBrandList:[Brand] = [Brand]()
  var arrFilteredBrandList:[Brand] = [Brand]()
  
  fileprivate var arrMenBrandList:[Brand] = [Brand]()
  fileprivate var arrWomenBrandList:[Brand] = [Brand]()
  
  fileprivate var didSelectBrand:Brand?
  fileprivate var filterChildVC:FilterVC?
  fileprivate var headerView:FeedVCHeaderCell?
  
  var mainVCType:MainVCType = .feed
  var filteredNavTitle:String?
  var filteredString:String?
  var sFilterCategory:String?
  var sFilterStyle:String?
  var sortMode: String = "AZ"
  var searchResults:String = "Search Results"
  
  var sFilterLocation:String?
  
  //    var nextPageURL:String?
  var nextPageURLMen:String?
  var nextPageURLWomen:String?
  var nextPageURLBoth:String?
  
  var isLoading = false
  
  //MARK:- VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupOnLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    UnlabelHelper.setAppDelegateDelegates(self)
    wsCallGetLabels()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID) {
      wsCallGetLabelsResetOffset(false)
    }
    IBcollectionViewFeed.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
 }
 
 
 //MARK:- Navigation Methods
 
 extension FeedVC{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == S_ID_PRODUCT_VC{
      if let productVC:ProductVC = segue.destination as? ProductVC{
        if let brand:Brand = didSelectBrand{
          productVC.selectedBrand = brand
          productVC.delegate = self
          GAHelper.trackEvent(GAEventType.LabelClicked, labelName: brand.Name, productName: nil, buyProductName: nil)
        }
      }
    }else if segue.identifier == SEGUE_FILTER_LABELS{
      if let commonTableVC:CommonTableVC = segue.destination as? CommonTableVC{
        commonTableVC.commonVCType = .filterLabels
        commonTableVC.filterType = (headerView?.selectedTab)!
        commonTableVC.arrFilteredBrandList = arrFilteredBrandList
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == SEGUE_FILTER_LABELS{
      if headerView?.selectedTab == .men{
        return arrMenBrandList.count > 0
      }else if headerView?.selectedTab == .women{
        return arrWomenBrandList.count > 0
      }else{
        return false
      }
    }else{
      return true
    }
  }
 }
 
 
 //MARK:- UICollectionViewDelegate Methods
 
 extension FeedVC:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let brandAtIndexPath:Brand? = self.arrFilteredBrandList[indexPath.row]{
      didSelectBrand = brandAtIndexPath
    }
    performSegue(withIdentifier: S_ID_PRODUCT_VC, sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    
    switch kind {
      
    case UICollectionElementKindSectionHeader:
      headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: REUSABLE_ID_FeedVCHeaderCell, for: indexPath) as? FeedVCHeaderCell
      
      if mainVCType == .feed{
        headerView?.IBlblFilterTitle.isHidden = true
        headerView?.IBbtnMen.isHidden = false
        headerView?.IBbtnWomen.isHidden = false
        
        var selectedTabString = String()
        
        if headerView?.selectedTab == .men {
          selectedTabString = "Men"
        }else if headerView?.selectedTab == .women{
          selectedTabString = "Women"
        }else{
          
        }
        
        
        if let sFilterLocation = sFilterLocation{
          headerView?.IBlblFilterTitle.isHidden = false
          selectedTabString = selectedTabString + " - " + searchResults
        } else if let sFilterCategory  = sFilterCategory {
          headerView?.IBlblFilterTitle.isHidden = false
          selectedTabString =  selectedTabString + " - " + searchResults
        } else if let sFilterStyle = sFilterStyle {
          headerView?.IBlblFilterTitle.isHidden = false
          selectedTabString = selectedTabString + " - " + searchResults
        }
        
        headerView?.IBbtnMen.isHidden = !((headerView?.IBlblFilterTitle.isHidden)!)
        headerView?.IBbtnWomen.isHidden = !((headerView?.IBlblFilterTitle.isHidden)!)
        
        headerView?.IBlblFilterTitle.text = selectedTabString
        
      }else if mainVCType == .filter{
        
        
      }else{
        
      }
      
      
      return headerView!
      
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
 
 extension FeedVC:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    if arrFilteredBrandList.count > 0{
      headerView?.isHidden = false
      IBcollectionViewFeed.backgroundView?.isHidden = true
    }else{
      headerView?.isHidden = true
      IBcollectionViewFeed.backgroundView?.isHidden = false
    }
    
    return arrFilteredBrandList.count
    //  return 6
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    //        print("\(indexPath)")
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
 
 extension FeedVC:UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: SCREEN_WIDTH, height: fHeaderHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: FEED_CELL_HEIGHT)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: fFooterHeight)
  }
  
 }
 
 //MARK:- AppDelegateDelegates Methods
 
 extension FeedVC:AppDelegateDelegates{
  func reachabilityChanged(_ reachable: Bool) {
    if reachable{
      if mainVCType == .feed{
        if arrFilteredBrandList.count == 0{
          wsCallGetLabels()
        }
      }else if mainVCType == .following{
        
      }else if mainVCType == .filter{
        
      }else{
        debugPrint("unknown vctype")
      }
    }
    debugPrint("reachabilityChanged : \(reachable)")
  }
  
 }
 
 //MARK:- ProductVCDelegate Call Methods
 
 extension FeedVC:ProductVCDelegate{
  func didClickFollow(forBrand brand: Brand) {
  }
 }
 
 
 //MARK:- NotFoundView Methods
 
 extension FeedVC:NotFoundViewDelegate{
  /**
   If user not following any brand, show this view
   */
  func addNotFoundView(){
    let notFoundView:NotFoundView = Bundle.main.loadNibNamed("NotFoundView", owner: self, options: nil)! [0] as! NotFoundView
    notFoundView.delegate = self
    notFoundView.showViewLabelBtn = false
    notFoundView.IBlblMessage.text = "No brands available."
    IBcollectionViewFeed.backgroundView = notFoundView
    IBcollectionViewFeed.backgroundView?.isHidden = true
  }
  
  func didSelectViewLabels() {
    popVC()
  }
 }
 
 
 //MARK:- IBAction Methods
 
 extension FeedVC{
  @IBAction func IBActionHamburger(_ sender: UIButton) {
    //  handleHamburgerAndBack(sender)
  }
  
  @IBAction func IBActionSwipeRight(_ sender: AnyObject) {
    //  handleHamburgerAndBack(sender)
  }
  
  @IBAction func IBActionStarClicked(_ sender: UIButton) {
    
    //Internet available
    if ReachabilitySwift.isConnectedToNetwork(){
      if UnlabelHelper.isUserLoggedIn(){
        if let selectedBrandID:String = arrFilteredBrandList[sender.tag].ID{
          
          //If already following
          if arrFilteredBrandList[sender.tag].isFollowing{
            arrFilteredBrandList[sender.tag].isFollowing = false
          }else{
            arrFilteredBrandList[sender.tag].isFollowing = true
          }
          
          IBcollectionViewFeed.reloadData()
        //  debugPrint(arrFilteredBrandList)
        //  debugPrint([sender.tag])
          UnlabelAPIHelper.sharedInstance.followBrand(selectedBrandID, onVC: self, success:{ (
            meta: JSON) in
            if !(UnlabelHelper.getBoolValue(sFOLLOW_SEEN_ONCE)){
              self.addLikeFollowPopupView(FollowType.brand,initialFrame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
              UnlabelHelper.setBoolValue(true, key: sFOLLOW_SEEN_ONCE)
            }
        //    debugPrint(meta)
            
          }, failed: { (error) in
          })
        }
      }else{
      }
    }else{
      UnlabelHelper.showAlert(onVC: self, title: S_NO_INTERNET, message: S_PLEASE_CONNECT, onOk: {})
    }
  }
  
  @IBAction func IBActionSortFeed(_ sender: Any) {
    
    let array = ["1","2","3"]
    let paramsJSON = JSON(array)
    let arrString = paramsJSON.rawString(String.Encoding.utf8)
    
    print(arrString!)
    print(array)
    
  //  self.addSortPopupView(SlideUpView.brandSortMode,initialFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
  }
  
  
  @IBAction func IBActionFilterMen(_ sender: UIButton) {
    //        if let headerView = headerView{
    //            headerView.updateFilterHeader(forFilterType: .men)
    //            if arrMenBrandList.count == 0{
    //                wsCallGetLabels()
    //            }else{
    //                updateFilterArray()
    //            }
    //        }
  }
  
  @IBAction func IBActionFilterWomen(_ sender: UIButton) {
    //        if let headerView = headerView{
    //            headerView.updateFilterHeader(forFilterType: .women)
    //            if arrWomenBrandList.count == 0{
    //                wsCallGetLabels()
    //            }else{
    //                updateFilterArray()
    //            }
    //        }
  }
  
 }
 
 //MARK:- Sort Popup delegate Methods
 
 extension FeedVC: SortModePopupViewDelegate{
  func addSortPopupView(_ slideUpView: SlideUpView, initialFrame:CGRect){
    if let viewSortPopup:SortModePopupView = Bundle.main.loadNibNamed("SortModePopupView", owner: self, options: nil)? [0] as? SortModePopupView{
      viewSortPopup.delegate = self
      
    //  print(slideUpView)
      viewSortPopup.slideUpViewMode = slideUpView
      viewSortPopup.frame = initialFrame
      viewSortPopup.popupTitle = "SORT BY"
      self.view.addSubview(viewSortPopup)
      UIView.animate(withDuration: 0.2, animations: {
        viewSortPopup.frame = self.view.frame
        viewSortPopup.frame.origin = CGPoint(x: 0, y: 0)
        // viewSortPopup.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 0.5)
      })
      viewSortPopup.updateView()
      self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
  }
  func popupDidClickCloseButton(){
    self.tabBarController?.tabBar.isUserInteractionEnabled = true
  }
  func popupDidClickDone(_ selectedItem: UnlabelStaticList){
    self.tabBarController?.tabBar.isUserInteractionEnabled = true
    //print(sortMode)
    headerView?.IBSortButton.setTitle("Sort by: " + selectedItem.uName, for: .normal)
    self.sortMode = selectedItem.uId
    wsCallGetLabels()
  }
 }
 
 
 //MARK:- Custom Methods
 
 extension FeedVC{
  
  /**
   Setup UI on VC Load.
   */
  fileprivate func setupOnLoad(){
    registerCells()
    headerView?.selectedTab = .men
    setupNavBar()
    (IBcollectionViewFeed.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  /**
   Add pull to refresh on Collectionview
   */
  fileprivate func addPullToRefresh(){
    refreshControl.addTarget(self, action: #selector(FeedVC.wsCallGetLabels), for: .valueChanged)
    IBcollectionViewFeed.addSubview(refreshControl)
  }
  
  fileprivate func registerCells(){
    IBcollectionViewFeed.register(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
    IBcollectionViewFeed.register(UINib(nibName: REUSABLE_ID_FeedVCFooterCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: REUSABLE_ID_FeedVCFooterCell)
  }
  
  fileprivate func setupNavBar(){
    var titleText = "UNLABEL"
   // var leftBarButtonImage = IMG_HAMBURGER
    
    if mainVCType == .feed{
      addNotFoundView()
      addPullToRefresh()
    //  wsCallGetLabels()
      IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Bold", size: 28)
    }else if mainVCType == .filter{
      addNotFoundView()
      if let filteredNavTitleObj = filteredNavTitle{
        titleText = "\(filteredNavTitleObj)"
      }
      IBbtnUnlabel.titleLabel?.font = UIFont(name: "Neutraface2Text-Demi", size: 18)
      IBbtnUnlabel.setTitleColor(MEDIUM_GRAY_TEXT_COLOR, for: UIControlState())
    }
    
//    if self.navigationController?.viewControllers.count > 1{
//      leftBarButtonImage = IMG_BACK
//    }
    
    
    IBbtnUnlabel.titleLabel?.textColor = UIColor.black
    IBbtnUnlabel.setTitle(titleText.uppercased(), for: UIControlState())
    // IBbtnHamburger.setImage(UIImage(named: leftBarButtonImage), for: UIControlState())
    
  }
  
  
  /**
   Adding Loading screen until data is fetched
   */
  fileprivate func addLaunchLoadingAsChildVC(viewControllerName VCName:String){
    let launchLoadingVC = self.storyboard?.instantiateViewController(withIdentifier: VCName) as! LaunchLoadingVC
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
    launchLoadingVC.didMove(toParentViewController: self)
    
    self.navigationController!.view.addSubview(launchLoadingVC.view)
  }
  
  
  fileprivate func openDiscover(){
    
  }
  
  fileprivate func openFollowing(){
    // performSegue(withIdentifier: S_ID_FOLLOWING_VC, sender: self)
    
  }
  
  fileprivate func openSettings(){
    //  performSegue(withIdentifier: S_ID_SETTINGS_VC, sender: self)
  }
  
  fileprivate func addTestData(){
    for _ in 0...39{
      arrFilteredBrandList.append(Brand())
      IBcollectionViewFeed.reloadData()
    }
  }
  
  fileprivate func popVC(){
    _ = navigationController?.popViewController(animated: true)
  }
  
  fileprivate func handleFeedVCCellActivityIndicator(_ feedVCCell:FeedVCCell,shouldStop:Bool){
    feedVCCell.IBactivityIndicator.isHidden = shouldStop
    if shouldStop {
      feedVCCell.IBactivityIndicator.stopAnimating()
    }else{
      feedVCCell.IBactivityIndicator.startAnimating()
    }
  }
  
  fileprivate func getSelectedGender()->BrandGender{
    if headerView?.selectedTab == .men{
      return BrandGender.Men
    }else if headerView?.selectedTab == .women{
      return BrandGender.Women
    }else{
      return BrandGender.Men
    }
  }
  
  
  
  fileprivate func updateFilterArray(){
    if headerView?.selectedTab == .men{
      arrFilteredBrandList = arrMenBrandList
    }else if headerView?.selectedTab == .women{
      arrFilteredBrandList = arrWomenBrandList
    }else{
      
    }
    IBcollectionViewFeed.reloadData()
  }
  
  func getFilteredProducts(forFilterType filterType:FilterType,arrProducts:[Product])->[Product]{
    var filteredProducts = [Product]()
    if filterType == .men{
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
  
 }
 
 //MARK:- WS Call Methods
 
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
  
  func wsCallGetLabelsResetOffset(_ reset:Bool) {
    var nextPageURL:String? = String()
    
    if headerView?.selectedTab == .men{
      nextPageURL = nextPageURLMen
    }else if headerView?.selectedTab == .women{
      nextPageURL = nextPageURLWomen
    }else{
      
    }
    
    if reset {
      if headerView?.selectedTab == .men{
        nextPageURLMen = nil
        arrMenBrandList = []
      }else if headerView?.selectedTab == .women{
        nextPageURLWomen = nil
        arrWomenBrandList = []
      }else{
        
      }
      //            nextPageURL = nil
      //            arrBrandList = []
    } else if let next:String = nextPageURL, next.characters.count == 0 {
      return
    }
    //Internet available
    if ReachabilitySwift.isConnectedToNetwork() && !isLoading{
      isLoading = true
      
      if headerView?.selectedTab == .men{
        if self.nextPageURLMen == nil {
          UnlabelLoadingView.sharedInstance.start(view)
        }else{
          self.bottonActivityIndicator.startAnimating()
        }
        
      }else if headerView?.selectedTab == .women{
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
      fetchBrandsRequestParams.filterStyle = self.sFilterStyle
      fetchBrandsRequestParams.sortMode = self.sortMode
      
      if headerView?.selectedTab == .men{
        fetchBrandsRequestParams.nextPageURL = nextPageURLMen
      }else if headerView?.selectedTab == .women{
        fetchBrandsRequestParams.nextPageURL = nextPageURLWomen
      }else{
        
      }
      
      fetchBrandsRequestParams.brandGender = getSelectedGender()
      fetchBrandsRequestParams.sortMode = self.sortMode
      if let selectedTab = headerView?.selectedTab{
        fetchBrandsRequestParams.selectedTab = selectedTab
      }
      
      
      UnlabelAPIHelper.sharedInstance.getAllBrands(fetchBrandsRequestParams, success: { (arrBrands:[Brand], meta: JSON) in
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
          self.IBcollectionViewFeed.reloadData()
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
 
 //MARK: - Product status Popup view Delegate
 
 extension FeedVC: LikeFollowPopupviewDelegate{
  
  func addLikeFollowPopupView(_ followType:FollowType,initialFrame:CGRect){
    if let likeFollowPopup:LikeFollowPopup = Bundle.main.loadNibNamed(LIKE_FOLLOW_POPUP, owner: self, options: nil)? [0] as? LikeFollowPopup{
      likeFollowPopup.delegate = self
      likeFollowPopup.followType = followType
      likeFollowPopup.frame = initialFrame
      likeFollowPopup.alpha = 0
      view.addSubview(likeFollowPopup)
      UIView.animate(withDuration: 0.2, animations: {
        likeFollowPopup.frame = self.view.frame
        likeFollowPopup.frame.origin = CGPoint(x: 0, y: 0)
        likeFollowPopup.alpha = 1
        likeFollowPopup.updateView()
      })
    }
  }
  
  func popupDidClickClosePopup(){
    debugPrint("close popup")
  }
 }

