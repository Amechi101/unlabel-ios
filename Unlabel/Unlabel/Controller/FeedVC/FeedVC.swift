    //
//  ViewController.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB

class FeedVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBbarBtnHamburger: UIBarButtonItem!
    @IBOutlet weak var IBbarBtnFilter: UIBarButtonItem!
    @IBOutlet weak var IBbtnUnlabel: UIButton!
    @IBOutlet weak var IBcollectionViewFeed: UICollectionView!
    
    private let FEED_CELL_HEIGHT:CGFloat = 211
    var arrBrandList:[Brand] = [Brand]()
    
    var didSelectIndexPath:NSIndexPath?
    var filterChildVC:FilterVC?

    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
//        awsCallFetchActiveBrands()
        setupUIOnLoad()
    }
    
    override func viewWillAppear(animated: Bool) {

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
                    if let brand:Brand = self.arrBrandList[self.didSelectIndexPath!.row]{
                        productVC.selectedBrand = brand
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
}

//
//MARK:- UICollectionViewDataSource Methods
//
extension FeedVC:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrBrandList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let feedVCCell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSABLE_ID_FeedVCCell, forIndexPath: indexPath) as! FeedVCCell
        feedVCCell.IBlblBrandName.text = arrBrandList[indexPath.row].dynamoDB_Brand.BrandName.uppercaseString
        feedVCCell.IBlblLocation.text = arrBrandList[indexPath.row].dynamoDB_Brand.Location
        if let brandMainImage:UIImage = arrBrandList[indexPath.row].imgBrandImage{
            feedVCCell.IBimgBrandImage.image = brandMainImage
            feedVCCell.IBactivityIndicator.stopAnimating()
            feedVCCell.IBactivityIndicator.hidden = true
        }else{
            feedVCCell.IBactivityIndicator.startAnimating()
            feedVCCell.IBactivityIndicator.hidden = false
            feedVCCell.IBimgBrandImage.image = UIImage()
        }
        
        return feedVCCell
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

}

//
//MARK:- LeftMenuVCDelegate,FilterVCDelegate Common Delegate Methods
//
extension FeedVC{
    func willCloseChildVC(childVCName: String) {
        headerButtonEnabled(setEnabled: true)
    }
}


//
//MARK:- IBAction Methods
//
extension FeedVC{
    @IBAction func IBActionHamburger(sender: UIButton) {
        openLeftMenu()
    }
    
    @IBAction func IBActionFilter(sender: UIBarButtonItem) {
        openFilterScreen()
    }
}


//
//MARK:- Custom Methods
//
extension FeedVC{
    
    /**
     Setup UI on VC Load.
     */
    func setupUIOnLoad(){
        IBbarBtnFilter.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Neutraface2Text-Demi", size: 15)!],
                forState: UIControlState.Normal)
        IBcollectionViewFeed.registerNib(UINib(nibName: REUSABLE_ID_FeedVCCell, bundle: nil), forCellWithReuseIdentifier: REUSABLE_ID_FeedVCCell)
        self.automaticallyAdjustsScrollViewInsets = false
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
        self.navigationItem.leftBarButtonItem?.enabled = setEnabled
        self.navigationItem.rightBarButtonItem?.enabled = setEnabled
    }
    
    /**
     Open ChildViewController for given ViewController's Storyboard ID
     - parameter VCName: ViewController's Storyboard ID
     */
    func addChildVC(forViewController VCName:String){
        headerButtonEnabled(setEnabled: false)
        
        if VCName == S_ID_LEFT_MENU_VC{
            addLeftMenuAsChildVC(viewControllerName: VCName)
            removeChildVCIfExists(VCName)
        }else if VCName == S_ID_FILTER_VC{
            addFilterVCAsChildVC(viewControllerName: VCName) //Not removing child view controller, so that filter screen state remain same as last filter
        }else if VCName == S_ID_LAUNCH_LOADING_VC{
            addLaunchLoadingAsChildVC(viewControllerName: VCName)
            removeChildVCIfExists(VCName)
        }
    }

    /**
     Adding Loading screen until data is fetched
     */
    func addLaunchLoadingAsChildVC(viewControllerName VCName:String){
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
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
        let leftMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as! LeftMenuVC
        leftMenuVC.delegate = self
        leftMenuVC.view.frame.size = self.view.frame.size
        
        //Animate leftViewController entry
        leftMenuVC.view.frame.origin.x = -self.view.frame.size.width
        leftMenuVC.view.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            leftMenuVC.view.alpha = 1
            leftMenuVC.view.frame.origin.x = 0
        }
        
        self.navigationController!.addChildViewController(leftMenuVC)
        leftMenuVC.didMoveToParentViewController(self)
        
        self.navigationController!.view.addSubview(leftMenuVC.view)
    }
    
    /**
     Adding Filter VC As Child VC
     */
    func addFilterVCAsChildVC(viewControllerName VCName:String){
        if let filterChildVCObj = filterChildVC{
            //Animate filterVC entry
            filterChildVCObj.view.frame.origin.x = self.view.frame.size.width
            filterChildVCObj.view.alpha = 0
            UIView.animateWithDuration(0.3) { () -> Void in
                filterChildVCObj.view.alpha = 1
                filterChildVCObj.view.frame.origin.x = 0
            }
        }else{
            filterChildVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as? FilterVC
            filterChildVC!.delegate = self
            filterChildVC!.view.frame.size = self.view.frame.size
            
            //Animate filterVC entry
            filterChildVC!.view.frame.origin.x = self.view.frame.size.width
            filterChildVC!.view.alpha = 0
            UIView.animateWithDuration(0.3) { () -> Void in
                self.filterChildVC!.view.alpha = 1
                self.filterChildVC!.view.frame.origin.x = 0
            }
            
            self.navigationController!.addChildViewController(filterChildVC!)
            filterChildVC!.didMoveToParentViewController(self)
            
            self.navigationController!.view.addSubview(filterChildVC!.view)

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
        print(indexPath.row)
    }
    
    func addTestData(){
        for (var i = 0 ; i < 40 ; i++){
            arrBrandList.append(Brand())
        }
    }
}


//
//MARK:- AWS Call Methods
//

extension FeedVC{
    /**
     AWS call to fetch all active brands
     */
    func awsCallFetchActiveBrands(){
        
        let dynamoDBObjectMapper:AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        var scanExpression: AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "isActive = :val"
        scanExpression.expressionAttributeValues = [":val": true]
        
        dynamoDBObjectMapper.scan(DynamoDB_Brand.self, expression: scanExpression).continueWithSuccessBlock { (task:AWSTask) -> AnyObject? in
            
            //If error
            if let error = task.error{
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: error.localizedDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If exception
            if let exception = task.exception{
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.description, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If got result
            if let result = task.result{
                //If result items count > 0
                if let arrItems:[DynamoDB_Brand] = result.items as? [DynamoDB_Brand] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrBrandList = [Brand]()
                            for (index, brand) in arrItems.enumerate() {
                                let brandObj = Brand()
                                brandObj.dynamoDB_Brand = brand
                                AWSHelper.downloadImageWithCompletion(forImageName: brand.ImageName, uploadPathKey: pathKeyBrands, completionHandler: { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                        if let downloadedData = data{
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                if let image = UIImage(data: downloadedData){
                                                    brandObj.imgBrandImage = image
                                                    self.IBcollectionViewFeed.reloadItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
                                                }
                                            })
                                        }
                                    })
                                    self.arrBrandList.append(brandObj)
                        }
                        defer{
                            self.IBcollectionViewFeed.reloadData()
                        }
                })
                }else{
                    UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                    })
                }
            }else{
                UnlabelHelper.showAlert(onVC: self, title: "No Data Found", message: "Add some data", onOk: { () -> () in
                })
            }
            
            
            return nil
        }
    }
}