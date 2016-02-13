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

    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        awsCallFetchActiveBrands()
        setupUIOnLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UICollectionViewDelegate Methods
//
extension FeedVC:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(S_ID_LABEL_VC, sender: self)
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
        self.removeChildVCIfExists(VCName)
        
        if VCName == S_ID_LEFT_MENU_VC{
            addLeftMenuAsChildVC(viewControllerName: VCName)
        }else if VCName == S_ID_FILTER_VC{
            addFilterVCAsChildVC(viewControllerName: VCName)
        }
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
        let filterVC = self.storyboard?.instantiateViewControllerWithIdentifier(VCName) as! FilterVC
        filterVC.delegate = self
        filterVC.view.frame.size = self.view.frame.size
        
        //Animate filterVC entry
        filterVC.view.frame.origin.x = self.view.frame.size.width
        filterVC.view.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            filterVC.view.alpha = 1
            filterVC.view.frame.origin.x = 0
        }
        
        self.navigationController!.addChildViewController(filterVC)
        filterVC.didMoveToParentViewController(self)
        
        self.navigationController!.view.addSubview(filterVC.view)
    }

    /**
     Removes ChildViewController for given ViewController's Storyboard ID
     if already it exists, this happens when user click action to open
     ChildVC more than once.
     - parameter VCName: ViewController's Storyboard ID
     */
    func removeChildVCIfExists(VCName:String){
        for vc in self.navigationController!.childViewControllers{
            let childVC:UIViewController = vc
            let childVCFromStoryboard:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(VCName)
            
            if childVC.nibName == childVCFromStoryboard.nibName{ //This condition prevents user to open any child VC twice at a time
                childVC.willMoveToParentViewController(nil)
                childVC.view.removeFromSuperview()
                childVC.removeFromParentViewController()
            }
        }
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
                UnlabelHelper.showAlert(onVC: self, title: sSOMETHING_WENT_WRONG, message: exception.debugDescription, onOk: { () -> () in
                    
                })
                return nil
            }
            
            //If got result
            if let result = task.result{
                //If result items count > 0
                if let arrItems:[DynamoDB_Brand] = result.items as? [DynamoDB_Brand] where arrItems.count>0{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.arrBrandList = [Brand]()
                        for brand in arrItems{
                            let brandObj = Brand()
                            brandObj.dynamoDB_Brand = brand
                            
                            self.awsCallDownloadImage(forImageFileName: brand.ImageName) { (task:AWSS3TransferUtilityDownloadTask, forURL:NSURL?, data:NSData?, error:NSError?) -> () in
                                if let downloadedData = data{
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        brandObj.imgBrandImage = UIImage(data: downloadedData)!
                                        self.IBcollectionViewFeed.reloadData()
                                    })
                                }
                            }
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
    
    /**
     AWS call to download images
     */
    func awsCallDownloadImage(forImageFileName fileName:String,withCompletionHandler:(AWSS3TransferUtilityDownloadTask, NSURL?, NSData?, NSError?)->()){
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        
        let S3BucketName: String = "unlabel-userfiles-mobilehub-626392447"
        let S3DownloadKeyName: String = "public/\(fileName)"
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.downloadProgress = {(task: AWSS3TransferUtilityTask, bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) in
            dispatch_async(dispatch_get_main_queue(), {
                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                print("Progress is: \(progress)")
            })
        }
        
        completionHandler = { (task, location, data, error) -> Void in
            withCompletionHandler(task, location, data, error)
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        transferUtility.downloadToURL(nil, bucket: S3BucketName, key: S3DownloadKeyName, expression: expression, completionHander: completionHandler).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            if let exception = task.exception {
                print("Exception: \(exception.description)")
            }
            if let _ = task.result {
                print("Download Starting!")
            }
            return nil;
        }
        
    }
    
}